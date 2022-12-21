//
//  CalendarSheetViewController.swift
//  POME
//
//  Created by 박지윤 on 2022/12/20.
//

import UIKit

class CalendarSheetViewController: BaseSheetViewController {
    
    var dateHandler: (() -> ())!
    
    let mainView = CalendarSheetView()
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Override

    override func style() {
        
        super.style()
        
        setBottomSheetStyle(type: .calendar)
    }

    override func layout() {
        
        self.view.addSubview(mainView)
        
        mainView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func initialize() {
        
        super.initialize()
        
        mainView.calendarCollectionView.dataSource = self
        mainView.calendarCollectionView.delegate = self
    }
}

extension CalendarSheetViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7 * 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarSheetCollectionViewCell.cellIdentifier, for: indexPath) as? CalendarSheetCollectionViewCell else { return UICollectionViewCell() }
        
        cell.infoLabel.text = "1"
        
        if(indexPath.row < 7){
            cell.setDayOfWeekText(index: indexPath.row)
        }
        
        return cell
    }
    
}
