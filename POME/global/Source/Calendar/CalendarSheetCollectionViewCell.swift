//
//  CalendarSheetCollectionViewCell.swift
//  POME
//
//  Created by 박지윤 on 2022/12/20.
//

import UIKit

class CalendarSheetCollectionViewCell: BaseCollectionViewCell {
    
    enum CalendarCellState{
        case normal
        case selected
        case disabled
    }
    
    static let cellIdentifier = "CalendarSheetCollectionViewCell"
    
    static let cellSize: CGFloat = (Const.Device.WIDTH - 40 - 9.17*6) / 7
    
    let infoLabel = UILabel().then{
        $0.textAlignment = .center
        $0.setTypoStyleWithSingleLine(typoStyle: .title4)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        
        infoLabel.text = nil
        
        setDefaultState()
    }
    
    override func style(){
        
        setDefaultState()
        
        baseView.layer.cornerRadius = CalendarSheetCollectionViewCell.cellSize / 2
    }
    
    override func hierarchy(){
        
        super.hierarchy()
        
        self.baseView.addSubview(infoLabel)
    }
    
    override func layout(){
        
        super.layout()
        
        infoLabel.snp.makeConstraints{
            $0.top.leading.equalToSuperview().offset(10)
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    //MARK: - Helper
    
    func setDayOfTheWeekText(index: Int){
        
        self.infoLabel.text = {
            switch index{
            case 0:     return "일"
            case 1:     return "월"
            case 2:     return "화"
            case 3:     return "수"
            case 4:     return "목"
            case 5:     return "금"
            case 6:     return "토"
            default:    return nil
            }
        }()
    }
    
    func setDefaultState(){
        setCellAttributeByState(state: .normal)
    }
    
    func setSelectedState(){
        setCellAttributeByState(state: .selected)
    }
    
    func setDisabledState(){
        setCellAttributeByState(state: .disabled)
    }
    
    private func setCellAttributeByState(state: CalendarCellState){
        baseView.backgroundColor = state.backgroundColor
        infoLabel.textColor = state.textColor
    }
}

extension CalendarSheetCollectionViewCell.CalendarCellState{
    
    struct CellStateAttribute{
        let backgroundColor: UIColor
        let textColor: UIColor
    }
    
    private var attributes: CellStateAttribute{
        switch self{
        case .normal:       return CellStateAttribute(backgroundColor: .white,
                                                 textColor: Color.title)
        case .selected:     return CellStateAttribute(backgroundColor: Color.pink100,
                                                 textColor: .white)
        case .disabled:     return CellStateAttribute(backgroundColor: .white,
                                                 textColor: Color.grey5)
        }
    }
    
    var backgroundColor: UIColor{
        self.attributes.backgroundColor
    }
    
    var textColor: UIColor{
        self.attributes.textColor
    }
}
