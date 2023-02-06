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
    var goalContent: GoalResponseModel?
    
    var oneLineComment: String?

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
        if let goalContent = self.goalContent {
            commentView.goalView.setUpContent(goalContent)
        }
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
        if let oneLineComment = self.oneLineComment {
            let model = FinishGoalRequestModel(oneLineComment: oneLineComment)
            self.finishGoal(model)
        }
    }
    @objc func notSubmitButtonDidTap() {
        let dialog = ImageAlert.deleteEndGoal.generateAndShow(in: self)
        // 삭제하기 클릭 시
        dialog.completion = {
            // 목표를 삭제한다.
            self.deleteGoal(id: self.goalContent?.id ?? 0)
        }
    }
}
// MARK: - TextView delegate
extension CommentViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = Color.body
        } else {
            self.oneLineComment = textView.text
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        self.oneLineComment = textView.text
        commentView.countLabel.textColor = Color.body
        commentView.countLabel.text = "\(textView.text.count)/150"
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = Color.grey5
            
            commentView.countLabel.textColor = Color.grey2
            commentView.countLabel.text = "00/150"
        } else {
            self.oneLineComment = textView.text
        }
    }
}
// MARK: - API
extension CommentViewController {
    private func finishGoal(_ param: FinishGoalRequestModel) {
        GoalService.shared.finishGoal(id: self.goalContent?.id ?? 0, param: param) { result in
            print("목표 종료하기 성공")
            self.navigationController?.pushViewController(SubmitViewController(), animated: true)
        }
    }
    private func deleteGoal(id: Int){
        GoalService.shared.deleteGoal(id: id) { result in
            switch result{
            case .success(let data):
                if data.success {
                    print("목표 삭제 성공")
                    // 첫화면으로 전환
                    guard let tabBarController = UIStoryboard(name: "gomin", bundle: nil).instantiateViewController(identifier: "TabBarController") as? UITabBarController else {return}
                    self.navigationController?.pushViewController(tabBarController, animated: true)
                }
                break
            default:
                print(result)
                break
            }
        }
    }
}
