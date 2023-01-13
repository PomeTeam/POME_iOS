//
//  RecordRegisterEmotionSelectViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class RecordRegisterEmotionSelectViewController: BaseViewController{
    
    private let mainView = RecordRegisterEmotionSelectView()
    private let viewModel = RecordRegisterEmotionSelectViewModel(createRecordUseCase: DefaultCreateRecordUseCase())
    
    //MARK: - Override
    
    override func style(){
        super.style()
        setEtcButton(title: "닫기")
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
    
    override func bind(){
        
        let input = RecordRegisterEmotionSelectViewModel.Input(happyEmotionSelect: mainView.happyEmotionView.rx.tapGesture().asObservable(),
                                                               whatEmotionSelect: mainView.whatEmotionView.rx.tapGesture().asObservable(),
                                                               sadEmotionSelect: mainView.sadEmotionView.rx.tapGesture().asObservable(),
                                                               completeButtonActiveStatus: mainView.completeButton.rx.tap)
        
//        let output = viewModel.transform(input: input)
//
//        output.canMoveNext
//            .drive(mainView.completeButton.isActivate)
//            .disposed(by: disposeBag)
        
        etcButton.rx.tap
            .bind{
                self.closeButtonDidClicked()
            }.disposed(by: disposeBag)
        
        mainView.completeButton.rx.tap
            .bind{
                self.completeButtonDidClicked()
            }.disposed(by: disposeBag)
        
        mainView.happyEmotionView.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: {
                self.emotionViewDidClicked($0)
            }).disposed(by: disposeBag)
        
        mainView.sadEmotionView.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: {
                self.emotionViewDidClicked($0)
            }).disposed(by: disposeBag)
        
        mainView.whatEmotionView.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: {
                self.emotionViewDidClicked($0)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Helper
    
    @objc func completeButtonDidClicked(){
        
        /* 선택한 emotion 정보 추출
         
        let view = mainView.viewWithTag(1) as! RecordRegisterEmotionSelectView.FirstEmotionView
        print(view.emotion)
         */
        
        let vc = RegisterSuccessViewController(type: .consume)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func closeButtonDidClicked(){
        let dialog = ImagePopUpViewController(Image.penMint,
                                              "작성을 그만 두시겠어요?",
                                              "지금까지 작성한 내용은 모두 사라져요",
                                              "이어서 쓸래요",
                                              "그만 둘래요")
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
    }
    
    private func emotionViewDidClicked(_ sender: UITapGestureRecognizer){
        
        if(!mainView.completeButton.isActivate){
            mainView.completeButton.isActivate = true
        }
        
        guard let selectEmotion = sender.view as? RecordRegisterEmotionSelectView.FirstEmotionView else { return }
        
        if(selectEmotion.tag == ViewTag.select){
            return
        }
        
        guard let willDeselectEmotion = mainView.viewWithTag(ViewTag.select) as? RecordRegisterEmotionSelectView.FirstEmotionView else {
            selectEmotion.changeSelectState()
            return
        }
        
        willDeselectEmotion.changeDeselectState()
        selectEmotion.changeSelectState()
        
    }
}
