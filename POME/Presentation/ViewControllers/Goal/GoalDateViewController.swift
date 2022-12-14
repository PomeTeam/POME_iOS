//
//  GoalDateViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/23.
//

import UIKit
import RxSwift
import RxCocoa

class GoalDateViewController: BaseViewController {
    
    let mainView = GoalDateView()
    private let viewModel = GoalDateRegisterViewModel(goalUseCase: DefaultCreateGoalUseCase(repository: DefaultGoalRepository()))
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
    
    override func initialize(){
        
        mainView.completButton.addTarget(self, action: #selector(completeButtonDidClicked), for: .touchUpInside)

        mainView.startDateField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(calendarSheetWillShow)))
        mainView.endDateField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(calendarSheetWillShow)))
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
    }
    
    //MARK: - Action
    
    override func backBtnDidClicked() {
        let dialog = ImagePopUpViewController(Image.penMint,
                                              "작성을 그만 두시겠어요?",
                                              "지금까지 작성한 내용은 모두 사라져요",
                                              "이어서 쓸래요",
                                              "그만 둘래요")
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
    }
    
    @objc func calendarSheetWillShow(_ sender: UITapGestureRecognizer){
        
        guard let dateField = sender.view as? CommonRightButtonTextFieldView else { return }
        
        let sheet = CalendarSheetViewController().loadAndShowBottomSheet(in: self)
        sheet.completion = { date in
            dateField.infoTextField.text = PomeDateFormatter.getDateString(date)
            dateField.infoTextField.sendActions(for: .valueChanged)
        }
    }
    
    @objc func completeButtonDidClicked(){
        let vc = GoalContentViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
