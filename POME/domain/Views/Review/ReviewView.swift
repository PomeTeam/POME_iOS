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
            $0.minimumLineSpacing = 8
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
    
    let reviewTitleLabel = UILabel().then{
        $0.text = "씀씀이 돌아보기"
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        $0.textColor = Color.title
    }
    
    let titleUnderStackView = UIStackView().then{
        $0.spacing = 86
        $0.distribution = .fill
    }
    
    let filterStackView = UIStackView().then{
        $0.spacing = 8
        $0.axis = .horizontal
    }
    
    let firstEmotionFilter = EmotionFilterView.generateFirstEmotionFilter()
    let secondEmotionFilter = EmotionFilterView.generateSecondEmotionFilter()
    
    let reloadingView = UIView()
    let reloadingLabel = UILabel().then{
        $0.text = "초기화"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey5
    }
    let reloadingImage = UIImageView().then{
        $0.image = Image.reloading
    }
    
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
        self.addSubview(reloadingView)
        self.addSubview(consumeTableView)
        
        goalBannerView.addSubview(goalTagStackView)
        goalBannerView.addSubview(goalTitleLabel)
        
        goalTagStackView.addArrangedSubview(goalIsPublicLabel)
        goalTagStackView.addArrangedSubview(goalRemainDateLabel)
        
        titleUnderStackView.addArrangedSubview(filterStackView)
        titleUnderStackView.addArrangedSubview(reloadingView)
        
        filterStackView.addArrangedSubview(firstEmotionFilter)
        filterStackView.addArrangedSubview(secondEmotionFilter)
        
        reloadingView.addSubview(reloadingLabel)
        reloadingView.addSubview(reloadingImage)
        
        titleUnderStackView.backgroundColor = .red
        reloadingView.backgroundColor = .blue
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
        
        titleUnderStackView.snp.makeConstraints{
            $0.top.equalTo(reviewTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
        }
        
//        filterStackView.snp.makeConstraints{
//        }

        consumeTableView.snp.makeConstraints{
            $0.top.equalTo(filterStackView.snp.bottom).offset(10 + 12 - 7)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

}

extension ReviewView{
    
    class EmotionFilterView: BaseView{
        
        enum FilterType{
            
            case first
            case second
            
            var title: String{
                switch self{
                case .first:        return "처음 감정"
                case .second:       return "돌아본 감정"
                    
                }
            }
        }
        
        //MARK: - Propertes
        
        var filterType: FilterType!
        
        lazy var filterButton = UIButton().then{
            $0.layer.cornerRadius = 30 / 2
            $0.backgroundColor = Color.grey1
        }
        
        let titleLabel = UILabel().then{
            $0.text = " "
            $0.setTypoStyleWithSingleLine(typoStyle: .title4)
        }
        
        let arrowImage = UIImageView().then{
            $0.image = Image.tagArrowDown
        }
        
        //MARK: - LifeCycle
        
        init(type: FilterType){
            self.filterType = type
            super.init(frame: .zero)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        //static factory method
        static func generateFirstEmotionFilter() -> EmotionFilterView{
            return EmotionFilterView(type: .first)
        }
        
        static func generateSecondEmotionFilter() -> EmotionFilterView{
            return EmotionFilterView(type: .second)
        }
        
        //MARK: - Method
        func setFilterDefaultState(){
            self.titleLabel.text = filterType.title
            self.titleLabel.textColor = Color.grey5
            self.filterButton.backgroundColor = Color.grey1
            self.arrowImage.tintColor = Color.grey5
        }
        
        func setFilterSelectState(){
            self.titleLabel.textColor = Color.pink100
            self.filterButton.backgroundColor = Color.pink10
            self.arrowImage.tintColor = Color.pink100
        }
        
        //MARK: - Override
        
        override func style() {
            self.setFilterDefaultState()
        }
        
        override func hierarchy() {
            
            super.hierarchy()
            
            self.addSubview(filterButton)
            
            filterButton.addSubview(titleLabel)
            filterButton.addSubview(arrowImage)
        }
        
        override func layout() {
            
            super.layout()
            
            filterButton.snp.makeConstraints{
                $0.top.bottom.leading.trailing.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints{
                $0.top.equalToSuperview().offset(5)
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(10)
            }
            
            arrowImage.snp.makeConstraints{
                $0.leading.equalTo(titleLabel.snp.trailing).offset(2)
                $0.trailing.equalToSuperview().offset(-10)
                $0.centerY.equalToSuperview()
                $0.width.height.equalTo(14)
            }
        }
        
    }
}
