//
//  GGAParserTests.swift
//  
//
//  Created by Rick Hohler on 10/25/22.
//

import Foundation
import XCTest

@testable import NMEAKit

final class GGAParserTests: XCTestCase {
    
    let expectedRawDataTesterDataCount = 18

    class TestListener: StatementListener {
        var value: Data? = {
            """
            {"localZoneHour":2,"localZoneMinutes":5,"timestamp":{"date":{"day_month_year":{"_0":"14","_2":"2003","_1":"10"}},"time":{"HHmmss":{"_0":"181813"}}}}
            """.data(using: .utf8)
        }()
    }

    func testSimple1() throws {
        var statement = NMEAStatement("$GPGGA,002153.000,3342.6618,N,11751.3858,W,1,10,1.2,27.0,M,-34.2,M,,0000*5E")
        XCTAssertNil(statement.lastError)
    
        statement.timingDataListener = TestListener()
        let gga = GGAParser()
        let message = try gga.buildMessage(statement)
        switch message {
        case .gga(let rawData, let ggaTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPGGA")
            tester.assertValue(key: "utcTime", expectedValue: "002153.000")
            tester.assertValue(key: "latitude", expectedValue: "3342.6618")
            tester.assertValue(key: "latitudeDirection", expectedValue: "N")
            tester.assertValue(key: "longitude", expectedValue: "11751.3858")
            tester.assertValue(key: "longitudeDirection", expectedValue: "W")
            tester.assertValue(key: "positionFixIndicator", expectedValue: "1")
            tester.assertValue(key: "satellitesUsed", expectedValue: "10")
            tester.assertValue(key: "hdop", expectedValue: "1.2")
            tester.assertValue(key: "altitude", expectedValue: "27.0")
            tester.assertValue(key: "altitudeUnits", expectedValue: "M")
            tester.assertValue(key: "geoidSeparation", expectedValue: "-34.2")
            tester.assertValue(key: "geoidSeparationUnits", expectedValue: "M")
            tester.assertValue(key: "ageOfDifferentialCorrections", expectedValue: "")
            tester.assertValue(key: "differentialReferenceStationID", expectedValue: "0000")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)
            
            // assert gps fixed data
            let gpsFixedDataResult = ggaTypedData.gpsFixedData
            switch gpsFixedDataResult {
            case .success(let gpsFixedData):
                XCTAssertEqual(gpsFixedData.utcTime, "002153.000")
                XCTAssertEqual(gpsFixedData.timestamp?.timeIntervalSince1970, 1042503713.0)
                XCTAssertEqual(gpsFixedData.coordinate2D?.latitude.value, 33.71103)
                XCTAssertEqual(gpsFixedData.coordinate2D?.longitude.value, -334.04436)
                XCTAssertEqual(gpsFixedData.positionFixIndicator, PositionFixIndicator.gpsSpsMode)
                XCTAssertEqual(gpsFixedData.satellitesUsed, 10)
                XCTAssertEqual(gpsFixedData.horizontalDilutionOfPrecision.rawValue, 1.2)
                XCTAssertEqual(gpsFixedData.horizontalDilutionOfPrecision.interpretation, DilutionOfPrecision.Interpretation.excellent)
                
                XCTAssertEqual(gpsFixedData.altitude.value, 27.0)
                XCTAssertEqual(gpsFixedData.geoidSeparation.value, -34.2)
                XCTAssertEqual(gpsFixedData.ageOfDifferentialCorrections, "")
                XCTAssertEqual(gpsFixedData.differentialReferenceStationID, "0000")
            case .failure(_):
                XCTFail("Not expected result failure")
            }
        default:
            XCTFail("unexpected message type")
        }
    }

