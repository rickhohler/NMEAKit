//
//  GLLParserTests.swift
//  
//
//  Created by Rick Hohler on 10/26/22.
//

import Foundation
import XCTest

@testable import NMEAKit

final class GLLParserTests: XCTestCase {
    
    let expectedRawDataTesterDataCount = 8

    class TestListener: StatementListener {
        var value: Date? = {
            Date()
        }()
    }

    func testSimple1() throws {
        var statement = NMEAStatement("$GPGLL,3723.2475,N,12158.3416,W,161229.487,A,A*41")
        XCTAssertNil(statement.lastError)
    
        statement.timingDataListener = TestListener()
        let gll = GLLParser()
        let message = try gll.buildMessage(statement)
        switch message {
        case .gll(let rawData, let gllTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPGLL")
            tester.assertValue(key: "latitude", expectedValue: "3723.2475")
            tester.assertValue(key: "latitudeDirection", expectedValue: "N")
            tester.assertValue(key: "longitude", expectedValue: "12158.3416")
            tester.assertValue(key: "longitudeDirection", expectedValue: "W")
            tester.assertValue(key: "utcTime", expectedValue: "161229.487")
            tester.assertValue(key: "status", expectedValue: "A")
            tester.assertValue(key: "mode", expectedValue: "A")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            let geographicPositionResult = gllTypedData.geographicPosition
            switch geographicPositionResult {
            case .success(let geographicPosition):
                XCTAssertEqual(geographicPosition.utcTime, "161229.487")
                XCTAssertEqual(geographicPosition.status, GNNSStatus.dataValid)
                XCTAssertEqual(geographicPosition.mode, LocationMode.autonomous)
                let coordinate2D = geographicPosition.coordinate2D
                XCTAssertEqual(coordinate2D.latitude.value, 37.38746)
                XCTAssertEqual(coordinate2D.longitude.value, -372.05413)
            case .failure(_):
                break
            }
    
        default:
            XCTFail("unexpected message type")
        }
    }

    func testSimple2() throws {
        var statement = NMEAStatement("$GPGLL,3723.2475,N,12158.3416,W,161229.487,V,D*53")
        XCTAssertNil(statement.lastError)
    
        statement.timingDataListener = TestListener()
        let gll = GLLParser()
        let message = try gll.buildMessage(statement)
        switch message {
        case .gll(let rawData, let gllTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPGLL")
            tester.assertValue(key: "latitude", expectedValue: "3723.2475")
            tester.assertValue(key: "latitudeDirection", expectedValue: "N")
            tester.assertValue(key: "longitude", expectedValue: "12158.3416")
            tester.assertValue(key: "longitudeDirection", expectedValue: "W")
            tester.assertValue(key: "utcTime", expectedValue: "161229.487")
            tester.assertValue(key: "status", expectedValue: "V")
            tester.assertValue(key: "mode", expectedValue: "D")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            let geographicPositionResult = gllTypedData.geographicPosition
            switch geographicPositionResult {
            case .success(let geographicPosition):
                XCTAssertEqual(geographicPosition.utcTime, "161229.487")
                XCTAssertEqual(geographicPosition.status, GNNSStatus.dataNotValid)
                XCTAssertEqual(geographicPosition.mode, LocationMode.dgps)
                let coordinate2D = geographicPosition.coordinate2D
                XCTAssertEqual(coordinate2D.latitude.value, 37.38746)
                XCTAssertEqual(coordinate2D.longitude.value, -372.05413)

            case .failure(_):
                break
            }
    
        default:
            XCTFail("unexpected message type")
        }
    }

    func testError1() throws {
        var statement = NMEAStatement("$GPGLL,3723.2475,X,12158.3416,W,161229.487,X,D*4B")
        XCTAssertNil(statement.lastError)
    
        statement.timingDataListener = TestListener()
        let gll = GLLParser()
        let message = try gll.buildMessage(statement)
        switch message {
        case .gll(let rawData, let gllTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPGLL")
            tester.assertValue(key: "latitude", expectedValue: "3723.2475")
            tester.assertValue(key: "latitudeDirection", expectedValue: "X")
            tester.assertValue(key: "longitude", expectedValue: "12158.3416")
            tester.assertValue(key: "longitudeDirection", expectedValue: "W")
            tester.assertValue(key: "utcTime", expectedValue: "161229.487")
            tester.assertValue(key: "status", expectedValue: "X")
            tester.assertValue(key: "mode", expectedValue: "D")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            let geographicPositionResult = gllTypedData.geographicPosition
            switch geographicPositionResult {
            case .success(_):
                XCTFail("Expected result failure")
            case .failure(let error):
                XCTAssertEqual(error as! Coordinate2D.InitError, Coordinate2D.InitError.invalidLatitudeDirection(rawValue: "X", expected: "N/S"))
            }
    
        default:
            XCTFail("unexpected message type")
        }
    }
    
    func testError2() throws {
        var statement = NMEAStatement("$GPGLL,3723.2475,N,12158.3416,X,161229.487,V,X*40")
        XCTAssertNil(statement.lastError)
    
        statement.timingDataListener = TestListener()
        let gll = GLLParser()
        let message = try gll.buildMessage(statement)
        switch message {
        case .gll(let rawData, let gllTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPGLL")
            tester.assertValue(key: "latitude", expectedValue: "3723.2475")
            tester.assertValue(key: "latitudeDirection", expectedValue: "N")
            tester.assertValue(key: "longitude", expectedValue: "12158.3416")
            tester.assertValue(key: "longitudeDirection", expectedValue: "X")
            tester.assertValue(key: "utcTime", expectedValue: "161229.487")
            tester.assertValue(key: "status", expectedValue: "V")
            tester.assertValue(key: "mode", expectedValue: "X")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)
            
            let geographicPositionResult = gllTypedData.geographicPosition

            switch geographicPositionResult {
            case .success(_):
                XCTFail("Expected result failure")
            case .failure(let error):
                XCTAssertEqual(error as! Coordinate2D.InitError, Coordinate2D.InitError.invalidLongitudeDirection(rawValue: "X", expected: "E/W"))
            }
    
        default:
            XCTFail("unexpected message type")
        }
    }
}
