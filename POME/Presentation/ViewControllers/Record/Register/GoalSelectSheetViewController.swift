//
//  CategorySelectSheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit

class GoalSelectSheetViewController: BaseSheetViewController {
    
    //MARK: - Properties
    
    var completion: ((Int) -> ())! //TODO: WILL DELETE
    
    private var goals: [GoalResponseModel]!
    private let mainView = GoalSelectSheetView()
    private var viewModel: GoalSelectViewModel!
    //MARK: - LifeCycle
    
    init(data goals: [GoalResponseModel]){ //TODO: WILL DELETE
        self.goals = goals
        super.init(type: .category)
    }
    
    init(viewModel: RecordableViewModel){
        self.viewModel = viewModel
        super.init(type: .category)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.goalTableView.reloadData()
    }
    
    override func initialize(){
        super.initialize()
        mainView.exitButton.addTarget(self, action: #selector(exitButtonDidClicked), for: .touchUpInside)
        setTableViewDelegate()
    }
    
    private func setTableViewDelegate(){
        mainView.goalTableView.do{
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    override func layout(){
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func exitButtonDidClicked(){
        dismiss(animated: true)
    }
}

extension GoalSelectSheetViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getGoalCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(for: indexPath, cellType: RecordCategoryTableViewCell.self).then{
            $0.nameLabel.text = viewModel.getGoalTitle(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectGoal(at: indexPath.row)
        dismiss(animated: true)
    }
    
}
