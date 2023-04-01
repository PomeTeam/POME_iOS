//
//  GoalDateViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

struct GoalDateDTO{
    let startDate: String
    let endDate: String
}

@frozen
enum CalendarDate: Int{
    case start = 100
    case end = 200
}

class GoalDateViewController: BaseViewController {
    
    private let mainView = GoalDateView()
    private let viewModel = GoalDateRegisterViewModel()
    private let startDateCalendar = CalendarSheetViewController()
    private let endDateCalendar = EndDateCalendarSheetViewController()
    
    //MARK: - Override

    override func layout() {
        super.layout()
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
    
    override func bind(){
        
        let input = GoalDateRegisterViewModel.Input(ctaButtonTap: mainView.completButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        mainView.startDateField.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { sender in
                self.calendarSheetWillShow(date: .start)
            }).disposed(by: disposeBag)

        mainView.endDateField.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { sender in
                self.calendarSheetWillShow(date: .end)
            }).disposed(by: disposeBag)
        
        output.startDate
            .drive{ [weak self] in
                self?.endDateCalendar.setStartDate($0)
                self?.mainView.startDateField.infoTextField.text = $0
            }.disposed(by: disposeBag)
        
        output.endDate
            .drive{ [weak self] in
                self?.mainView.endDateField.infoTextField.text = $0
            }.disposed(by: disposeBag)
        
        output.willShowInvalidationLabel
            .drive(mainView.invalidationDateRangeLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.canMoveNext
            .drive(mainView.completButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        output.canSelectEndDate
            .drive(mainView.endDateField.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        output.isHighlightStartDateIcon
            .drive(mainView.startDateField.rightImage.rx.isHighlighted)
            .disposed(by: disposeBag)
        
        output.isHighlightEndDateIcon
            .drive(mainView.endDateField.rightImage.rx.isHighlighted)
            .disposed(by: disposeBag)
        
        output.goalDateRange
            .subscribe(onNext: { [weak self] in
                self?.willMoveGoalContentViewController(dateRange: $0)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Action
    
    override func backBtnDidClicked() {
        ImageAlert.quitRecord.generateAndShow(in: self).do{
            $0.completion = { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func calendarSheetWillShow(date calendarType: CalendarDate){
        
        let sheet: CalendarSheetViewController = {
            switch calendarType{
            case .start:    return startDateCalendar
            case .end:      return endDateCalendar
            }
        }()
        
        sheet.loadAndShowBottomSheet(in: self)
        sheet.completion = { date in
            self.viewModel.selectDate(tag: calendarType.rawValue, date)
        }
    }
    
    private func willMoveGoalContentViewController(dateRange: GoalDateDTO){
        let vc = GoalContentViewController(goalDateRange: dateRange)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
