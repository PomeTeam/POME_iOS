//
//  ReviewTestViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/04/03.
//

import Foundation

@frozen
enum EmotionTime: Int{
    case first = 100
    case second = 200
}

class ReviewTestViewController: BaseTabViewController{
    
    private var isPaging: Bool = false
    
    private let mainView = ReviewView()
    private let viewModel = ReviewViewModel()
    
    override func layout(){
        super.layout()
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(Offset.VIEW_CONTROLLER_TOP)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func initialize(){
        mainView.tableView.separatorStyle = .none
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
}

extension ReviewTestViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getGoalsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
    
    
}

extension ReviewTestViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return viewModel.getRecordsCount()
        }else if(section == 1 && isPaging && viewModel.hasNextPage()){
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
    
    
}

extension ReviewTestViewController{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > (contentHeight - height) {
            if isPaging == false && viewModel.hasNextPage() {
                beginPaging()
            }
        }
    }
    
    private func beginPaging(){
        
        isPaging = true
        viewModel.requestNextPage()
        
        DispatchQueue.main.async { [self] in
            mainView.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.requestGetRecords()
        }
    }
}
