//
//  SiRFTimingData.swift
//  
//
//  Created by Rick Hohler on 8/29/22.
//

import Foundation

public struct SiRFTimingData: Hashable, Equatable, Codable {
    
    let timestamp: UTCTimetamp
    let localZoneHour: Int      // Offset from UTC (set to 00)
    let localZoneMinutes: Int   // Offset from UTC (set to 00)
    
    init(rawData: RawData) throws {
        
        let time = UTCTimetamp.UTCTime.HHmmss(rawData.utcTime)
        let day = rawData.day
        let month = rawData.month
        let year = rawData.year
        let date = UTCTimetamp.UTCDate.day_month_year(day, month, year)

        self.timestamp = UTCTimetamp(time: time, date: date)

        self.localZoneHour = Int(rawData.localZoneHour) ?? 0
        self.localZoneMinutes = Int(rawData.localZoneMinutes) ?? 0
    }

    public static func == (lhs: SiRFTimingData, rhs: SiRFTimingData) -> Bool {
        lhs.timestamp == rhs.timestamp
    }
}
