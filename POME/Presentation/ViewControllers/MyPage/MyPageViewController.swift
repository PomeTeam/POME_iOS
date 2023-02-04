//
//  MyPageViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit

class MyPageViewController: BaseTabViewController {
    var mypageTableView: UITableView!
    var completedGoalCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewDidAppear(_ animated: Bool) {
        getFinishedGoalCounts()
    }
    
    override func style() {
        super.style()
        
        setTableView()
        mypageTableView.delegate = self
        mypageTableView.dataSource = self
    }
    override func layout() {
        super.layout()
        
        self.view.addSubview(mypageTableView)
        mypageTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    override func topBtnDidClicked() {
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    func setTableView() {
        mypageTableView = UITableView().then{
            // 프로필
            $0.register(MypageProfileTableViewCell.self, forCellReuseIdentifier: "MypageProfileTableViewCell")
            // 목표 보관함 가기
            $0.register(MypageGoalsTableViewCell.self, forCellReuseIdentifier: "MypageGoalsTableViewCell")
            // 마시멜로 모아보기
            $0.register(MypageMarshmallowTableViewCell.self, forCellReuseIdentifier: "MypageMarshmallowTableViewCell")
            
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
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = indexPath.row
        switch tag {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MypageProfileTableViewCell", for: indexPath) as? MypageProfileTableViewCell else { return UITableViewCell() }
            cell.setUpData()
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MypageGoalsTableViewCell", for: indexPath) as? MypageGoalsTableViewCell else { return UITableViewCell() }
            cell.setUpData(self.completedGoalCount)
            print(self.completedGoalCount)
            cell.selectionStyle = .none
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MypageMarshmallowTableViewCell", for: indexPath) as? MypageMarshmallowTableViewCell else { return UITableViewCell() }
            cell.marshmallowCollectionView.delegate = self
            cell.marshmallowCollectionView.dataSource = self
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return tableView.rowHeight
   }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = indexPath.row
        if tag == 1 {
            self.navigationController?.pushViewController(CompletedGoalsViewController(), animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - CollectionView Delegate
extension MyPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MarshmallowCollectionViewCell.cellIdentifier, for: indexPath)
                as? MarshmallowCollectionViewCell else { fatalError() }
        let tag = indexPath.row
        switch tag {
        case 0:
            cell.setUpMarshmallow(4, Image.marshmallowLevel4Pink)
        case 1:
            cell.setUpMarshmallow(1, Image.marshmallowLock)
        case 2:
            cell.setUpMarshmallow(4, Image.marshmallowLevel2Yellow)
        default:
            cell.setUpMarshmallow(4, Image.marshmallowLevel4Mint)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = ((bounds.size.width - 32) / 2) - 5.5
        
        return CGSize(width: width, height: 180)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        guard let cell = collectionView.cellForItem(at: indexPath) as? MarshmallowCollectionViewCell else { fatalError() }
        cell.isSelected = true
    }
    
}
//MARK: - API
extension MyPageViewController {
    private func getFinishedGoalCounts(){
        GoalService.shared.getFinishedGoals { result in
            switch result{
            case .success(let data):
                self.completedGoalCount = data.content.count
                self.mypageTableView.reloadData()
                break
            default:
                print(result)
                break
            }
        }
    }
}
