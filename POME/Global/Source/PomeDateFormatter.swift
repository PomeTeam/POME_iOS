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
}
