//
//  EndDateCalendarSheetViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/02/06.
//

import Foundation

class EndDateCalendarSheetViewController: CalendarSheetViewController{
    
    private let startDateString: String
    private var endDate: Date!
    private var possibleDateRange: (CalendarSelectDate, CalendarSelectDate)!
    private var possibleEndDate: CalendarSelectDate!
    
    init(with startDate: String){
        self.startDateString = startDate
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initializeCalendarDate() {
        
        let start = PomeDateFormatter.getDateType(from: startDateString)
        endDate = calendar.date(byAdding: .day, value: 31, to: start) ?? Date()
        
        let components = calendar.dateComponents([.year, .month], from: start)
        calendarDate = calendar.date(from: components) ?? Date()
        
        setCalendarEnabledRange()
    }
    
    private func setCalendarEnabledRange(){
        let sliceStartDate = startDateString.split(separator: ".").map({ Int($0)! })
        let rangeStart = CalendarSelectDate(year: sliceStartDate[0],
                                            month: sliceStartDate[1],
                                            date: sliceStartDate[2])
        
        let rangeEnd = CalendarSelectDate(year: calendar.component(.year, from: endDate),
                                          month: calendar.component(.month, from: endDate),
                                          date: calendar.component(.day, from: endDate))
        
        possibleDateRange = (rangeStart, rangeEnd)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CalendarSheetCollectionViewCell.self)
        
        let index = indexPath.row
        if(index < calendarInfo.collectionViewStartDateIndex){
            if(index < 7){
                cell.setDayOfTheWeekText(index: index)
            }
            return cell
        }
        
        let dateValue = index - calendarInfo.collectionViewStartDateIndex + 1
        cell.infoLabel.text = "\(dateValue)"
        
        let year = calendar.component(.year, from: calendarDate)
        let month = calendar.component(.month, from: calendarDate)
        
        cell.changeViewAttributesByState(.disabled)
        
        startDateValidation(year: year, month: month, dateValue: dateValue){
            cell.changeViewAttributesByState(.normal)
        }
        endDateValidation(year: year, month: month, dateValue: dateValue){
            cell.changeViewAttributesByState(.normal)
        }
        return cell
    }
    
    func startDateValidation(year: Int, month: Int, dateValue: Int , closure: () -> Void){
        let standard = possibleDateRange.0
        if(year == standard.year && month == standard.month && dateValue > standard.date){
            closure()
        }
    }
    
    func endDateValidation(year: Int, month: Int, dateValue: Int , closure: () -> Void){
        let standard = possibleDateRange.1
        if(year == standard.year && month == standard.month && dateValue <= standard.date){
            closure()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarSheetCollectionViewCell else { return false }
        
        if(cell.isDisabled || indexPath.row < calendarInfo.collectionViewStartDateIndex){
            return false
        }
        return true
    }
}
