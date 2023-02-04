//
//  EmojiFloatingView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/09.
//

import UIKit

final class EmojiFloatingView: BaseView {
    
    var delegate: RecordCellWithEmojiDelegate!
    var completion: (() -> ())!
    
    let containerView = UIView().then{
        $0.backgroundColor = .white
        $0.setShadowStyle(type: .card)
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 54/2
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.minimumLineSpacing = 14
            $0.minimumInteritemSpacing = 14
            $0.scrollDirection = .horizontal
            $0.itemSize = CGSize(width: EmojiFloatingCollectionViewCell.cellWidth,
                                 height: EmojiFloatingCollectionViewCell.cellWidth)
        }
        
        $0.collectionViewLayout = flowLayout
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        $0.backgroundColor = Color.transparent
        
        $0.register(EmojiFloatingCollectionViewCell.self, forCellWithReuseIdentifier: EmojiFloatingCollectionViewCell.cellIdentifier)
    }
    
    override func style() {
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss)).then{
            $0.delegate = self
        }
        self.addGestureRecognizer(dismissGesture)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc func dismiss(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 10)
                self.layer.opacity = 0.0
            }, completion:{ finished in
                self.removeFromSuperview()
                self.completion()
            })
        }
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
    
    func show(in viewController: UIViewController, standard: BaseTableViewCell){

        viewController.view.addSubview(self)
        self.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        self.containerView.snp.makeConstraints{
            $0.top.equalTo(standard.baseView.snp.bottom).offset(-4)
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: -10)
            } completion: { finished in
                UIView.animate(withDuration: 0.5, delay: 0) {
                    self.containerView.transform = .identity
                }
            }
            
        }
    }
    
    func show(in viewController: UIViewController, standard: BaseView){

        viewController.view.addSubview(self)
        self.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        self.containerView.snp.makeConstraints{
            $0.top.equalTo(standard.snp.bottom).offset(20 - 4)
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: -10)
            } completion: { finished in
                UIView.animate(withDuration: 0.5, delay: 0) {
                    self.containerView.transform = .identity
                }
            }
            
        }
    }
}

extension EmojiFloatingView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: self.containerView) == false else {
            return false
        }
        return true
    }
}

extension EmojiFloatingView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath,
                                                      cellType: EmojiFloatingCollectionViewCell.self)
        cell.emojiImage.image = Reaction(rawValue: indexPath.row)?.defaultImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        delegate.requestGenerateFriendCardEmotion(reactionIndex: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: EmojiFloatingCollectionViewCell.cellWidth,
                      height: EmojiFloatingCollectionViewCell.cellWidth)
    }
}
