//
//  GoalContentViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit
import RxSwift

class GoalContentViewController: BaseViewController {
    
    let mainView = GoalContentView()
    let viewModel = GoalContentRegisterViewModel(goalUseCase: DefaultCreateGoalUseCase(repository: DefaultGoalRepository()))
    
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
        
        output.canMoveNext
            .drive(mainView.completeButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        mainView.completeButton.rx.tap
            .bind{
                self.completeButtonDidClicked()
            }.disposed(by: disposeBag)
        
        mainView.goalMakePublicSwitch.rx.isOn
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { value in
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
        let dialog = ImagePopUpViewController(imageValue: Image.penMint,
                                              titleText: "작성을 그만 두시겠어요?",
                                              messageText: "지금까지 작성한 내용은 모두 사라져요",
                                              greenBtnText: "그만 둘래요",
                                              grayBtnText: "이어서 쓸래요").show(in: self)
        dialog.completion = {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func completeButtonDidClicked(){
        let vc = RegisterSuccessViewController(type: .goal)
        self.navigationController?.pushViewController(vc, animated: true)
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

