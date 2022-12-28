//
//  GoalContentViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit

class GoalContentViewController: BaseViewController {
    
    //TODO: 유효성 검사 후 버튼 활성화
    
    let mainView = GoalContentView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func style(){
        
        super.style()
        
        self.setEtcButton(title: "닫기")
    }
    
    override func layout(){
        
        super.layout()
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Const.Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func initialize(){
        
        super.initialize()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(keyboardWillDisappear)))
        
        etcButton.addTarget(self, action: #selector(backBtnDidClicked), for: .touchUpInside)
        mainView.goalMakePublicSwitch.addTarget(self, action: #selector(publicSwitchBackgroundColorWillChange), for: .valueChanged)
        mainView.completeButton.addTarget(self, action: #selector(completeButtonDidClicked), for: .touchUpInside)
        
        mainView.categoryField.infoTextField.delegate = self
        mainView.promiseField.infoTextField.delegate = self
    }
    
    override func backBtnDidClicked() {
        let dialog = ImagePopUpViewController(Image.penMint,
                                              "작성을 그만 두시겠어요?",
                                              "지금까지 작성한 내용은 모두 사라져요",
                                              "이어서 쓸래요",
                                              "그만 둘래요")
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
    }
    
    @objc func publicSwitchBackgroundColorWillChange(_ sender: UISwitch){
        mainView.goalMakePublicView.backgroundColor = sender.isOn ? Color.pink10 : Color.grey1
    }
    
    @objc func completeButtonDidClicked(){
        let vc = RegisterSuccessViewController(type: .goal)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func keyboardWillDisappear(){
        self.view.endEditing(true)
    }
}

extension GoalContentViewController: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let oldString = textField.text else { return true }
        
        guard let textField = textField as? DefaultTextField, let textCountLimit = textField.countLimit else { return false }
        
        if(oldString.count < textCountLimit){
            return true
        }
        
        guard let changedRange = Range(range, in: oldString) else { return false}
        let newString = oldString.replacingCharacters(in: changedRange, with: string)
        
        return newString.count <= textCountLimit
    }
    
}

