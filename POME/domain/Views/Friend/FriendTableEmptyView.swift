//
//  FriendTableEmptyView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/17.
//

import UIKit

class FriendTableEmptyView: BaseView {
    
    let stackView = UIStackView().then{
        $0.spacing = 12
        $0.axis = .vertical
        $0.alignment = .center
    }
    
    let emptyIcon = UIImageView().then{
        $0.image = Image.noting
    }
    
    let emptyLabel = UILabel().then{
        $0.text = "아직 추가한 친구가 없어요"
        $0.textColor = Color.grey5
        $0.font = UIFont.autoPretendard(type: .m_14)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hierarchy() {
        self.addSubview(stackView)
        
        stackView.addArrangedSubview(emptyIcon)
        stackView.addArrangedSubview(emptyLabel)
    }
    
    override func layout() {
        
        stackView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        emptyIcon.snp.makeConstraints{
            $0.width.height.equalTo(24)
        }
    }
}
