//
//  DilutionOfPrecision.swift
//  
//
//  Created by Rick Hohler on 10/24/22.
//

import Foundation

public struct DilutionOfPrecision: Decodable {
    public let rawValue: Double
    public let interpretation: Interpretation
    public let measurementType: MeasurementType
    
    init(rawValue: String, measurementType: MeasurementType) throws {
        self.measurementType = measurementType
        guard let rawDoubleValue = Double(rawValue) else {
            throw InitError.invalidDoubleValue(rawValue: rawValue, measurementType: measurementType)
        }
        self.rawValue = rawDoubleValue
        guard let interpretation = Interpretation(rawValue: rawValue) else {
            throw InitError.invalidInterpretation(rawValue: rawValue, measurementType: measurementType)
        }
        self.interpretation = interpretation
    }
    
    public enum Interpretation: Decodable {
        case ideal
        case excellent
        case good
        case moderate
        case fair
        case poor
        
        init?(rawValue: String) {
            guard let rawDoubleValue = Double(rawValue) else {
                return nil
            }
            switch rawDoubleValue {
            case 0..<1:
                /// `<1`  Ideal   Highest possible confidence level to be used for applications demanding the highest possible precision at all times.
                self = .ideal
            case 1..<2:
                /// 1-2  Excellent  At this confidence level, positional measurements are considered accurate enough to meet all but the most sensitive applications.
                self = .excellent
            case 2..<5:
                /// 2-4 Good    Represents a level that marks the minimum appropriate for making accurate decisions. Positional measurements could be used to make reliable in-route navigation suggestions to the user.
                self = .good
            case 5..<10:
                /// 5-10    Moderate    Positional measurements could be used for calculations, but the fix quality could still be improved. A more open view of the sky is recommended.
                self = .moderate
            case 10..<20:
                /// Fair    Represents a low confidence level. Positional measurements should be discarded or used only to indicate a very rough estimate of the current location.
                self = .fair
            default:
                ///  >20    Poor    At this level, measurements are inaccurate by as much as 300 meters with a 6-meter accurate device (50 DOP × 6 meters) and should be discarded.
                self = .poor
            }
        }
    }
    
    public enum MeasurementType: Decodable {
        case horizontal
        case vertical
        case position
        case time
        case geometric
    }

    public enum InitError: Error {
        case invalidDoubleValue(rawValue: String, measurementType: MeasurementType)
        case invalidInterpretation(rawValue: String, measurementType: MeasurementType)
    }
}


#if targetEnvironment(simulator)

extension DilutionOfPrecision {
    public init() {
        self.rawValue = 11.1
        self.interpretation = .excellent
        self.measurementType = .geometric
    }
}

#endif
