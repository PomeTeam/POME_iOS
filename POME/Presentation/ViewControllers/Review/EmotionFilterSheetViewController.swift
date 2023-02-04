//
//  EmotionFilterSheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class EmotionFilterSheetViewController: BaseSheetViewController {
    
    var filterTime: EmotionTime!
    var completion: ((Int) -> ())!
    
    let mainView = EmotionFilterSheetView().then{
        $0.cancelButton.addTarget(self, action: #selector(cancelButtonDidClicked), for: .touchUpInside)
    }

    //MARK: - LifeCycle
    
    private init(time: EmotionTime){
        self.filterTime = time
        super.init(type: .emotionFilter)
    }
    
    static func generateFirstEmotionFilterSheet() -> EmotionFilterSheetViewController{
        return EmotionFilterSheetViewController(time: .first)
    }
    
    static func generateSecondEmotionFilterSheet() -> EmotionFilterSheetViewController{
        return EmotionFilterSheetViewController(time: .second)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Method
    
    @objc func cancelButtonDidClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Override
    
    override func style() {
        
        super.style()
        
        self.mainView.titleLabel.text = filterTime.title
    }
    
    override func initialize() {
        super.initialize()
        
        mainView.filterCollectionView.delegate = self
        mainView.filterCollectionView.dataSource = self
    }
    
    override func layout() {
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

}

extension EmotionFilterSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmotionFilterSheetCollectionViewCell.cellIdentifier, for: indexPath) as? EmotionFilterSheetCollectionViewCell else { return UICollectionViewCell() }
        
        if(filterTime == .first){
            cell.emotionImage.image = EmotionTag(rawValue: indexPath.row)?.firstEmotionImage
        }else{
            cell.emotionImage.image = EmotionTag(rawValue: indexPath.row)?.secondEmotionImage
        }
        
        cell.emotionLabel.text = EmotionTag(rawValue: indexPath.row)?.message
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        completion(indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
