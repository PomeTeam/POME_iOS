//
//  EndDateCalendarSheetViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/02/06.
//

import Foundation

class EndDateCalendarSheetViewController: CalendarSheetViewController{
    
    private let startDate: String
    private var possibleDateRange: (CalendarSelectDate, CalendarSelectDate)!
    private var possibleEndDate: CalendarSelectDate!
    
    init(with startDate: String){
        self.startDate = startDate
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func initializeCalendarDate() {
        
        let start = PomeDateFormatter.getDateType(from: startDate)
        let end = calendar.date(byAdding: .day, value: 31, to: start) ?? Date()
        
        let components = calendar.dateComponents([.year, .month], from: start)
        calendarDate = calendar.date(from: components) ?? Date()
        
        let sliceStartDate = startDate.split(separator: ".").map({ Int($0)! })
        let rangeStart = CalendarSelectDate(year: sliceStartDate[0],
                                                 month: sliceStartDate[1],
                                                 date: sliceStartDate[2])
        
        let rangeEnd = CalendarSelectDate(year: calendar.component(.year, from: end),
                                                 month: calendar.component(.month, from: end),
                                                 date: calendar.component(.day, from: end))
        
        possibleDateRange = (rangeStart, rangeEnd)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CalendarSheetCollectionViewCell.self)
        
        let index = indexPath.row
        if(index < 7){
            cell.setDayOfTheWeekText(index: index)
            return cell
        }else if(index < calendarInfo.collectionViewStartDateIndex){
            return cell
        }
        
        let dateValue = index - calendarInfo.collectionViewStartDateIndex + 1
        cell.infoLabel.text = "\(dateValue)"
        
        let year = calendar.component(.year, from: calendarDate)
        let month = calendar.component(.month, from: calendarDate)
        
        cell.changeViewAttributesByState(.disabled)
        if(year == possibleDateRange.0.year && month == possibleDateRange.0.month){
            if(dateValue > possibleDateRange.0.date){
                cell.changeViewAttributesByState(.normal)
            }
        }else if(year == possibleDateRange.1.year && month == possibleDateRange.1.month){
            if(dateValue <= possibleDateRange.1.date){
                cell.changeViewAttributesByState(.normal)
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarSheetCollectionViewCell else { return false }
        
        if(cell.isDisabled || indexPath.row < calendarInfo.collectionViewStartDateIndex){
            return false
        }
        return true
    }
}
