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

class GoalDateViewController: BaseViewController {
    
    private var startDate: String!
    
    private let mainView = GoalDateView()
    private let viewModel = GoalDateRegisterViewModel(goalUseCase: DefaultCreateGoalUseCase(repository: DefaultGoalRepository()))
    private var goalDataManager = GoalRegisterRequestManager.shared
    
    //MARK: - Override
    
    override func layout() {
        
        super.layout()
        
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func bind(){
        let input = GoalDateRegisterViewModel.Input(startDateTextField:
                                                        mainView.startDateField.infoTextField.rx.text.orEmpty.asObservable(),
                                                    endDateTextField:
                                                        mainView.endDateField.infoTextField.rx.text.orEmpty.asObservable(),
                                                    completeButtonControlEvent: mainView.completButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        mainView.completButton.rx.tap
            .bind{
                self.completeButtonDidClicked()
            }.disposed(by: disposeBag)
        
        mainView.startDateField.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { sender in
                self.calendarSheetWillShow(sender)
            }).disposed(by: disposeBag)

        mainView.endDateField.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { sender in
                self.calendarSheetWillShow(sender)
            }).disposed(by: disposeBag)
        
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
    }
    
    //MARK: - Action
    
    override func backBtnDidClicked() {
        let dialog = ImageAlert.quitRecord.generateAndShow(in: self)
        dialog.completion = {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func calendarSheetWillShow(_ sender: UITapGestureRecognizer){
        
        guard let dateField = sender.view as? CommonRightButtonTextFieldView else { return }
   
        let sheet: CalendarSheetViewController = dateField == mainView.startDateField ? CalendarSheetViewController() : EndDateCalendarSheetViewController(with: startDate)
        _ = sheet.loadAndShowBottomSheet(in: self)
        sheet.completion = { date in
            let dateString = PomeDateFormatter.getDateString(date)
            if(dateField == self.mainView.startDateField){
                self.startDate = dateString
                self.goalDataManager.startDate = dateString
            }else{
                self.goalDataManager.endDate = dateString
            }
            dateField.infoTextField.text = dateString
            dateField.infoTextField.sendActions(for: .valueChanged)
        }
    }
    
    private func completeButtonDidClicked(){
        let vc = GoalContentViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
