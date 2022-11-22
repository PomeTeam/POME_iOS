//
//  EmotionFilterSheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/11/21.
//

import UIKit

class EmotionFilterSheetViewController: BaseSheetViewController {
    
    var filterTime: EmotionTime!
    
    let mainView = EmotionFilterSheetView()

    //MARK: - LifeCycle
    
    private init(time: EmotionTime){
        self.filterTime = time
        super.init(nibName: nil, bundle: nil)
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
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func style() {
        
        super.style()
        
        self.setBottomSheetStyle(type: .emotionFilter)
        
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
    
    
    
    
}
