//
//  RecordRegisterContentViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit

class RecordRegisterContentViewController: BaseViewController {
    
    let mainView = RecordRegisterContentView().then{
        $0.completeButton.addTarget(self, action: #selector(completeButtonDidClicked), for: .touchUpInside)
    }

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func layout(){
        
        super.layout()
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Const.Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func initialize() {
        
        mainView.contentTextView.recordTextView.delegate = self
        
        mainView.goalField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(categorySheetWillShow)))
        mainView.dateField.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(calendarSheetWillShow)))
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTapped)))
    }
    
    //MARK: - Action
    
    @objc func viewDidTapped(){
        self.view.endEditing(true)
    }
    
    @objc func calendarSheetWillShow(){
        
        let sheet = CalendarSheetViewController()
        
        sheet.dateHandler = {
//            title in
//            self.mainView.goalField.infoTextField.text = title
        }
        
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true)
    }
    
    @objc func categorySheetWillShow(){
        
        let sheet = CategorySelectSheetViewController()
        
        sheet.categorySelectHandler = { title in
            self.mainView.goalField.infoTextField.text = title
        }
        
        sheet.loadViewIfNeeded()
        self.present(sheet, animated: true)
    }
    
    @objc func completeButtonDidClicked(){
        
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

}

extension RecordRegisterContentViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        guard let contentView = textView.superview as? CharactersCountTextView else { return }
        
        if textView.text == CharactersCountTextView.placeholder {
            contentView.setTextViewTextEditingMode()
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let contentView = textView.superview as? CharactersCountTextView else { return }
        
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contentView.setTextViewTextEmptyMode()
        }
    }
    
    func textViewDidChange(_ textView: UITextView){

        guard let contentView = textView.superview as? CharactersCountTextView else { return }

        contentView.updateCharactersCount(count: textView.text.count)
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if(textView.text.count < 150){
            return true
        }
        
        guard let oldString = textView.text, let changedRange = Range(range, in: oldString) else { return false }

        let newString = oldString.replacingCharacters(in: changedRange, with: text)

        return newString.count <= 150
    }
}

