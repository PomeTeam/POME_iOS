//
//  GoalView.swift
//  POME
//
//  Created by gomin on 2022/11/24.
//

import Foundation
import UIKit

class GoalWithProgressBarView: UIView {
    var goalIsPublicLabel = LockTagLabel.generateUnopenTag()
    var goalRemainDateLabel = DayTagLabel.generateDateEndTag()
    var menuButton = UIButton().then{
        $0.setImage(Image.moreVertical, for: .normal)
    }
    var goalTitleLabel = UILabel().then{
        $0.text = "커피 대신 물을 마시자"
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        $0.textColor = Color.title
    }
    let subTitleLabel = UILabel().then{
        $0.text = "사용 금액"
        $0.textColor = Color.grey5
        $0.setTypoStyleWithSingleLine(typoStyle: .title5)
    }
    var consumeLabel = UILabel().then{
        $0.text = "30,000원"
        $0.textColor = Color.body
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
    }
    var goalConsumeLabel = UILabel().then{
        $0.text = "· 100,000원"
        $0.textColor = Color.grey5
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
    }
    private let progressBarView = ProgressBarView()
    
    // MARK: - Life Cycles
    var isPublic: Bool?
    var remainDate: String?
    var goalTitle: String?
    var goalConsume: String?
    var consume: String?
    var ratio: CGFloat?
    
    init(_ isPublic: Bool? = nil,
         _ remainDate: String? = nil,
         _ goalTitle: String? = nil,
         _ goalConsume: String? = nil,
         _ consume: String? = nil,
         _ ratio: CGFloat? = nil) {
        
        super.init(frame: CGRect.zero)
        
        self.isPublic = isPublic
        self.remainDate = remainDate
        self.goalTitle = goalTitle
        self.goalConsume = goalConsume
        self.consume = consume
        self.ratio = ratio
        
        self.backgroundColor = .white
        self.layer.borderColor = Color.grey2.cgColor
        self.layer.borderWidth = 1
        self.setShadowStyle(type: .card)
        
        setUpContent()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Methods
    func setUpContent() {
        if self.isPublic ?? false {goalIsPublicLabel = LockTagLabel.generateOpenTag()}
        else {goalIsPublicLabel = LockTagLabel.generateUnopenTag()}
        
        goalTitleLabel.text = self.goalTitle
        goalConsumeLabel.text = "· " + (self.goalConsume ?? "")
        consumeLabel.text = self.consume
        
        if self.ratio ?? CGFloat(0) == CGFloat(0) {zeroRatio()}
        else if self.ratio ?? CGFloat(0) >= CGFloat(0.95) {overRatio()}
        else {
            self.progressBarView.ratio = self.ratio ?? CGFloat(0)
        }
    }
    func overRatio() {
        self.progressBarView.overProgressView()
    }
    func zeroRatio() {
        self.progressBarView.zeroProgressView()
    }
    // MARK: - Layouts
    func hierarchy() {
        self.addSubview(goalIsPublicLabel)
        self.addSubview(goalRemainDateLabel)
        self.addSubview(menuButton)
        
        self.addSubview(goalTitleLabel)
        self.addSubview(subTitleLabel)
        
        self.addSubview(consumeLabel)
        self.addSubview(goalConsumeLabel)
        
        self.addSubview(progressBarView)
    }
    func layout() {
        goalIsPublicLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(14)
        }
        goalRemainDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(goalIsPublicLabel.snp.trailing).offset(4)
            make.top.equalTo(goalIsPublicLabel)
        }
        menuButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(14)
        }
        goalTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(goalIsPublicLabel.snp.bottom).offset(6)
            make.leading.equalTo(goalIsPublicLabel)
            make.trailing.equalToSuperview().offset(-16)
        }
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(goalTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(goalTitleLabel)
        }
        consumeLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(2)
            make.leading.equalTo(subTitleLabel)
        }
        goalConsumeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(consumeLabel)
            make.leading.equalTo(consumeLabel.snp.trailing).offset(4)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        self.progressBarView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(goalConsumeLabel.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().offset(-14)
            $0.height.equalTo(22)
        }
    }
}
