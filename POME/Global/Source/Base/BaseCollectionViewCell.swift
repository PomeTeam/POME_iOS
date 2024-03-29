//
//  BaseCollectionViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/07.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell, CellReuse {
    
    let baseView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        style()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style() {
        self.backgroundColor = Color.transparent
    } //UICollectionViewCell의 프로퍼티등을 변경할 때 사용하는 메서드입니다.
    
    func hierarchy(){ //addSubView등 cell 위에 view를 추가할 때 사용하는 메서드입니다.
        self.contentView.addSubview(baseView)
    }
    
    func layout(){ //hierarchy에서 추가한 view의 레이아웃을 설정할 때 사용하는 메서드입니다.
        baseView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func getCellIndex() -> IndexPath?{
        
        guard let collectionView = self.superview as? UICollectionView, let cellIndex =  collectionView.indexPath(for: self) else { return nil }
        
        return cellIndex
    }
}
