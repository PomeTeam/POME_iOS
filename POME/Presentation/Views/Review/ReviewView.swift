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
            $0.scrollDirection = .horizontal
        }
        
        $0.collectionViewLayout = flowLayout
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        $0.register(GoalCategoryCollectionViewCell.self, forCellWithReuseIdentifier: GoalCategoryCollectionViewCell.cellIdentifier)
    }
    
    let goalBannerView = UIView().then{
        $0.layer.borderColor = Color.grey2.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .white
        $0.setShadowStyle(type: .card)
    }
    
    let goalTagStackView = UIStackView().then{
        $0.spacing = 4
        $0.axis = .horizontal
    }
    
    let goalIsPublicLabel = LockTagLabel.generateOpenTag()

    let goalRemainDateLabel = DayTagLabel.generateDateEndTag()
    
    let goalTitleLabel = UILabel().then{
        $0.text = "커피 대신 물을 마시자"
        $0.textColor = Color.title
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
    }
    
    let reviewTitleLabel = UILabel().then{
        $0.text = "씀씀이 돌아보기"
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        $0.textColor = Color.title
    }
    
    let titleUnderView = UIView()
    
    let filterStackView = UIStackView().then{
        $0.spacing = 8
        $0.axis = .horizontal
    }
    
    let firstEmotionFilter = EmotionFilterView.generateFirstEmotionFilter()
    let secondEmotionFilter = EmotionFilterView.generateSecondEmotionFilter()
    
    lazy var reloadingButton = UIButton()
    
    let reloadingLabel = UILabel().then{
        $0.text = "초기화"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey5
        $0.textAlignment = .right
        $0.isUserInteractionEnabled = false
    }
    let reloadingImage = UIImageView().then{
        $0.image = Image.reloading
        $0.isUserInteractionEnabled = false
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
        self.addSubview(titleUnderView)
        self.addSubview(filterStackView)
        self.addSubview(reloadingButton)
        self.addSubview(consumeTableView)
        
        goalBannerView.addSubview(goalTagStackView)
        goalBannerView.addSubview(goalTitleLabel)
        
        goalTagStackView.addArrangedSubview(goalIsPublicLabel)
        goalTagStackView.addArrangedSubview(goalRemainDateLabel)
        
        titleUnderView.addSubview(filterStackView)
        titleUnderView.addSubview(reloadingButton)
        
        filterStackView.addArrangedSubview(firstEmotionFilter)
        filterStackView.addArrangedSubview(secondEmotionFilter)
        
        reloadingButton.addSubview(reloadingLabel)
        reloadingButton.addSubview(reloadingImage)

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
        
        goalTagStackView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(14)
            $0.leading.equalToSuperview().offset(16)
        }
        
        goalTitleLabel.snp.makeConstraints{
            $0.top.equalTo(goalTagStackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalToSuperview().offset(-14)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        reviewTitleLabel.snp.makeConstraints{
            $0.top.equalTo(goalBannerView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
        }
        
        titleUnderView.snp.makeConstraints{
            $0.top.equalTo(reviewTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
        }
        
        filterStackView.snp.makeConstraints{
            $0.top.leading.bottom.equalToSuperview()
        }
        
        reloadingButton.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-6)
        }
        
        reloadingLabel.snp.makeConstraints{
            $0.top.leading.bottom.equalToSuperview()
        }
        
        reloadingImage.snp.makeConstraints{
            $0.width.height.equalTo(14)
            $0.leading.equalTo(reloadingLabel.snp.trailing).offset(2)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        consumeTableView.snp.makeConstraints{
            $0.top.equalTo(filterStackView.snp.bottom).offset(10 + 12 - 7)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

}

extension ReviewView{
    
    class EmotionFilterView: BaseView{
        
        //MARK: - Propertes
        
        var filterTime: EmotionTime!
        
        lazy var filterButton = UIButton().then{
            $0.layer.cornerRadius = 30 / 2
        }
        
        let titleLabel = UILabel().then{
            $0.setTypoStyleWithSingleLine(typoStyle: .title4)
            $0.isUserInteractionEnabled = false
        }
        
        let arrowImage = UIImageView().then{
            $0.image = Image.tagArrowDown
            $0.isUserInteractionEnabled = false
        }
        
        //MARK: - LifeCycle
        
        init(time: EmotionTime){
            self.filterTime = time
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
            return EmotionFilterView(time: .first)
        }
        
        static func generateSecondEmotionFilter() -> EmotionFilterView{
            return EmotionFilterView(time: .second)
        }
        
        //MARK: - Method
        func setFilterDefaultState(){
            self.titleLabel.text = filterTime.title
            self.titleLabel.textColor = Color.grey5
            self.filterButton.backgroundColor = Color.grey1
            self.arrowImage.tintColor = Color.grey5
        }
        
        func setFilterSelectState(emotion: EmotionTag){
            self.titleLabel.text = emotion.message
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
                $0.height.equalTo(30)
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