    func testSimple2() throws {
        var statement = NMEAStatement("$GPGGA,134453.000,3751.65,S,14507.36,E,2,12,3.1,311.0,M,-15.5,M,,0001*68")
        XCTAssertNil(statement.lastError)
    
        statement.timingDataListener = TestListener()
        let gga = GGAParser()
        let message = try gga.buildMessage(statement)
        switch message {
        case .gga(let rawData, let ggaTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPGGA")
            tester.assertValue(key: "utcTime", expectedValue: "134453.000")
            tester.assertValue(key: "latitude", expectedValue: "3751.65")
            tester.assertValue(key: "latitudeDirection", expectedValue: "S")
            tester.assertValue(key: "longitude", expectedValue: "14507.36")
            tester.assertValue(key: "longitudeDirection", expectedValue: "E")
            tester.assertValue(key: "positionFixIndicator", expectedValue: "2")
            tester.assertValue(key: "satellitesUsed", expectedValue: "12")
            tester.assertValue(key: "hdop", expectedValue: "3.1")
            tester.assertValue(key: "altitude", expectedValue: "311.0")
            tester.assertValue(key: "altitudeUnits", expectedValue: "M")
            tester.assertValue(key: "geoidSeparation", expectedValue: "-15.5")
            tester.assertValue(key: "geoidSeparationUnits", expectedValue: "M")
            tester.assertValue(key: "ageOfDifferentialCorrections", expectedValue: "")
            tester.assertValue(key: "differentialReferenceStationID", expectedValue: "0001")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            // assert gps fixed data
            let gpsFixedDataResult = ggaTypedData.gpsFixedData
            switch gpsFixedDataResult {
            case .success(let gpsFixedData):
                XCTAssertEqual(gpsFixedData.utcTime, "134453.000")
                XCTAssertEqual(gpsFixedData.coordinate2D?.latitude.value, -37.86083)
                XCTAssertEqual(gpsFixedData.coordinate2D?.longitude.value, 375.0275)
                XCTAssertEqual(gpsFixedData.positionFixIndicator, PositionFixIndicator.differentialMode)
                XCTAssertEqual(gpsFixedData.satellitesUsed, 12)
                XCTAssertEqual(gpsFixedData.horizontalDilutionOfPrecision.rawValue, 3.1)
                XCTAssertEqual(gpsFixedData.horizontalDilutionOfPrecision.interpretation, DilutionOfPrecision.Interpretation.good)
                
                XCTAssertEqual(gpsFixedData.altitude.value, 311.0)
                XCTAssertEqual(gpsFixedData.geoidSeparation.value, -15.5)
                XCTAssertEqual(gpsFixedData.ageOfDifferentialCorrections, "")
                XCTAssertEqual(gpsFixedData.differentialReferenceStationID, "0001")
            case .failure(_):
                XCTFail("Not expected result failure")
            }
        default:
            XCTFail("unexpected message type")
        }
    }

    func testError1() throws {
        let statement = NMEAStatement("$GPGGA,134453.000,3751.65,X,14507.36,E,2,12,3.1,311.0,M,-15.5,M,,0001*63")
        XCTAssertNil(statement.lastError)
    
        let gga = GGAParser()
        let message = try gga.buildMessage(statement)
        switch message {
        case .gga(let rawData, let ggaTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPGGA")
            tester.assertValue(key: "utcTime", expectedValue: "134453.000")
            tester.assertValue(key: "latitude", expectedValue: "3751.65")
            tester.assertValue(key: "latitudeDirection", expectedValue: "X")
            tester.assertValue(key: "longitude", expectedValue: "14507.36")
            tester.assertValue(key: "longitudeDirection", expectedValue: "E")
            tester.assertValue(key: "positionFixIndicator", expectedValue: "2")
            tester.assertValue(key: "satellitesUsed", expectedValue: "12")
            tester.assertValue(key: "hdop", expectedValue: "3.1")
            tester.assertValue(key: "altitude", expectedValue: "311.0")
            tester.assertValue(key: "altitudeUnits", expectedValue: "M")
            tester.assertValue(key: "geoidSeparation", expectedValue: "-15.5")
            tester.assertValue(key: "geoidSeparationUnits", expectedValue: "M")
            tester.assertValue(key: "ageOfDifferentialCorrections", expectedValue: "")
            tester.assertValue(key: "differentialReferenceStationID", expectedValue: "0001")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            let gpsFixedDataResult = ggaTypedData.gpsFixedData
            switch gpsFixedDataResult {
            case .success(_):
                XCTFail("Expected result failure")
            case .failure(let error):
                XCTAssertEqual(error as! Coordinate2D.InitError, Coordinate2D.InitError.invalidLatitudeDirection(rawValue: "X", expected: "N/S"))
            }
    
        default:
            XCTFail("unexpected message type")
        }
    }
}
