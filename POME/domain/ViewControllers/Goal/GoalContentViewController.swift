//
//  GoalContentViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit

class GoalContentViewController: BaseViewController {
    
    let mainView = GoalContentView().then{
        $0.goalMakePublicSwitch.addTarget(self, action: #selector(goalMakePublicSwitchValueDidChanged(_:)), for: .valueChanged)
        $0.completeButton.addTarget(self, action: #selector(completeButtonDidClicked), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func style(){
        
        super.style()
        
        self.setEtcButton(title: "닫기")
        self.switchIsOn()
    }
    
    override func layout(){
        
        super.layout()
        
        self.view.addSubview(mainView)
    }
    
    override func initialize(){
        
        super.initialize()
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Const.Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.etcButton.addTarget(self, action: #selector(backBtnDidClicked), for: .touchUpInside)
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
    
    @objc func goalMakePublicSwitchValueDidChanged(_ sender: UISwitch){
        sender.isOn ? switchIsOn() : switchIsOff()
    }
    
    @objc func completeButtonDidClicked(){
        let vc = GoalRegisterSuccessViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func switchIsOn(){
        mainView.goalMakePublicView.backgroundColor = Color.pink10
    }
    
    private func switchIsOff(){
        mainView.goalMakePublicView.backgroundColor = Color.grey1
    }

}
