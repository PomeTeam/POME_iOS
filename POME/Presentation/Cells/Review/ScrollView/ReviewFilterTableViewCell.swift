//
//  ReviewFilterTableViewCell.swift
//  POME
//
//  Created by 박지윤 on 2023/01/18.
//

import Foundation

protocol FilterDelegate{
    func willShowFilterBottomSheet(time: EmotionTime)
    func initializeFilteringCondition()
}

class ReviewFilterTableViewCell: BaseTableViewCell{
    
    var delegate: FilterDelegate?
    
    private let reviewTitleLabel = UILabel().then{
        $0.text = "씀씀이 돌아보기"
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        $0.textColor = Color.title
    }
    
    private let titleUnderView = UIView().then{
        $0.backgroundColor = Color.transparent
    }
    
    private let filterStackView = UIStackView().then{
        $0.spacing = 8
        $0.axis = .horizontal
    }
    
    let firstEmotionFilter = EmotionFilterView.generateFirstEmotionFilter()
    let secondEmotionFilter = EmotionFilterView.generateSecondEmotionFilter()
    
    lazy var reloadingButton = UIButton()
    
    private let reloadingLabel = UILabel().then{
        $0.text = "초기화"
        $0.setTypoStyleWithSingleLine(typoStyle: .subtitle2)
        $0.textColor = Color.grey5
        $0.textAlignment = .right
        $0.isUserInteractionEnabled = false
    }
    
    private let reloadingImage = UIImageView().then{
        $0.image = Image.reloading
        $0.isUserInteractionEnabled = false
    }
    
    override func hierarchy() {
        
        super.hierarchy()
        
        baseView.addSubview(reviewTitleLabel)
        baseView.addSubview(titleUnderView)
        baseView.addSubview(filterStackView)
        baseView.addSubview(reloadingButton)
        
        titleUnderView.addSubview(filterStackView)
        titleUnderView.addSubview(reloadingButton)
        
        filterStackView.addArrangedSubview(firstEmotionFilter)
        filterStackView.addArrangedSubview(secondEmotionFilter)
        
        reloadingButton.addSubview(reloadingLabel)
        reloadingButton.addSubview(reloadingImage)
    }
    
    
    override func layout() {
        
        super.layout()
        
        reviewTitleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(16)
        }
        
        titleUnderView.snp.makeConstraints{
            $0.top.equalTo(reviewTitleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().offset(-17)
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
    }
    
    override func initialize() {
        firstEmotionFilter.filterButton.addTarget(self, action: #selector(filterButtonDidTapped), for: .touchUpInside)
        secondEmotionFilter.filterButton.addTarget(self, action: #selector(filterButtonDidTapped), for: .touchUpInside)
        reloadingButton.addTarget(self, action: #selector(initializeButtonDidTapped), for: .touchUpInside)
    }
    
    @objc private func filterButtonDidTapped(_ sender: UIButton){
        guard let time = EmotionTime(rawValue: sender.tag) else { return }
        delegate?.willShowFilterBottomSheet(time: time)
    }
    
    @objc private func initializeButtonDidTapped(){
        delegate?.initializeFilteringCondition()
    }
}


extension ReviewFilterTableViewCell{
    
    class EmotionFilterView: BaseView{
        
        private let time: EmotionTime
        
        init(time: EmotionTime){
            self.time = time
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        lazy var filterButton = UIButton().then{
            $0.tag = time.rawValue
            $0.layer.cornerRadius = 30 / 2
        }
        
        private let titleLabel = UILabel().then{
            $0.setTypoStyleWithSingleLine(typoStyle: .title4)
            $0.isUserInteractionEnabled = false
        }
        
        private let arrowImage = UIImageView().then{
            $0.image = Image.tagArrowDown
            $0.isUserInteractionEnabled = false
        }
        
        static func generateFirstEmotionFilter() -> EmotionFilterView{
            EmotionFilterView(time: .first)
        }
        
        static func generateSecondEmotionFilter() -> EmotionFilterView{
            EmotionFilterView(time: .second)
        }
        
        //MARK: - Method
        func setFilterDefaultState(){
            titleLabel.text = time.title
            titleLabel.textColor = Color.grey5
            filterButton.backgroundColor = Color.grey1
            arrowImage.tintColor = Color.grey5
        }
        
        func setFilterSelectState(emotion: EmotionTag){
            titleLabel.text = emotion.message
            titleLabel.textColor = Color.pink100
            filterButton.backgroundColor = Color.pink10
            arrowImage.tintColor = Color.pink100
        }
        
        //MARK: - Override
        
        override func style() {
            setFilterDefaultState()
        }
        
        override func hierarchy() {
            super.hierarchy()
            addSubview(filterButton)
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
