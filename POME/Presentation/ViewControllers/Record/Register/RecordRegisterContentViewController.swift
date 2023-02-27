//
//  RecordRegisterContentViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit
import RxSwift

class RecordRegisterContentViewController: BaseViewController {
    
    final private let baseGoal: GoalResponseModel!
    var goals = [GoalResponseModel]()
    
    let mainView: RecordContentView
    let viewModel = RecordRegisterContentViewModel(createRecordUseCase: DefaultCreateRecordUseCase())
    var recordManager = RecordRegisterRequestManager.shared
    
    //MARK: - Override
    
    convenience init(goal: GoalResponseModel){
        self.init(goal: goal, mainView: RecordRegisterContentView())
    }
    
    private init(goal: GoalResponseModel, mainView: RecordContentView){
        self.baseGoal = goal
        self.mainView = mainView
        super.init(nibName: nil, bundle: nil)
    }
    
    init(mainView: RecordContentView){
        self.baseGoal = nil
        self.mainView = mainView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestGetGoals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recordManager.initialize()
        recordManager.goalId = baseGoal.id
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
        bindingData()
    }
    
    func bindingData(){
        mainView.goalField.infoTextField.text = baseGoal.name
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
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(noti:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillDisappear(noti:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Action
    
    private func calendarSheetWillShow(){
        let sheet = CalendarSheetViewController().loadAndShowBottomSheet(in: self)
        sheet.completion = { date in
            self.mainView.dateField.infoTextField.text = PomeDateFormatter.getDateString(date)
            self.mainView.dateField.infoTextField.sendActions(for: .valueChanged)
            self.recordManager.consumeDate = PomeDateFormatter.getDateString(date)
        }
    }
    
    private func categorySheetWillShow(){
        let sheet = CategorySelectSheetViewController(data: goals).loadAndShowBottomSheet(in: self)
        sheet.completion = { selectIndex in
            let goal = self.goals[selectIndex]
            self.recordManager.goalId = goal.id
            self.mainView.goalField.infoTextField.text = goal.name
            self.mainView.goalField.infoTextField.sendActions(for: .valueChanged)
        }
    }
    
    @objc func completeButtonDidClicked(){
        let vc = RecordRegisterEmotionSelectViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func backBtnDidClicked(){
        let dialog = ImageAlert.quitRecord.generateAndShow(in: self)
        dialog.completion = {
            self.navigationController?.popViewController(animated: true)
        }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setFocusState()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if(textField == mainView.priceField.infoTextField){
            guard let text = textField.text else { return }
            recordManager.price = text.replacingOccurrences(of: ",", with: "")
        }
        textField.setUnfocusState()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if(textField != mainView.priceField.infoTextField){
            return false
        }
           
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 1,000,000
        formatter.locale = Locale.current
        formatter.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
        
        // formatter.groupingSeparator // .decimal -> ,
        
        if let removeAllSeprator = textField.text?.replacingOccurrences(of: formatter.groupingSeparator, with: ""){
            var beforeForemattedString = removeAllSeprator + string
            if formatter.number(from: string) != nil {
                if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                    textField.text = formattedString
                    return false
                }
            }else{ // 숫자가 아닐 때먽
                if string == "" { // 백스페이스일때
                    let lastIndex = beforeForemattedString.index(beforeForemattedString.endIndex, offsetBy: -1)
                    beforeForemattedString = String(beforeForemattedString[..<lastIndex])
                    if let formattedNumber = formatter.number(from: beforeForemattedString), let formattedString = formatter.string(from: formattedNumber){
                        textField.text = formattedString
                        return false
                    }
                }else{ // 문자일 때
                    return false
                }
            }
            
        }
        
        return true
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
        contentView.setTextViewUnfocusState()
        recordManager.detail = text
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

//MARK: - API
extension RecordRegisterContentViewController{
    private func requestGetGoals(){
        GoalService.shared.getUserGoals{ result in
            switch result{
            case .success(let data):
                print("LOG: success requestGetGoals", data.content)
                self.goals = data.content
                break
            default:
                print(result)
                NetworkAlert.show(in: self){ [weak self] in
                    self?.requestGetGoals()
                }
                break
            }
        }
    }
}

