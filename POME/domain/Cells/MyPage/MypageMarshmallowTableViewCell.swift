//
//  MypageMarshmallowTableViewCell.swift
//  POME
//
//  Created by gomin on 2022/11/23.
//

import UIKit

class MypageMarshmallowTableViewCell: BaseTableViewCell {
    let titleLabel = UILabel().then{
        $0.text = "마시멜로 모으기"
        $0.setTypoStyleWithSingleLine(typoStyle: .title2)
        $0.textColor = Color.grey9
    }
    var marshmallowCollectionView: UICollectionView!

    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func setting() {
        super.setting()
        
        setUpCollectionView()
    }
    override func hierarchy() {
        super.hierarchy()
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(marshmallowCollectionView)
    }
    override func layout() {
        super.layout()
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(20)
        }
        marshmallowCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(500)        // 임시...
            make.bottom.equalToSuperview()
        }
    }
    func setUpCollectionView() {
        marshmallowCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
            let flowLayout = UICollectionViewFlowLayout().then{
                $0.minimumLineSpacing = 11
                $0.minimumInteritemSpacing = 11
                $0.scrollDirection = .vertical
                
                let bounds = UIScreen.main.bounds
                let width = ((bounds.size.width - 32) / 2) - 5.5
                
                $0.itemSize = CGSize(width: width, height: 180)
            }
            
            $0.collectionViewLayout = flowLayout
            $0.showsHorizontalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            $0.backgroundColor = Color.transparent
            
            $0.register(MarshmallowCollectionViewCell.self, forCellWithReuseIdentifier: MarshmallowCollectionViewCell.cellIdentifier)
        }
    }
}
