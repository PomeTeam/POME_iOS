//
//  MyPageViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/06.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

final class MyPageViewController: BaseTabViewController {
    private let viewModel: any MyPageViewModelInterface
    
    // MARK: Init
    init(viewModel: any MyPageViewModelInterface = MyPageViewModel()){
        self.viewModel = viewModel
        super.init(btnImage: Image.setting)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Properties
    var mypageTableView: UITableView!


    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func style() {
        super.style()
        
    }
    override func layout() {
        super.layout()
        
        setTableView()
        
        self.view.addSubview(mypageTableView)
        mypageTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(super.navigationView.snp.bottom)
        }
    }
    
    override func initialize() {
//        setTableView()
        setTableViewDelegate()
    }
    
    override func topBtnDidClicked() {
        self.navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    override func bind() {
        guard let viewModel = viewModel as? MyPageViewModel else { return }
        
        let input = MyPageViewModel.Input()
        let output = viewModel.transform(input)
        
        output.goals
            .subscribe(onNext: { [self]
                let cell = self.mypageTableView.cellForRow(at: [0,1]) as? MypageGoalsTableViewCell
                cell?.bindingData($0)
//                mypageTableView.reloadData()
            }).disposed(by: disposeBag)
        
        output.marshmallows
                .subscribe(onNext: { [self] in
                mypageTableView.reloadData()
            }).disposed(by: disposeBag)
        
    }
    
    // MARK: Methods
    
    private func setTableViewDelegate() {
        mypageTableView.delegate = self
        mypageTableView.dataSource = self
    }
    
    private func setTableView() {
        mypageTableView = UITableView().then{
            // 프로필
            $0.register(cellType: MypageProfileTableViewCell.self)
            // 목표 보관함 가기
            $0.register(cellType: MypageGoalsTableViewCell.self)
            // 마시멜로 모아보기
            $0.register(cellType: MypageMarshmallowTableViewCell.self)
            
            $0.rowHeight = UITableView.automaticDimension
            $0.estimatedRowHeight = UITableView.automaticDimension
            
            $0.separatorStyle = .none
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = Color.transparent
            
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    // MARK: Actions
    @objc func marshmallowToolTopDidTap(tapGestureRecognizer: UITapGestureRecognizer) {
        LinkManager(self, .marshmallowToolTip)
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
        case 0:     return getProfileCell(indexPath: indexPath)
        case 1:     return getFinishedGoalsCell(indexPath: indexPath)
        default:    return getMarshmallowsCell(indexPath: indexPath)
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return tableView.rowHeight
   }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = indexPath.row
        tag == 1 ?
        self.navigationController?.pushViewController(CompletedGoalsViewController(), animated: true)
        : tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Setup TableView Cell
    private func getProfileCell(indexPath: IndexPath) -> BaseTableViewCell{
        mypageTableView.dequeueReusableCell(for: indexPath, cellType: MypageProfileTableViewCell.self).then{
            $0.setUpData()
            $0.selectionStyle = .none
        }
    }
    private func getFinishedGoalsCell(indexPath: IndexPath) -> BaseTableViewCell{
        mypageTableView.dequeueReusableCell(for: indexPath, cellType: MypageGoalsTableViewCell.self).then{
            $0.bindingData(viewModel.finishedGoals.count)
            $0.selectionStyle = .none
        }
    }
    private func getMarshmallowsCell(indexPath: IndexPath) -> BaseTableViewCell{
        mypageTableView.dequeueReusableCell(for: indexPath, cellType: MypageMarshmallowTableViewCell.self).then{
            $0.marshmallowCollectionView.delegate = self
            $0.marshmallowCollectionView.dataSource = self
            $0.marshmallowCollectionView.reloadData()
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(marshmallowToolTopDidTap(tapGestureRecognizer:)))
            $0.marshmallowToolTipLabel.addGestureRecognizer(tapGesture)
        }
    }
    
}
//MARK: - CollectionView Delegate
extension MyPageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MarshmallowCollectionViewCell.self)
        let tag = indexPath.row
        switch tag {
        case 0:
            cell.setUpMarshmallow(.record, viewModel.marshmallows.recordMarshmelloLv)
        case 1:
            cell.setUpMarshmallow(.emotion, viewModel.marshmallows.emotionMarshmelloLv)
        case 2:
            cell.setUpMarshmallow(.growth, viewModel.marshmallows.growthMarshmelloLv)
        default:
            cell.setUpMarshmallow(.honest, viewModel.marshmallows.honestMarshmelloLv)
        }
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        guard let cell = collectionView.cellForItem(at: indexPath) as? MarshmallowCollectionViewCell else { fatalError() }
        cell.isSelected = true
    }
    
}
