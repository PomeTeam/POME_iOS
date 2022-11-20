//
//  ReactionTypeCollectionViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/11/19.
//

import UIKit

class ReactionTypeCollectionViewCell: BaseCollectionViewCell {
    
    static let cellIdenifier = "ReactionTypeCollectionViewCell"
    
    /*
     left, right padding = 10 -> 10 * 2 = 20
     left, right inset = 16.5 -> 16.5 * 2 = 33
     spacing = 14 -> 14 * 6 = 84
     */
    
    static let cellWidth: CGFloat = (Const.Device.WIDTH - (20 + 33 + 84)) / 7
    
    let reactionImage = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override
    
    override func hierarchy(){
        
        super.hierarchy()
        
        self.baseView.addSubview(reactionImage)
    }
    
    override func layout(){
        
        super.layout()
        
        reactionImage.snp.makeConstraints{
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func setSelectState(at row: Int){
        print("접근?", row)
        self.reactionImage.image = row == 0 ? Image.categoryActive : Reaction(rawValue: row - 1)?.selectImage
    }
    
    func setUnselectState(at row: Int){
        self.reactionImage.image = row == 0 ? Image.categoryInactive : Reaction(rawValue: row - 1)?.unselectImage
    }
}
