//
//  Coordinate2D.swift
//  
//
//  Created by Rick Hohler on 2023-04-17.
//

import Foundation

enum NMEARawDataPosition: Int {
    case latitudeStart = 2
    case longitudeStart = 3
}

public struct Latitude: Decodable {
    
    let value: Double
    
    init(direction: Direction, rawValue: String) {
        self.value = NMEACoordinateConverter.toDecimal(rawCoordinate: rawValue,
            start: NMEARawDataPosition.latitudeStart, negative: direction == .south)
    }
    
    enum Direction: String {
        case north = "N"
        case south = "S"
        case unknown
    }
}

public struct Longitude: Decodable {
    
    let value: Double
    
    init(direction: Direction, rawValue: String) {
        self.value = NMEACoordinateConverter.toDecimal(rawCoordinate: rawValue,
            start: NMEARawDataPosition.longitudeStart, negative: direction == .west)
    }
    
    enum Direction: String {
        case east = "E"
        case west = "W"
        case unknown
    }
}

struct NMEACoordinateConverter {
    
    static var defaultValue: Double { 0.0 }
    
    static func toDecimal(rawCoordinate: String, start: NMEARawDataPosition, negative: Bool) -> Double {
        guard let a = Double(rawCoordinate.prefix(start.rawValue)) else {
            return Self.defaultValue
        }
        let strIndex = String.Index(utf16Offset: start.rawValue, in: rawCoordinate)
        let b = Double(rawCoordinate.suffix(from: strIndex))!
        if negative {
            return -1 * calcDegree(a: a, b: b)
        }
        return calcDegree(a: a, b: b)
    }
    
    static func calcDegree(a: Double, b: Double) -> Double {
        return round((a + b / 60) * 100000) / 100000.0
    }
}

public struct Coordinate2D: Decodable {
    public let latitude: Latitude
    public let longitude: Longitude
    
}

extension Coordinate2D {
    init(rawData: RawData) throws {
        guard let latitudeDirection = Latitude.Direction(rawValue: rawData.latitudeDirection) else {
            throw InitError.invalidLatitudeDirection(rawValue: rawData.latitudeDirection, expected: "N/S")
        }
        guard let longitudeDirection = Longitude.Direction(rawValue: rawData.longitudeDirection) else {
            throw InitError.invalidLongitudeDirection(rawValue: rawData.longitudeDirection, expected: "E/W")
        }
        self.latitude = Latitude(direction: latitudeDirection, rawValue: rawData.latitude)
        self.longitude = Longitude(direction: longitudeDirection, rawValue: rawData.latitude)
    }
    
    public enum InitError: Error, Equatable {
        case invalidLatitudeDirection(rawValue: String, expected: String)
        case invalidLongitudeDirection(rawValue: String, expected: String)
    }
}

#if canImport(CoreLocation)
import CoreLocation

extension Coordinate2D {
    
    public var coreDataCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude.value, longitude: longitude.value)
    }
}

#endif
