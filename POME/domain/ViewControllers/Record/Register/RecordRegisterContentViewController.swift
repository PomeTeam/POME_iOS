//
//  RecordRegisterContentViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit

class RecordRegisterContentViewController: BaseViewController {
    
    let mainView = RecordRegisterContentView().then{
        $0.completeButton.addTarget(self, action: #selector(completeButtonDidClicked), for: .touchUpInside)
    }

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func initialize() {
        
        mainView.goalField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cateogorySheetWillShow)))
    }
    
    //MARK: - Action
    
    @objc func cateogorySheetWillShow(){
        let sheet = CategorySelectSheetViewController()
        sheet.categorySelectHandler = { title in
            self.mainView.goalField.infoTextField.text = title
        }
        
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true)
    }
    
    @objc func completeButtonDidClicked(){
        let vc = RecordRegisterEmotionSelectViewController()
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func backBtnDidClicked(){
        let dialog = ImagePopUpViewController(Image.penMint,
                                              "작성을 그만 두시겠어요?",
                                              "지금까지 작성한 내용은 모두 사라져요",
                                              "이어서 쓸래요",
                                              "그만 둘래요")
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
    }

}
