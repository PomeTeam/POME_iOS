//
//  EmotionFilterSheetTestViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/04/05.
//

import Foundation

class EmotionFilterSheetViewController: BaseSheetViewController {
    
    private let emotionTime: EmotionTime
    private let reviewViewModel: ReviewViewModel
    
    private init(emotionTime: EmotionTime, viewModel: ReviewViewModel){
        self.emotionTime = emotionTime
        self.reviewViewModel = viewModel
        super.init(type: .emotionFilter)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let mainView = EmotionFilterSheetView()
    
    static func generateFirstEmotionFilter(viewModel: ReviewViewModel) -> EmotionFilterSheetViewController{
        EmotionFilterSheetViewController(emotionTime: .first, viewModel: viewModel)
    }
    
    static func generateSecondEmotionFilter(viewModel: ReviewViewModel) -> EmotionFilterSheetViewController{
        EmotionFilterSheetViewController(emotionTime: .second, viewModel: viewModel)
    }
    
    override func style() {
        super.style()
        mainView.titleLabel.text = emotionTime.title
    }
    
    override func layout() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func initialize() {
        super.initialize()
        setCollectionViewDelegate()
    }
    
    private func setCollectionViewDelegate(){
        mainView.filterCollectionView.delegate = self
        mainView.filterCollectionView.dataSource = self
    }
    
    @objc private func cancelButtonDidClicked(){
        dismiss(animated: true, completion: nil)
    }
}

extension EmotionFilterSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let emotion = EmotionTag(rawValue: indexPath.row) else { fatalError("Emotion tag index error")}
        return collectionView.dequeueReusableCell(for: indexPath, cellType: EmotionFilterSheetCollectionViewCell.self).then{
            $0.emotionImage = getEmotionImageAboutTime(emotion: emotion)
            $0.emotionTitle = emotion.message
        }
    }
    
    private func getEmotionImageAboutTime(emotion: EmotionTag) -> UIImage{
        switch emotionTime{
        case .first:        return emotion.firstEmotionImage
        case .second:       return emotion.secondEmotionImage
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectFilteringEmotion(id: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    
    private func selectFilteringEmotion(id: Int){
        switch emotionTime{
        case .first:    reviewViewModel.filterFirstEmotion(id: id)
        case .second:   reviewViewModel.filterSecondEmotion(id: id)
        }
    }
}
