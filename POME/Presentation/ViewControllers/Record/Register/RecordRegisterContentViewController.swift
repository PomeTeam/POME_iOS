//
//  RecordRegisterContentViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit
import RxSwift

class RecordRegisterContentViewController: BaseViewController {
    
    private var recordInput = RecordRegisterRequestManager.shared
    
    private let mainView = RecordRegisterContentView()
    private let viewModel = RecordRegisterContentViewModel(createRecordUseCase: DefaultCreateRecordUseCase())

    //MARK: - Override
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotifications()
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
    
    override func initialize() {
        mainView.priceField.infoTextField.delegate = self
        mainView.contentTextView.recordTextView.delegate = self
    }
    
    override func bind(){
        
        let input = RecordRegisterContentViewModel.Input(cateogrySelect: mainView.goalField.infoTextField.rx.text.orEmpty.asObservable(),
                                                         consumeDateSelect: mainView.dateField.infoTextField.rx.text.orEmpty.asObservable(),
                                                         priceTextField: mainView.priceField.infoTextField.rx.text.orEmpty.asObservable(),
                                                         detailTextView: mainView.contentTextView.recordTextView.rx.text.orEmpty.asObservable(),
                                                         detailTextViewplaceholder: mainView.contentTextView.recordTextView.placeholder,
                                                         nextButtonControlEvent: mainView.completeButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.highlightCalendarIcon
            .drive(mainView.dateField.rightImage.rx.isHighlighted)
            .disposed(by: disposeBag)
        
        output.canMoveNext
            .drive(mainView.completeButton.rx.isActivate)
            .disposed(by: disposeBag)
        
        self.view.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { _ in
                self.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        mainView.goalField.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { _ in
                self.categorySheetWillShow()
            }).disposed(by: disposeBag)
        
        mainView.dateField.rx.tapGesture()
            .when(.recognized)
            .bind(onNext: { _ in
                self.calendarSheetWillShow()
            }).disposed(by: disposeBag)
        
        mainView.completeButton.rx.tap
            .bind{
                self.completeButtonDidClicked()
            }.disposed(by: disposeBag)
        
    }
    
    //MARK: - Helper
    
    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Action
    
    private func calendarSheetWillShow(){
        
        let sheet = CalendarSheetViewController().loadAndShowBottomSheet(in: self)
        
        sheet.completion = { date in
            self.mainView.dateField.infoTextField.text = PomeDateFormatter.getDateString(date)
            self.mainView.dateField.infoTextField.sendActions(for: .valueChanged)
            
            self.recordInput.consumeDate = PomeDateFormatter.getDateString(date)
        }
    }
    
    private func categorySheetWillShow(){
        
        let sheet = CategorySelectSheetViewController().loadAndShowBottomSheet(in: self)
        
        sheet.categorySelectHandler = { title in
            self.recordInput.category = title
            self.mainView.goalField.infoTextField.text = title
            self.mainView.goalField.infoTextField.sendActions(for: .valueChanged)
        }
    }
    
    @objc private func completeButtonDidClicked(){
        
        /* 아래 코드 사용해서 text 데이터 추출하기 for 마지막 공백 제거
         mainView.contentTextView.recordTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
         */
        
        let vc = RecordRegisterEmotionSelectViewController()
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func backBtnDidClicked(){
    
        let dialog = ImageAlert.quitRecord.generateAndShow(in: self)
        dialog.completion = {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        /*
        let dialog = ImagePopUpViewController(imageValue: Image.penMint,
                                              titleText: "작성을 그만 두시겠어요?",
                                              messageText: "지금까지 작성한 내용은 모두 사라져요",
                                              greenBtnText: "그만 둘래요",
                                              grayBtnText: "이어서 쓸래요").show(in: self)
         */

    }
    
    @objc private func keyboardWillAppear(noti: NSNotification) {
        
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let moveHeight = keyboardRectangle.height - (52 + 10)
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -moveHeight)
                }
            )
        }
    }

    @objc private func keyboardWillDisappear(noti: NSNotification) {
        self.view.transform = .identity
    }

}

extension RecordRegisterContentViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn Execute")
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let text = textField.text else { return }

        if(textField == mainView.priceField.infoTextField){
            recordInput.price = text
        }
    }
}

extension RecordRegisterContentViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        guard let contentView = textView.superview as? CharactersCountTextView else { return }
        
        if textView.text == contentView.recordTextView.placeholder {
            contentView.setTextViewTextEditingMode()
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let contentView = textView.superview as? CharactersCountTextView else { return }
        
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if text.isEmpty {
            contentView.setTextViewTextEmptyMode()
        }
        
        recordInput.detail = text
    }
    
    func textViewDidChange(_ textView: UITextView){

        guard let contentView = textView.superview as? CharactersCountTextView else { return }

        contentView.updateCharactersCount(count: textView.text.count)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard let textSuperView = textView.superview as? CharactersCountTextView else { return false }

        if(textView.text.count < textSuperView.countLimit){
            return true
        }
        
        guard let oldString = textView.text, let changedRange = Range(range, in: oldString) else { return false }

        let newString = oldString.replacingCharacters(in: changedRange, with: text)

        return newString.count <= textSuperView.countLimit
    }
}

