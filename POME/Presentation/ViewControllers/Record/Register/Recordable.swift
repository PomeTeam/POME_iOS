//
//  Recordable.swift
//  POME
//
//  Created by 박소윤 on 2023/03/27.
//

import Foundation
import RxSwift

class Recordable: BaseViewController{
    
    @frozen
    enum RecordType{
        case generate
        case modify
    }
    
    private lazy var keyboardController = KeyboardController(view: view, moveHeight: 52+10)
    private lazy var categoryBottomSheet = CategorySelectSheetViewController(viewModel: viewModel)
    let mainView: RecordContentView
    let viewModel: RecordableViewModel
    
    init(recordType: RecordType, viewModel: RecordableViewModel){
        self.mainView = recordType.mainView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        mainView.completeButton.setTitle(recordType.completeButtonTitle, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.viewWillAppear()
        keyboardController.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        keyboardController.removeKeyboardNotifications()
    }
    
    override func layout() {
        super.layout()
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func bind() {
        
        view.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        //calendar
        mainView.dateField.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                self?.calendarSheetWillShow()
            }).disposed(by: disposeBag)
        
        //category
        mainView.goalField.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                self?.categorySheetWillShow()
            }).disposed(by: disposeBag)
    }
    
    override func backBtnDidClicked(){
        ImageAlert.quitRecord.generateAndShow(in: self).do{
            $0.completion = {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func calendarSheetWillShow(){
        CalendarSheetViewController().loadAndShowBottomSheet(in: self).do{
            $0.completionTest = { [weak self] in
                self?.viewModel.selectConsumeDate($0)
            }
        }
    }
    
    private func categorySheetWillShow(){
        categoryBottomSheet.loadAndShowBottomSheet(in: self)
    }
}

extension Recordable.RecordType{
    
    var completeButtonTitle: String{
        switch self{
        case .generate:     return "작성했어요"
        case .modify:       return "수정했어요"
        }
    }
    
    var mainView: RecordContentView{
        switch self{
        case .generate:     return RecordRegisterContentView()
        case .modify:       return RecordContentView()
        }
    }
}