//
//  GPSFixedData.swift
//  
//
//  Created by Rick Hohler on 8/28/22.
//

import Foundation

public struct GPSFixedData {
    let utcTime: String
    let timestamp: Date?
    let coordinate2D: Coordinate2D?
    let positionFixIndicator: PositionFixIndicator
    var satellitesUsed = 0
    let horizontalDilutionOfPrecision: DilutionOfPrecision
    var altitude: Measurement<UnitLength>
    var geoidSeparation: Measurement<UnitLength>
    var ageOfDifferentialCorrections: String
    var differentialReferenceStationID: String
}

extension GPSFixedData {
    init(rawData: RawData) throws {
        self.utcTime = rawData.utcTime
        
        // construct timestamp
        let time = UTCTimetamp.UTCTime.HHmmss_SSS(rawData.utcTime)
        let date = UTCTimetamp.UTCDate.day_month_year(rawData.day, rawData.month, rawData.year)
        self.timestamp = try UTCTimetamp(time: time, date: date).asDate()
        
        self.coordinate2D = try Coordinate2D(rawData: rawData)
        
        self.positionFixIndicator =
            PositionFixIndicator(rawValue: Int(rawData.positionFixIndicator) ?? PositionFixIndicator.defaultValue.rawValue)
                ?? PositionFixIndicator.defaultValue
        
        self.satellitesUsed = Int(rawData.satellitesUsed) ?? 0
        self.horizontalDilutionOfPrecision =
            try DilutionOfPrecision(rawValue: rawData.hdop, measurementType: DilutionOfPrecision.MeasurementType.horizontal)
        
        self.altitude = Measurement(value: Double(rawData.altitude) ?? 0.0, unit: UnitLength.meters)
        self.geoidSeparation =
            Measurement(value: Double(rawData.geoidSeparation) ?? 0.0, unit: UnitLength.meters)
        
        self.ageOfDifferentialCorrections = rawData.ageOfDifferentialCorrections
        self.differentialReferenceStationID = rawData.differentialReferenceStationID
    }
}


public enum PositionFixIndicator: Int, Decodable {
    case invalid = 0            // 0 - Fix not available or invalid
    case gpsSpsMode = 1         // 1 - GPS SPS Mode, fix valid
    case differentialMode = 2   // 2 - Differential GPS, SPS Mode, fix valid
    case notSupported3 = 3      // 3 - Not supported
    case notSupported4 = 4      // 4 - Not supported
    case notSupported5 = 5      // 5 - Not supported
    case deadReckoningMode = 6  // 6 - Dead Reckoning Mode, fix valid
    case unknown = 99
    
    static let defaultValue = PositionFixIndicator.unknown
}
