//
//  GoalDateViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit

class GoalDateViewController: BaseViewController {
    
    let mainView = GoalDateView().then{
        $0.startDateField.calendarButton.addTarget(self, action: #selector(calendarButtonDidClicked), for: .touchUpInside)
        $0.endDateField.calendarButton.addTarget(self, action: #selector(calendarButtonDidClicked), for: .touchUpInside)
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
    
    @objc func calendarButtonDidClicked(_ sender: UIButton){
        
    }
    
    @objc func completeButtonDidClicked(){
        let vc = GoalContentViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
