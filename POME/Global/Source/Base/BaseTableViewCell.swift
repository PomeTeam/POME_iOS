//
//  BaseTableViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/07.
//

import UIKit

class BaseTableViewCell: UITableViewCell, CellReuse {
    
    let baseView = UIView()
//        .then{
//        $0.backgroundColor = .white
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setting()
        hierarchy()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setting(){ //UITableViewCell의 프로퍼티등을 변경할 때 사용하는 메서드입니다.
        self.backgroundColor = Color.transparent
        self.selectedBackgroundView = UIView()
    }
    
    func hierarchy(){ //addSubView등 cell 위에 view를 추가할 때 사용하는 메서드입니다.
        self.contentView.addSubview(baseView)
    }
    
    func layout(){ //hierarchy에서 추가한 view의 레이아웃을 설정할 때 사용하는 메서드입니다.
        baseView.snp.makeConstraints{ make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    func getCellIndex() -> IndexPath?{
        
        guard let tableView = self.superview as? UITableView, let cellIndex =  tableView.indexPath(for: self) else { return nil }
        
        return cellIndex
    }
    
}
