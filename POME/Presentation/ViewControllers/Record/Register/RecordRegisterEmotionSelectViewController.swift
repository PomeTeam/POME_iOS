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
    private let viewModel = RecordRegisterEmotionSelectViewModel()
    private var recordManager = RecordRegisterRequestManager.shared
    
    //MARK: - Override
    
    override func style(){
        super.style()
        setEtcButton(title: "닫기")
    }
    
    override func layout(){
        
        super.layout()
        
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
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
        guard let view = mainView.viewWithTag(ViewTag.select) as? RecordRegisterEmotionSelectView.FirstEmotionView else { return }
        recordManager.emotion = view.emotion.rawValue

        requestGenerateRecord()
    }
    
    private func closeButtonDidClicked(){
        let dialog = ImageAlert.quitRecord.generateAndShow(in: self)
        dialog.completion = {
            self.recordManager.initialize()
            self.navigationController?.popToRootViewController(animated: true)
        }
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

//MARK: - API

extension RecordRegisterEmotionSelectViewController{
    
    private func requestGenerateRecord(){
        guard let price = Int(recordManager.price) else { return }
        let request = RecordRegisterRequestModel(goalId: recordManager.goalId,
                                                 emotionId: recordManager.emotion,
                                                 usePrice: price,
                                                 useDate: recordManager.consumeDate,
                                                 useComment: recordManager.detail)
        
        print(request)
        
        RecordService.shared.generateRecord(request: request){ result in
            switch result{
            case .success:
                print("LOG: success requestGenerateRecord")
                let vc = RegisterSuccessViewController(type: .consume)
                self.navigationController?.pushViewController(vc, animated: true)
                break
            default:
                print(result)
                NetworkAlert.show(in: self){ [weak self] in
                    self?.requestGenerateRecord()
                }
                break
            }
        }
    }
}
