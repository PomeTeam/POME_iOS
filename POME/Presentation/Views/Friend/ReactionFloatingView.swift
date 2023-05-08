//
//  EmojiFloatingView.swift
//  POME
//
//  Created by 박지윤 on 2022/11/09.
//

import UIKit

final class ReactionFloatingView: BaseView {
    
    private var completion: ((Int) -> Void)!
    
    private let containerView = UIView().then{
        $0.backgroundColor = .white
        $0.setShadowStyle(type: .card)
        $0.clipsToBounds = false
        $0.layer.cornerRadius = 54/2
    }
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        
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
        addGestureRecognizer(dismissGesture)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @objc private func dismiss(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform(translationX: 0, y: 10)
                self.layer.opacity = 0.0
            }, completion:{ finished in
                self.removeFromSuperview()
            })
        }
        completion = nil
    }
    
    override func hierarchy() {
        addSubview(containerView)
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
    
    func show(in viewController: UIViewController, standard cell: BaseTableViewCell, closure: @escaping (Int) -> Void){
        addViewToParent(vc: viewController)
        setFloatingViewLayout(standard: cell.baseView)
        playAnimation()
        completion = closure
    }
    
    private func addViewToParent(vc: UIViewController){
        vc.view.addSubview(self)
    }
    
    private func setFloatingViewLayout(standard: UIView){
        self.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        containerView.snp.makeConstraints{
            $0.top.equalTo(standard.snp.bottom).offset(-4)
        }
    }
    
    private func playAnimation(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.layer.opacity = 1.0
                self.containerView.transform = CGAffineTransform(translationX: 0, y: -10)
            } completion: { finished in
                UIView.animate(withDuration: 0.5, delay: 0) {
                    self.containerView.transform = .identity
                }
            }
        }
    }
}

extension ReactionFloatingView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard touch.view?.isDescendant(of: containerView) == false else {
            return false
        }
        return true
    }
}

extension ReactionFloatingView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
        completion(indexPath.row)
        dismiss()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: EmojiFloatingCollectionViewCell.cellWidth,
                      height: EmojiFloatingCollectionViewCell.cellWidth)
    }
}
