//
//  SatellitesData.swift
//  
//
//  Created by Rick Hohler on 2023-04-22.
//

import Foundation

public struct ActiveSatellitesData: Decodable {
    public let mode1: Mode1
    public let mode2: Mode2
    public let satellitesUsed: [String]
    public let positionDilutionOfPrecision: DilutionOfPrecision
    public let horizontalDilutionOfPrecision: DilutionOfPrecision
    public let verticalDilutionOfPrecision: DilutionOfPrecision
    
    public enum Mode1: String, CaseIterable, Decodable {
        case manual = "M"       // M - forced to operate in 2D or 3D mode
        case automatic = "A"    // A - 2D Automatic - allowed to automatically switch 2D/3D
        
        static var expectedValues: String {
            "\(Mode1.allCases)"
        }
    }
    
    public enum Mode2: Int, CaseIterable, Decodable {
        case one = 1    // Fix not available
        case two = 2    // 2D (<4 SVs used)
        case three = 3  // 3D (>3 SVs used)
        
        static var expectedValues: String {
            "\(Mode2.allCases)"
        }
    }

    public enum InitError: Error, Equatable {
        case invalidActiveMode1Value(rawValue: String, expected: String)
        case invalidActiveMode2Value(rawValue: String, expected: String)
    }
}

extension ActiveSatellitesData {
    init(rawData: RawData) throws {
        guard let mode1 = Mode1(rawValue: rawData.mode1) else {
            throw InitError.invalidActiveMode1Value(rawValue: rawData.mode1, expected: Mode1.expectedValues)
        }
        self.mode1 = mode1
        
        guard let rawMode2 = Int(rawData.mode2), let mode2 = Mode2(rawValue: rawMode2) else {
            throw InitError.invalidActiveMode2Value(rawValue: rawData.mode2, expected: Mode2.expectedValues)
        }
        self.mode2 = mode2

        self.satellitesUsed = (1...12).compactMap { ndx in
            // return nil for all empty ("") strings
            if let val = rawData.data["satelliteUsed\(ndx)"] as String? {
                if val != "" { return val }
            }
            return nil
        }
        
        self.positionDilutionOfPrecision = try DilutionOfPrecision(rawValue: rawData.pdop, measurementType: .position)
        self.horizontalDilutionOfPrecision = try DilutionOfPrecision(rawValue: rawData.hdop, measurementType: .horizontal)
        self.verticalDilutionOfPrecision = try DilutionOfPrecision(rawValue: rawData.vdop, measurementType: .vertical)
    }
}

#if targetEnvironment(simulator)

extension ActiveSatellitesData {
    public init() {
        self.mode1 = .automatic
        self.mode2 = .three
        self.satellitesUsed = ["Sat1", "Sat2"]
        self.positionDilutionOfPrecision = DilutionOfPrecision()
        self.horizontalDilutionOfPrecision = DilutionOfPrecision()
        self.verticalDilutionOfPrecision = DilutionOfPrecision()
    }
}

#endif


public struct SatellitesInViewData: Decodable {
    let numberOfStatements: Int
    let messageNumber: Int
    let satellitesInView: Int
}

extension SatellitesInViewData {
    init(rawData: RawData) {
        numberOfStatements = Int(rawData.numberOfStatements) ?? 0
        messageNumber = Int(rawData.messageNumber) ?? 0
        satellitesInView = Int(rawData.satellitesInView) ?? 0
    }
}

public struct SatelliteData: Decodable {
    static let numberOfElements = 4

    let id: String
    let elevation: Measurement<UnitAngle>   // degrees 0 to 90
    let azimuth: Measurement<UnitAngle>     // degrees 0 to 359
    let snr: String
    
    static let elevationMaxDegrees = 90
    static let azimuthMaxDegrees = 359
    
    static let idIndex = 0
    static let elevationIndex = 1
    static let azimuthIndex = 2
    static let snrIndex = 3

    init(rawValues: [String]) throws {
        self.id = rawValues[SatelliteData.idIndex]
        self.elevation = try SatelliteData.buildMeasurementValue(rawValue: rawValues[SatelliteData.elevationIndex], maxValue: SatelliteData.elevationMaxDegrees)
        self.azimuth = try SatelliteData.buildMeasurementValue(rawValue: rawValues[SatelliteData.azimuthIndex], maxValue: SatelliteData.azimuthMaxDegrees)
        self.snr = rawValues[SatelliteData.snrIndex]
    }

    private static func buildMeasurementValue(rawValue: String, maxValue: Int) throws -> Measurement<UnitAngle> {
        let numValue = Int(rawValue) ?? -1
        guard 0...maxValue ~= numValue else {
            throw InitError.invalidMeasuarementValue(rawValue: rawValue, expectedLower: 0, expectedUpper: maxValue)
        }
        return Measurement(value: Double(numValue), unit: UnitAngle.degrees)
    }

    public enum InitError: Error, Equatable {
        case invalidMeasuarementValue(rawValue: String, expectedLower: Int, expectedUpper: Int)
    }
}



#if targetEnvironment(simulator)

extension SatellitesInViewData {
    public init() {
        self = .init(rawData: RawData())
    }
}

#endif
