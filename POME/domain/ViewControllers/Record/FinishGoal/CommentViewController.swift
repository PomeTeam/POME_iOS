//
//  CommentViewController.swift
//  POME
//
//  Created by gomin on 2022/11/24.
//

import UIKit

class CommentViewController: BaseViewController {
    let textViewPlaceHolder = "목표에 대한 한줄 코멘트를 남겨보세요"
    var commentView: CommentView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func style() {
        super.style()
        super.view.backgroundColor = .white
        
        commentView = CommentView()
        commentView.commentTextView.delegate = self
    }
    override func layout() {
        super.layout()
        
        self.view.addSubview(commentView)
        commentView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    override func initialize() {
        super.initialize()
        
        commentView.notSubmitButton.addTarget(self, action: #selector(notSubmitButtonDidTap), for: .touchUpInside)
        commentView.submitButton.addTarget(self, action: #selector(submitButtonDidTap), for: .touchUpInside)
    }

    // MARK: - Actions
    @objc func submitButtonDidTap() {
        self.navigationController?.pushViewController(SubmitViewController(), animated: true)
    }
    @objc func notSubmitButtonDidTap() {
        let dialog = ImagePopUpViewController(Image.trashGreen, "종료된 목표를 삭제할까요?", "지금까지 작성된 기록들은 모두 사라져요", "삭제할게요", "아니요")
        dialog.modalPresentationStyle = .overFullScreen
        self.present(dialog, animated: false, completion: nil)
    }
}
// MARK: - TextView delegate
extension CommentViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = Color.body
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        commentView.countLabel.textColor = Color.body
        commentView.countLabel.text = "\(textView.text.count)/150"
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = Color.grey5
            
            commentView.countLabel.textColor = Color.grey2
            commentView.countLabel.text = "00/150"
        }
    }
}
