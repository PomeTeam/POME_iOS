//
//  ReviewView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class ReviewView: BaseView {
    
    let goalTagCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.minimumInteritemSpacing = 8
        }
        
        $0.collectionViewLayout = flowLayout
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        $0.register(GoalCategoryCollectionViewCell.self, forCellWithReuseIdentifier: GoalCategoryCollectionViewCell.cellIdentifier)
    }
    
    let goalBannerView = UIView()
    let goalTagStackView = UIStackView()
    let goalIsPublicLabel = UILabel()
    let goalRemainDateLabel = UILabel()
    let goalTitleLabel = UILabel()
    
    let reviewTitleLabel = UILabel()
    
    let titleUnderStackView = UIStackView()
    
    let filterStackView = UIStackView()
    let firstEmotionFilter = FilterTagView()
    let secondEmotionFilter = FilterTagView()
    
    let reloadingStackView = UIStackView()
    let reloadingLabel = UILabel()
    let reloadingImage = UILabel()
    
    let consumeTableView = UITableView().then{
        $0.register(ConsumeReviewTableViewCell.self, forCellReuseIdentifier: ConsumeReviewTableViewCell.cellIdentifier)
    }
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Overrdie
    
    override func hierarchy(){
        
        self.addSubview(goalTagCollectionView)
        self.addSubview(goalBannerView)
        self.addSubview(reviewTitleLabel)
        self.addSubview(titleUnderStackView)
        self.addSubview(filterStackView)
        self.addSubview(reloadingStackView)
        self.addSubview(consumeTableView)
        
        goalBannerView.addSubview(goalTagStackView)
        goalBannerView.addSubview(goalTitleLabel)
        
        goalTagStackView.addArrangedSubview(goalIsPublicLabel)
        goalTagStackView.addArrangedSubview(goalRemainDateLabel)
        
        titleUnderStackView.addArrangedSubview(filterStackView)
        titleUnderStackView.addArrangedSubview(reloadingStackView)
        
        filterStackView.addArrangedSubview(firstEmotionFilter)
        filterStackView.addArrangedSubview(secondEmotionFilter)
    }
    
    override func layout() {
        
        goalTagCollectionView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(6)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        goalBannerView.snp.makeConstraints{
            $0.top.equalTo(goalTagCollectionView.snp.bottom).offset(18)
            $0.height.equalTo(83)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        reviewTitleLabel.snp.makeConstraints{
            $0.top.equalTo(goalBannerView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        
        filterStackView.snp.makeConstraints{
            $0.top.equalTo(reviewTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
        }
        
        consumeTableView.snp.makeConstraints{
            $0.top.equalTo(filterStackView.snp.bottom).offset(10 + 12 - 7)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

}

extension ReviewView{
    
    class FilterTagView: BaseView{
        
    }
}
