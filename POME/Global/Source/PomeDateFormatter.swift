//
//  PomeDateFormatter.swift
//  POME
//
//  Created by 박소윤 on 2023/02/01.
//

import Foundation

struct PomeDateFormatter{
    
    static let formatter = DateFormatter().then{
        $0.dateFormat = "yyyy.MM.dd"
    }
    
    static func getTodayDate() -> String{
        return formatter.string(from: Date())
    }
    
    static func getDateString(_ date: Date) -> String{
        return formatter.string(from: date)
    }
    
    static func getDateString(_ date: CalendarSelectDate) -> String{
        "\(date.year)." + convertIntToFormatterString(date.month) + "." + convertIntToFormatterString(date.date)
    }
    
    static func getRecordDateString(_ date: String) -> String{
        //'2023.02.23' > '2월 23일'
        guard let date = PomeDateFormatter.formatter.date(from: date) else {
            return ""
        }
        let formatter = DateFormatter().then{
            $0.dateFormat = "M월 d일"
        }
        return formatter.string(from: date)
    }
    
    static private func convertIntToFormatterString(_ int: Int) -> String{
        int < 10 ? "0\(int)" : String(int)
    }
    
    static func getDateType(from: String) -> Date{
        formatter.date(from: from) ?? Date()
    }
    
    // 남은 일 수 반환 - Int
    static func getRemainDate(_ endDateStr: String) -> Int {
        let endDate = formatter.date(from: endDateStr)
        let diffBetweenDates = endDate!.timeIntervalSince(Date())
        let diff = Int(diffBetweenDates / (60 * 60 * 24))
        
        return diff
    }
    // 종료 날짜가 오늘보다 이전인 지 확인
    static func isDateEnd(_ endDateStr: String) -> Bool {
        let convertDate = formatter.date(from: endDateStr)
        
        let result: ComparisonResult = Date().compare(convertDate ?? .now)
        if result == .orderedDescending {
            return true
        } else {
            return false
        }
    }
}
