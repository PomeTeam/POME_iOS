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
}
// MARK: - TableView delegate
extension CompletedGoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalTableViewCell", for: indexPath) as? GoalTableViewCell else { return UITableViewCell() }
        
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
