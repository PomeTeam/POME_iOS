//
//  CalendarSheetView.swift
//  POME
//
//  Created by 박지윤 on 2022/12/20.
//

import UIKit

class CalendarSheetView: BaseView {
    
    //MARK: - Properties
    
    let yearMonthStackView = UIStackView().then{
        $0.spacing = 10
    }
    let yearMonthLabel = UILabel().then{
        $0.textAlignment = .center
        $0.setTypoStyleWithSingleLine(typoStyle: .title3)
        $0.textColor = Color.title
    }
    let lastMonthButton = UIButton().then{
        $0.setImage(Image.calendarArrowLeft.withTintColor(Color.body), for: .normal)
    }
    let nextMonthButton = UIButton().then{
        $0.setImage(Image.calendarArrowRight.withTintColor(Color.body), for: .normal)
    }
    
    let calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: .init()).then{
        
        let flowLayout = UICollectionViewFlowLayout().then{
            $0.itemSize = CGSize(width: CalendarSheetCollectionViewCell.cellSize, height: CalendarSheetCollectionViewCell.cellSize)
            $0.minimumLineSpacing = 4
            $0.minimumInteritemSpacing = 5
        }
        
        $0.collectionViewLayout = flowLayout
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.register(cellType: CalendarSheetCollectionViewCell.self)
    }
    
    lazy var completeButton = DefaultButton(titleStr: "선택했어요").then{
        $0.isActivate = false
    }

    //MARK: - Override
    
    override func hierarchy(){
        
        self.addSubview(yearMonthStackView)
        self.addSubview(calendarCollectionView)
        self.addSubview(completeButton)
        
        yearMonthStackView.addArrangedSubview(lastMonthButton)
        yearMonthStackView.addArrangedSubview(yearMonthLabel)
        yearMonthStackView.addArrangedSubview(nextMonthButton)
    }
    
    override func layout(){
        
        yearMonthStackView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(24)
        }
        
        lastMonthButton.snp.makeConstraints{
            $0.leading.top.bottom.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        yearMonthLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
        }
        
        nextMonthButton.snp.makeConstraints{
            $0.trailing.top.bottom.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        calendarCollectionView.snp.makeConstraints{
            $0.top.equalTo(yearMonthStackView.snp.bottom).offset(16)
            $0.leading.trailing.equalTo(yearMonthStackView)
            $0.bottom.greaterThanOrEqualTo(completeButton.snp.top).offset(-20)
        }
        
        completeButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().inset(35)
        }
    }
}
