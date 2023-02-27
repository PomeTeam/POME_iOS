//
//  CategorySelectSheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit

class CategorySelectSheetViewController: BaseSheetViewController {
    
    //MARK: - Properties
    
    var completion: ((Int) -> ())!
    
    private let goals: [GoalResponseModel]
    private let mainView = CategorySelectSheetView().then{
        $0.exitButton.addTarget(self, action: #selector(exitButtonDidClicked), for: .touchUpInside)
    }
    
    //MARK: - LifeCycle
    
    init(data goals: [GoalResponseModel]){
        self.goals = goals
        super.init(type: .category)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initialize(){
        
        super.initialize()
        
        mainView.categoryTableView.delegate = self
        mainView.categoryTableView.dataSource = self
    }
    
    override func layout(){
        
        self.view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    @objc func exitButtonDidClicked(){
        self.dismiss(animated: true)
    }
}

extension CategorySelectSheetViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordCategoryTableViewCell.cellIdentifier, for: indexPath) as? RecordCategoryTableViewCell else { return UITableViewCell() }
        
        cell.nameLabel.text = goals[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? RecordCategoryTableViewCell,
                let categoryTitle = selectedCell.nameLabel.text else { return }
        */
        completion(indexPath.row)
        self.dismiss(animated: true)
    }
    
}
