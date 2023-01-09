//
//  EmojiFloatingView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/09.
//

import UIKit

class EmojiFloatingView: BaseView {
    
    var dismissHandler: (() -> ())!
    
    let containerView = UIView().then{
        $0.backgroundColor = .white
        $0.setShadowStyle(type: .card)
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 54/2
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.itemSize = CGSize(width: EmojiFloatingCollectionViewCell.cellWidth, height: EmojiFloatingCollectionViewCell.cellWidth)
            $0.minimumLineSpacing = 14
            $0.minimumInteritemSpacing = 14
            $0.scrollDirection = .horizontal
        }
        
        $0.collectionViewLayout = flowLayout
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        $0.backgroundColor = Color.transparent
        
        $0.register(EmojiFloatingCollectionViewCell.self, forCellWithReuseIdentifier: EmojiFloatingCollectionViewCell.cellIdentifier)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func style() {
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        dismissGesture.delegate = self
        
        self.addGestureRecognizer(dismissGesture)
    }
    
    @objc func dismiss(){
        self.dismissHandler()
        self.removeFromSuperview()
    }
    
    override func hierarchy() {
        self.addSubview(containerView)
        containerView.addSubview(collectionView)
    }
    
    override func layout() {

        containerView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(23)
            $0.trailing.equalToSuperview().offset(-22)
            $0.height.equalTo(54)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    final func initialize(){
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        dismissGesture.delegate = self
        
        self.addGestureRecognizer(dismissGesture)
    }

}

extension EmojiFloatingView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        guard touch.view?.isDescendant(of: self.containerView) == false else { return false }
        
        return true
    }
}
