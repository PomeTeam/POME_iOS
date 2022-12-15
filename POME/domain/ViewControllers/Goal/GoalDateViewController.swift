//
//  GoalDateViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit

class GoalDateViewController: BaseViewController {
    
    let mainView = GoalDateView().then{
        $0.startDateField.rightButton.addTarget(self, action: #selector(calendarButtonDidClicked), for: .touchUpInside)
        $0.endDateField.rightButton.addTarget(self, action: #selector(calendarButtonDidClicked), for: .touchUpInside)
        $0.completButton.addTarget(self, action: #selector(completeButtonDidClicked), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func layout() {
        super.layout()
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Const.Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func initialize(){
        
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
    
    @objc func calendarButtonDidClicked(_ sender: UIButton){
        
    }
    
    @objc func completeButtonDidClicked(){
        let vc = GoalContentViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
