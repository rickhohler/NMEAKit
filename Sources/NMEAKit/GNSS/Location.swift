//
//  Location.swift
//  
//
//  Created by Rick Hohler on 8/29/22.
//

import Foundation

public enum LocationMode: String, Decodable {
    case autonomous = "A"   // A - Autonomous
    case dgps = "D"         // D - DGPS
    case dr = "E"           // E - DR (Only present in NMEA v3.00)
    case unknown
    
    static let defaultValue = LocationMode.unknown
}

public struct GeographicPosition: Decodable {
    public let coordinate2D: Coordinate2D
    public let utcTime: String
    public let status: GNNSStatus
    public let mode: LocationMode
    
    public init(rawData: RawData) throws {
        self.coordinate2D  = try Coordinate2D(rawData: rawData)
        self.utcTime = (rawData.utcTime.isEmpty) ? UTCTimetamp.UTCTime.defaultValue : rawData.utcTime
        self.status = GNNSStatus(rawValue: rawData.status) ?? GNNSStatus.defaultValue
        self.mode = LocationMode(rawValue: rawData.mode) ?? LocationMode.defaultValue
    }
    
    
    enum CodingKeys: String, CodingKey {
        case coordinate2D
        case utcTime
        case status
        case mode
    }
}

public struct Course: Decodable {
    public var value: Measurement<UnitAngle>
    public var reference: Reference
    
    public enum Reference: String, Decodable {
        case trueNorth = "T"
        case magnetic = "M"
        case unnknown

        static let defaultValue = Reference.unnknown
    }
    
    public init(rawValue: String, rawReference: String) throws {
        self.reference =  Reference(rawValue: rawReference) ?? Reference.defaultValue
        self.value = Measurement(value: Double(rawValue) ?? Course.defaultValue, unit: UnitAngle.degrees)
    }
    
    static let defaultValue = 0.0
}

public struct Speed: Decodable {
    public var value: Measurement<UnitSpeed>
    
    init(rawValue: String) throws {
        let reference = UnitSpeed.kilometersPerHour
        let speed = Double(rawValue) ?? Speed.defaultValue
        self.value = Measurement(value: speed, unit: reference)
    }
    
    static let defaultValue = 0.0
}

public struct CourseAndSpeedData: Decodable {
    public let course1: Course
    public let course2: Course
    public let speed1: Speed
    public let speed2: Speed
    public let mode: LocationMode

    init(rawData: RawData) throws {
        self.course1 = try Course(rawValue: rawData.course1, rawReference: rawData.course1Ref)
        self.course2 = try Course(rawValue: rawData.course2, rawReference: rawData.course2Ref)
        self.speed1 = try Speed(rawValue: rawData.speed1)
        self.speed2 = try Speed(rawValue: rawData.speed2)
        self.mode = LocationMode(rawValue: rawData.mode) ?? LocationMode.defaultValue
    }
}
