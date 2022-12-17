//
//  CategorySelectSheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/24.
//

import UIKit

class CategorySelectSheetViewController: BaseSheetViewController {
    
    //MARK: - Properties
    
    var categorySelectHandler: ((String) -> ())!
    
    var categoryArray = ["커피","아이스크림","음료","생활","통신"]
    
    let mainView = CategorySelectSheetView().then{
        $0.exitButton.addTarget(self, action: #selector(exitButtonDidClicked), for: .touchUpInside)
    }
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func style(){
        
        super.style()
        
        setBottomSheetStyle(type: .category)
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
        categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecordCategoryTableViewCell.cellIdentifier, for: indexPath) as? RecordCategoryTableViewCell else { return UITableViewCell() }
        
        cell.nameLabel.text = categoryArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? RecordCategoryTableViewCell,
                let categoryTitle = selectedCell.nameLabel.text else { return }
        
        categorySelectHandler(categoryTitle)
        self.dismiss(animated: true)
    }
    
}
