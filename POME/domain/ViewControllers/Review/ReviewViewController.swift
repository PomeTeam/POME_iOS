//
//  ReviewViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class ReviewViewController: BaseTabViewController {
    
    let mainView = ReviewView().then{
        $0.backgroundColor = .red
        $0.goalTagCollectionView.backgroundColor = .blue
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func style(){
        
        super.style()
    }
    
    override func layout(){
        
        super.layout()
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Const.Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func initialize(){
        mainView.goalTagCollectionView.delegate = self
        mainView.goalTagCollectionView.dataSource = self
        
        mainView.consumeTableView.delegate = self
        mainView.consumeTableView.dataSource = self
    }
}

extension ReviewViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoalCategoryCollectionViewCell.cellIdentifier, for: indexPath) as? GoalCategoryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setUnselectState()
        
        return cell
                
    }
    
    
}

extension ReviewViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConsumeReviewTableViewCell.cellIdentifier, for: indexPath) as? ConsumeReviewTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    
}
