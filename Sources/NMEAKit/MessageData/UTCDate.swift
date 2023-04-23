//
//  UTCDate.swift
//  
//
//  Created by Rick Hohler on 10/31/22.
//

import Foundation

public enum UTCTimetampError: Error, Equatable {
    case invalidDate(String)
    case invalidUTCTime(String, String)
    case invalidUTCDate(String, String)
    case invalidUTCDay(String, String)
    case invalidUTCMonth(String, String)
    case invalidUTCYear(String, String)
}

struct UTCTimetamp: Hashable, Equatable, Codable {
    
    let time: UTCTime
    let date: UTCDate

    enum UTCTime: Hashable, Equatable, Codable {
        case HHmmss(String)
        case HHmmss_SSS(String)
        
        func formatWithValue() throws -> (timeFormat: String, value: String) {
            switch self {
            case .HHmmss(let val):
                guard val.count == 6, let _ = Int(val) else {
                    throw UTCTimetampError.invalidUTCTime(val, "\(self)")
                }
                return ("HHmmss", val)
            case .HHmmss_SSS(let val):
                guard val.count == 10, let _ = Double(val) else {
                    throw UTCTimetampError.invalidUTCTime(val, "\(self)")
                }
                return ("HHmmss.SSS", val)
            }
        }
        
        static let defaultValue = "000000"
    }

    enum UTCDate: Hashable, Equatable, Codable {
        case ddmmyy(String)
        case day_month_year(String, String, String)     // ddmmyyyy
        
        func formatWithValue() throws -> (dateFormat: String, value: String) {
            switch self {
            case .ddmmyy(let val):
                guard val.count == 6, let _ = Int(val) else {
                    throw UTCTimetampError.invalidUTCDate(val, "\(self)")
                }
                return ("ddmmyy", val)
    
            case .day_month_year(let day, let month, let year):
                guard 1...31 ~= Int(day) ?? -1 else {
                    throw UTCTimetampError.invalidUTCDay(day, "1...31")
                }
                guard 1...12 ~= Int(month) ?? -1 else {
                    throw UTCTimetampError.invalidUTCDay(day, "1...12")
                }
                guard 1980...2079 ~= Int(year) ?? -1 else {
                    throw UTCTimetampError.invalidUTCDay(day, "1980...2079")
                }
                return ("ddmmyyyy", day + month + year)
            }
        }
        
        static let defaultValue = "010101"
    }

    func asDate() throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        
        let (timeFormat, timeValue) = try self.time.formatWithValue()
        let (dateFormat, dateValue) = try self.date.formatWithValue()

        dateFormatter.dateFormat = dateFormat + timeFormat
        let dt = "\(dateValue)\(timeValue)"

        guard let datetime = dateFormatter.date(from: dt) else {
            throw UTCTimetampError.invalidDate(dt)
        }
        return datetime
    }
}
