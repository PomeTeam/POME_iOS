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
    var completeGoalContent: [GoalResponseModel] = []

    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.getFinishedGoals()
    }
    
    override func style() {
        super.style()
        
        setTableView()
        completeGoalTableView.delegate = self
        completeGoalTableView.dataSource = self
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
            $0.register(GoalTableViewCell.self, forCellReuseIdentifier: "GoalTableViewCell")
            
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = Color.transparent
            
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    @objc func alertGoalMenuButtonDidTap(_ sender: GoalTapGesture) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction =  UIAlertAction(title: "삭제하기", style: UIAlertAction.Style.default){(_) in
            let dialog = ImageAlert.deleteEndGoal.generateAndShow(in: self)
            dialog.completion = {
                self.deleteGoal(id: sender.data?.id ?? 0)
            }
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
        let count = self.completeGoalContent.count ?? 0
        if count == 0 {
            EmptyView(self.completeGoalTableView).setCenterEmptyView(Image.noting, "저장된 목표가 없어요")
        } else {
            EmptyView(self.completeGoalTableView).hideEmptyView()
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalTableViewCell", for: indexPath) as? GoalTableViewCell else { return UITableViewCell() }
        let itemIdx = indexPath.item
        cell.setUpData(self.completeGoalContent[itemIdx])
        
        let deleteGoalGesture = GoalTapGesture(target: self, action: #selector(alertGoalMenuButtonDidTap(_:)))
        deleteGoalGesture.data = self.completeGoalContent[itemIdx]
        cell.menuButton.addGestureRecognizer(deleteGoalGesture)
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - API
extension CompletedGoalsViewController {
    private func getFinishedGoals(){
        GoalService.shared.getFinishedGoals { result in
            switch result{
            case .success(let data):
                self.completeGoalContent = data.content
                self.completeGoalTableView.reloadData()
                
                break
            default:
                print(result)
                break
            }
        }
    }
    private func deleteGoal(id: Int){
        GoalService.shared.deleteGoal(id: id) { result in
            switch result{
            case .success(let data):
                if data.success! {
                    print("목표 삭제 성공")
                    self.getFinishedGoals()
                }
                break
            default:
                print(result)
                break
            }
        }
    }
}
