//
//  TextConverter.swift
//  POME
//
//  Created by 박소윤 on 2023/04/02.
//

import Foundation

class TextConverter{
    
    static func convertToDecimalFormat(number: String) -> String{
        
        let formatter = NumberFormatter().then{
            $0.numberStyle = .decimal // 1,000,000
            $0.locale = Locale.current
            $0.maximumFractionDigits = 0 // 허용하는 소숫점 자리수
        }
        
        let removeComma = number.replacingOccurrences(of: formatter.groupingSeparator, with: "")
        guard let formattedNumber = formatter.number(from: removeComma),
                let formattedString = formatter.string(from: formattedNumber) else{
            return number.isEmpty ? "0" : ""
        }
        return formattedString
    }
    
    static func getValidateRangeString(_ value: String, limit: Int) -> String{
        let endIndex = min(limit, value.count)
        let endStringIndex = value.index(value.startIndex, offsetBy: endIndex)
        return String(value[..<endStringIndex])
    }
}
