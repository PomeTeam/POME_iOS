//
//  GoalContentViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit
import RxSwift

enum GenerateGoalStatus: String{
    case success
    case duplicateGoal = "G0004" //Goal 생성 시, 이미 등록된 Goal-Category 명으로 등록한 경우
}

class GenerateGoalContentViewController: BaseViewController {
    
    private let mainView = GoalContentView()
    private let viewModel = GenerateGoalContentViewModel()
    private let goalDateRange: GoalDateDTO
    
    //MARK: - Override
    
    init(goalDateRange: GoalDateDTO){
        self.goalDateRange = goalDateRange
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style(){
        super.style()
        self.setEtcButton(title: "닫기")
    }
    
    override func layout(){
        super.layout()
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func bind(){

        let input = GenerateGoalContentViewModel.Input(dateRange: goalDateRange,
                                                       goal: mainView.categoryField.infoTextField.rx.text.orEmpty.asObservable(),
                                                       oneLineMind: mainView.promiseField.infoTextField.rx.text.orEmpty.asObservable(),
                                                       price: mainView.priceField.infoTextField.rx.text.orEmpty.asObservable(),
                                                       isPublic: mainView.goalMakePublicSwitch.rx.isOn.asObservable().startWith(true),
                                                       ctaButtonTap: mainView.completeButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.categoryBinding
            .drive(mainView.categoryField.infoTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.oneLineMindBinding
            .drive(mainView.promiseField.infoTextField.rx.text)
            .disposed(by: disposeBag)

        output.priceBinding
            .drive(mainView.priceField.infoTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.isPublicBinding
            .drive(onNext: { [weak self] value in
                self?.mainView.changeGoalMakePublicViewStatus(with: value)
            }).disposed(by: disposeBag)
        
        output.ctaButtonActivate
            .drive(mainView.completeButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        output.generateGoalStatusCode
            .subscribe(onNext: { [weak self] statusCode in
                switch statusCode {
                case .success:
                    self?.processResponseGenerateGoal()
                case .duplicateGoal:
                    self?.processResponseDuplicateGoal()
                }
            }).disposed(by: disposeBag)
        
        view.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        etcButton.rx.tap
            .bind{
                self.closeButtonDidClicked()
            }.disposed(by: disposeBag)
    }
    
    //MARK: - Helper
    
    private func closeButtonDidClicked(){
        ImageAlert.quitRecord.generateAndShow(in: self).do{
            $0.completion = {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func processResponseGenerateGoal(){
        let vc = RegisterSuccessViewController(type: .goal)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func processResponseDuplicateGoal(){
        RecordBottomSheetViewController(Image.flagMint,
                                        "이미 동일한 목표가 있어요",
                                        "새로운 목표를 만들어 기록을 작성해보세요!").loadAndShowBottomSheet(in: self)
    }
}
