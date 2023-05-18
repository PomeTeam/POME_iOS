//
//  EndDateCalendarSheetViewController.swift
//  POME
//
//  Created by 박소윤 on 2023/02/06.
//

import Foundation

class EndDateCalendarSheetViewController: CalendarSheetViewController{
    
    private var startDate: String!
    private var endDate: Date!
    private var possibleDateRange: (CalendarSelectDate, CalendarSelectDate)!
    private var possibleEndDate: CalendarSelectDate!
    
    func setStartDate(_ startDate: String){
        self.startDate = startDate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initializeCalendarDate()
        mainView.calendarCollectionView.reloadData()
        
    }
    
    override func initializeCalendarDate() {
        
        let start = PomeDateFormatter.getDateType(from: startDate)
        endDate = calendar.date(byAdding: .day, value: 31, to: start) ?? Date()
        
        let components = calendar.dateComponents([.year, .month], from: start)
        calendarDate = calendar.date(from: components) ?? Date()
        
        setCalendarEnabledRange()
    }
    
    private func setCalendarEnabledRange(){
        let sliceStartDate = startDate.split(separator: ".").map({ Int($0)! })
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
        
        rangeValidation(year: year, month: month, date: dateValue){
            cell.changeViewAttributesByState(.normal)
        }
        return cell
    }
    
    func rangeValidation(year: Int, month: Int, date: Int, closure: () -> Void){
        let startString = PomeDateFormatter.getDateString(possibleDateRange.0)
        let endString = PomeDateFormatter.getDateString(possibleDateRange.1)
        let candidate = PomeDateFormatter.getDateString(CalendarSelectDate(year: year, month: month, date: date))

        if(candidate <= endString && candidate > startString){
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
