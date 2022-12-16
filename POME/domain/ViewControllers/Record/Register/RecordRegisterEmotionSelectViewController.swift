//
//  RecordRegisterEmotionSelectViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit
import SnapKit

class RecordRegisterEmotionSelectViewController: BaseViewController{
    
    let mainView = RecordRegisterEmotionSelectView().then{
        $0.completeButton.addTarget(self, action: #selector(completeButtonDidClicked), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func style(){
        
        super.style()
        
        setEtcButton(title: "닫기")
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
        etcButton.addTarget(self, action: #selector(closeButtonDidClicked), for: .touchUpInside)
        
        mainView.happyEmotionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emotionDidSelected(_:))))
        mainView.whatEmotionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emotionDidSelected(_:))))
        mainView.sadEmotionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emotionDidSelected(_:))))
    }
    
    @objc func completeButtonDidClicked(){
        let vc = RegisterSuccessViewController(type: .consume)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func closeButtonDidClicked(){
        let dialog = ImagePopUpViewController(Image.penMint,
                                              "작성을 그만 두시겠어요?",
                                              "지금까지 작성한 내용은 모두 사라져요",
                                              "이어서 쓸래요",
                                              "그만 둘래요")
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
    }
    
    @objc func emotionDidSelected(_ sender: UITapGestureRecognizer){
        
        guard let selectEmotion = sender.view as? RecordRegisterEmotionSelectView.FirstEmotionView else { return }
        
        if(selectEmotion.tag == 1){
            return
        }
        
        guard let willDeselectEmotion = mainView.viewWithTag(1) as? RecordRegisterEmotionSelectView.FirstEmotionView else {
            selectEmotion.changeSelectState()
            return
        }
        
        willDeselectEmotion.changeDeselectSelect()
        selectEmotion.changeSelectState()
        
    }
}
