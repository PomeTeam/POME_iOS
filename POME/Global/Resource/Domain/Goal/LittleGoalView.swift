//
//  GoalView.swift
//  POME
//
//  Created by gomin on 2022/11/24.
//

import Foundation
import UIKit

class LittleGoalView: UIView {
    var goalIsPublicLabel = LockTagLabel.generateUnopenTag()
    var goalRemainDateLabel = DayTagLabel.generateDateEndTag()
    var goalTitleLabel = UILabel().then{
        $0.text = "커피 대신 물을 마시자"
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        $0.textColor = Color.title
    }
    
    // MARK: - Life Cycles
    var isPublic: Bool?
    var remainDate: String?
    var goalTitle: String?
    
    init() {
        
        super.init(frame: CGRect.zero)
        
        
        self.backgroundColor = .white
        self.layer.borderColor = Color.grey2.cgColor
        self.layer.borderWidth = 1
        self.setShadowStyle(type: .card)
        
//        setUpContent()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Methods
    func setUpContent(_ data: GoalResponseModel) {
        self.isPublic = data.isPublic
        self.goalTitle = data.oneLineMind
        
        data.isPublic ? goalIsPublicLabel.setPublicState() : goalIsPublicLabel.setLockState()
        
        goalTitleLabel.text = self.goalTitle
        goalRemainDateLabel.setEnd()    // 기한이 지난 목표이기 때문에 무조건 END 태그
    }
    // MARK: - Layouts
    func hierarchy() {
        self.addSubview(goalIsPublicLabel)
        self.addSubview(goalRemainDateLabel)
        
        self.addSubview(goalTitleLabel)
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
        goalTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(goalIsPublicLabel.snp.bottom).offset(6)
            make.leading.equalTo(goalIsPublicLabel)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
