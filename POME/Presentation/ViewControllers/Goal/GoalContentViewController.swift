//
//  GoalContentViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit
import RxSwift

class GoalContentViewController: BaseViewController {
    
    private let mainView = GoalContentView()
    private let viewModel = GoalContentRegisterViewModel(goalUseCase: DefaultCreateGoalUseCase(repository: DefaultGoalRepository()))
    private var goalDataManager = GoalRegisterRequestManager.shared
    
    //MARK: - Override
    
    override func style(){
        super.style()
        self.setEtcButton(title: "닫기")
    }
    
    override func layout(){
        
        super.layout()
        
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func initialize(){
        
        super.initialize()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillDisappear)))
        
        mainView.categoryField.infoTextField.delegate = self
        mainView.promiseField.infoTextField.delegate = self
        mainView.priceField.infoTextField.delegate = self
    }
    
    override func bind(){
        
        let input = GoalContentRegisterViewModel.Input(categoryTextField: mainView.categoryField.infoTextField.rx.text.orEmpty.asObservable(),
                                                       promiseTextField: mainView.promiseField.infoTextField.rx.text.orEmpty.asObservable(),
                                                       priceTextField: mainView.priceField.infoTextField.rx.text.orEmpty.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.category
            .drive(onNext: {
                self.goalDataManager.name = $0
            }).disposed(by: disposeBag)
        
        output.promise
            .drive(onNext: {
                self.goalDataManager.oneLineMind = $0
            }).disposed(by: disposeBag)

        output.price
            .drive(onNext: {
                self.goalDataManager.price = $0
            }).disposed(by: disposeBag)
        
        output.canMoveNext
            .drive(mainView.completeButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        mainView.completeButton.rx.tap
            .bind{
                self.requestGenerateGoal()
            }.disposed(by: disposeBag)
        
        mainView.goalMakePublicSwitch.rx.isOn
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { value in
                self.goalDataManager.isPublic = value
                self.mainView.changeGoalMakePublicViewStatus(with: value)
            })
            .disposed(by: disposeBag)
        
        etcButton.rx.tap
            .bind{
                self.closeButtonDidClicked()
            }.disposed(by: disposeBag)
    }
    
    //MARK: - Helper
    
    private func closeButtonDidClicked(){
        let dialog = ImageAlert.quitRecord.generateAndShow(in: self)
        dialog.completion = {
            self.goalDataManager.initialize()
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @objc func keyboardWillDisappear(){
        self.view.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate

extension GoalContentViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let textField = textField as? DefaultTextField else { return false }
        
        guard let oldString = textField.text, let textCountLimit = textField.countLimit else { return true }
        
        if(oldString.count < textCountLimit){
            return true
        }
        
        guard let changedRange = Range(range, in: oldString) else { return false}
        let newString = oldString.replacingCharacters(in: changedRange, with: string)
        
        return newString.count <= textCountLimit
    }
}


//MARK: - API
extension GoalContentViewController{
    
    private func requestGenerateGoal(){

        guard let price = Int(goalDataManager.price) else { return }
        let request = GoalRegisterRequestModel(name: goalDataManager.name,
                                               startDate: goalDataManager.startDate,
                                               endDate: goalDataManager.endDate,
                                               oneLineMind: goalDataManager.oneLineMind,
                                               price: price,
                                               isPublic: goalDataManager.isPublic)
        
        GoalServcie.shared.generateGoal(request: request){ result in
            switch result{
            case .success(let code):
                print("LOG: success requestGenerateGoal", code)
                self.processResponseGenerateGoal()
                break
            default:
                print(result)
                break
            }
        }
    }
    
    private func processResponseGenerateGoal(){
        goalDataManager.initialize()
        let vc = RegisterSuccessViewController(type: .goal)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
