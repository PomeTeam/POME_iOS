//
//  RecordRegisterContentViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit

class RecordRegisterContentViewController: BaseViewController {
    
    private var consumeCategoryInput: String = ""{
        didSet { checkCompleteButtoShouldActivatenAndChangeState() }
    }
    private var consumeDateInput: String = PomeDateFormatter.getTodayDate(){
        didSet { checkCompleteButtoShouldActivatenAndChangeState() }
    }
    private var consumePriceInput: String = ""{
        didSet { checkCompleteButtoShouldActivatenAndChangeState() }
    }
    private var consumeDetailInput: String = ""{
        didSet { checkCompleteButtoShouldActivatenAndChangeState() }
    }
    
    private let mainView = RecordRegisterContentView()

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTapped)))
        
        mainView.priceField.infoTextField.delegate = self
        mainView.contentTextView.recordTextView.delegate = self
        
        mainView.completeButton.addTarget(self, action: #selector(completeButtonDidClicked), for: .touchUpInside)
        
        mainView.goalField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(categorySheetWillShow)))
        mainView.dateField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(calendarSheetWillShow)))
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
    
    private func checkCompleteButtoShouldActivatenAndChangeState(){
        
        if(consumeCategoryInput.isEmpty || consumePriceInput.isEmpty || consumeDetailInput.isEmpty){
            mainView.completeButton.isActivate(false)
            return
        }
        
        mainView.completeButton.isActivate(true)
    }
    
    //MARK: - Action
    
    @objc private func viewDidTapped(){
        self.view.endEditing(true)
    }
    
    @objc private func calendarSheetWillShow(){
        
        let sheet = CalendarSheetViewController()
        
        sheet.completion = { date in
            self.consumeDateInput = PomeDateFormatter.getDateString(date)
            self.mainView.dateField.infoTextField.text = PomeDateFormatter.getDateString(date)
        }
        
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true)
    }
    
    @objc private func categorySheetWillShow(){
        
        let sheet = CategorySelectSheetViewController()
        
        sheet.categorySelectHandler = { title in
            self.consumeCategoryInput = title
            self.mainView.goalField.infoTextField.text = title
        }
        
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true)
    }
    
    @objc private func completeButtonDidClicked(){
        
        /* 아래 코드 사용해서 text 데이터 추출하기 for 마지막 공백 제거
         mainView.contentTextView.recordTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
         */
        
        let vc = RecordRegisterEmotionSelectViewController()
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func backBtnDidClicked(){
        let dialog = ImagePopUpViewController(Image.penMint,
                                              "작성을 그만 두시겠어요?",
                                              "지금까지 작성한 내용은 모두 사라져요",
                                              "이어서 쓸래요",
                                              "그만 둘래요")
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
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
            consumePriceInput = text
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
        
        consumeDetailInput = text
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

