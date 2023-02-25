//
//  GoalContentViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit
import RxSwift

class GoalContentViewController: BaseViewController {
    
    enum GoalError: String{
        case duplicateGoal = "G0004" //Goal 생성 시, 이미 등록된 Goal-Category 명으로 등록한 경우
        case `default`
    }
    
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

        let input = GoalContentRegisterViewModel.Input(categoryText: mainView.categoryField.infoTextField.rx.text.orEmpty.asObservable(),
                                                       promiseText: mainView.promiseField.infoTextField.rx.text.orEmpty.asObservable(),
                                                       priceText: mainView.priceField.infoTextField.rx.text.orEmpty.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.categoryText
            .drive(onNext: {
                self.goalDataManager.name = $0
            }).disposed(by: disposeBag)
        
        output.promiseText
            .drive(onNext: {
                self.goalDataManager.oneLineMind = $0
            }).disposed(by: disposeBag)

        output.priceText
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
        print(request)
        print("LOG: requestData requestGenerateGoal", request)
        
        GoalService.shared.generateGoal(request: request){ result in
            switch result{
            case .success:
                print("LOG: success requestGenerateGoal")
                self.processResponseGenerateGoal()
                return
            case.invalidSuccess(let code, let message):
                print("LOG: invalidSuccess requestGenerateGoal", message)
                self.checkErrorCode(code){ error in
                    switch error{
                    case .duplicateGoal:
                        self.processResponseDuplicateGoal()
                        return
                    default:
                        break
                    }
                }
            default:
                print(result)
                NetworkAlert.show(in: self){ [weak self] in
                    self?.requestGenerateGoal()
                }
                break
            }
        }
    }
    
    private func processResponseGenerateGoal(){
        let vc = RegisterSuccessViewController(type: .goal)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func checkErrorCode(_ code: String, closure: (GoalError) -> Void){
        let error = GoalError(rawValue: code) ?? .default
        closure(error)
    }
    
    private func processResponseDuplicateGoal(){
        RecordBottomSheetViewController(Image.flagMint,
                                        "이미 동일한 목표가 있어요",
                                        "새로운 목표를 만들어 기록을 작성해보세요!").loadAndShowBottomSheet(in: self)
    }
}
