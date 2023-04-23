//
//  GNSSData.swift
//  
//
//  Created by Rick Hohler on 8/28/22.
//

import Foundation

public struct GNSSData {
    let timestamp: Date?
    let status: GNNSStatus
    let coordinate2D: Coordinate2D?
    let speedOverGround: Measurement<UnitSpeed>     // unit in knots
    let courseOverGround: Measurement<UnitAngle>    // unit in degrees
    let magneticVariation: Longitude.Direction
    let eastWestIndicator: Longitude.Direction
    let mode: LocationMode
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case status
        case coordinate2D
    }
}

extension GNSSData {
    public init(rawData: RawData) throws {
        let time = UTCTimetamp.UTCTime.HHmmss_SSS(rawData.utcTime)
        let date = UTCTimetamp.UTCDate.ddmmyy(rawData.date)
        let dt = UTCTimetamp(time: time, date: date)
        self.timestamp = try dt.asDate()
        self.status = GNNSStatus(rawValue: rawData.status) ?? GNNSStatus.unknown
        self.coordinate2D  = try Coordinate2D(rawData: rawData)

        
        let speed = Double(rawData.speed) ?? Speed.defaultValue
        self.speedOverGround = Measurement(value: speed, unit: UnitSpeed.knots)
        
        let course = Double(rawData.course) ?? Course.defaultValue
        self.courseOverGround = Measurement(value: course, unit: UnitAngle.degrees)

        self.magneticVariation = Longitude.Direction(rawValue: rawData.magneticVariation) ?? Longitude.Direction.unknown
        self.eastWestIndicator = Longitude.Direction(rawValue: rawData.eastWestIndicator) ?? Longitude.Direction.unknown

        self.mode = LocationMode(rawValue: rawData.mode) ?? LocationMode.defaultValue
    }
}
