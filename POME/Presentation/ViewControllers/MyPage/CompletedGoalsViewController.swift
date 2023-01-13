//
//  CompletedGoalsViewController.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class CompletedGoalsViewController: BaseViewController {
    let completeGoalLabel = UILabel().then{
        $0.text = "완료한 목표"
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        $0.textColor = Color.grey9
    }
    var completeGoalTableView: UITableView!

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func style() {
        super.style()
        
        setTableView()
        completeGoalTableView.delegate = self
        completeGoalTableView.dataSource = self
        
        EmptyView(self.completeGoalTableView).setCenterEmptyView(Image.noting, "저장된 목표가 없어요")
    }
    override func layout() {
        super.layout()
        
        self.view.addSubview(completeGoalLabel)
        self.view.addSubview(completeGoalTableView)
        
        completeGoalLabel.snp.makeConstraints { make in
            make.top.equalTo(super.navigationView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
        }
        completeGoalTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(completeGoalLabel.snp.bottom).offset(6)
        }
    }
    // MARK: - Methods
    func setTableView() {
        completeGoalTableView = UITableView().then{
            // 프로필
            $0.register(GoalTableViewCell.self, forCellReuseIdentifier: "GoalTableViewCell")
            
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = Color.transparent
            
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    @objc func menuButtonDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            let dialog = ImagePopUpViewController(imageValue: Image.trashGreen,
                                                  titleText: "종료된 목표를 삭제할까요?",
                                                  messageText: "지금까지 작성된 기록들은 모두 사라져요",
                                                  greenBtnText: "삭제할게요",
                                                  grayBtnText: "아니요")
            dialog.modalPresentationStyle = .overFullScreen
            self.present(dialog, animated: false, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel, handler: nil)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
}
// MARK: - TableView delegate
extension CompletedGoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalTableViewCell", for: indexPath) as? GoalTableViewCell else { return UITableViewCell() }
        if indexPath.row == 1 {cell.overGoal()} // 임시
        
        cell.menuButton.addTarget(self, action: #selector(menuButtonDidTap), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
