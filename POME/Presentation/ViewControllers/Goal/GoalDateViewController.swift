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
        
        output.canMoveNext
            .drive(mainView.completButton.rx.isActivate)
            .disposed(by: disposeBag)
        
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
    }
    
    //MARK: - Action
    
    override func backBtnDidClicked() {
        let dialog = ImagePopUpViewController(imageValue: Image.penMint,
                                              titleText: "작성을 그만 두시겠어요?",
                                              messageText: "지금까지 작성한 내용은 모두 사라져요",
                                              greenBtnText: "이어서 쓸래요",
                                              grayBtnText: "그만 둘래요")
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
    }
    
    private func calendarSheetWillShow(_ sender: UITapGestureRecognizer){
        
        guard let dateField = sender.view as? CommonRightButtonTextFieldView else { return }
        
        /*
        let sheet = CalendarSheetViewController().loadAndShowBottomSheet(in: self)
        */
        
        let sheet: CalendarSheetViewController = sender == mainView.startDateField ? CalendarSheetViewController() : EndDateCalendarSheetViewController(with: startDate)
        
        _ = sheet.loadAndShowBottomSheet(in: self)
        sheet.completion = { date in
            let dateString = PomeDateFormatter.getDateString(date)
            if(sheet == self.mainView.startDateField){
                self.startDate = dateString
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
