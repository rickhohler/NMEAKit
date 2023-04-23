//
//  RMCParserTests.swift
//
//
//  Created by Rick Hohler on 10/27/22.
//

import Foundation
import XCTest

@testable import NMEAKit

final class RMCParserTests: XCTestCase {
    
    let expectedRawDataTesterDataCount = 13

    func testSimple1() throws {
        let statement = NMEAStatement("$GPRMC,161229.487,A,3723.2475,N,12158.3416,W,0.13,309.62,120598,,,*3C")
        XCTAssertNil(statement.lastError)
        
        let rmc = RMCParser()
        let message = try rmc.buildMessage(statement)
        switch message {
        case .rmc(let rawData, let rmcTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPRMC")
            tester.assertValue(key: "utcTime", expectedValue: "161229.487")
            tester.assertValue(key: "status", expectedValue: "A")

            tester.assertValue(key: "latitude", expectedValue: "3723.2475")
            tester.assertValue(key: "latitudeDirection", expectedValue: "N")
            tester.assertValue(key: "longitude", expectedValue: "12158.3416")
            tester.assertValue(key: "longitudeDirection", expectedValue: "W")

            tester.assertValue(key: "speed", expectedValue: "0.13")
            tester.assertValue(key: "course", expectedValue: "309.62")
            tester.assertValue(key: "date", expectedValue: "120598")
            tester.assertValue(key: "magneticVariation", expectedValue: "")
            tester.assertValue(key: "eastWestIndicator", expectedValue: "")
            tester.assertValue(key: "mode", expectedValue: "")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)
            
            let gnnsSDataResult = rmcTypedData.gnssData
            switch gnnsSDataResult {
            case .success(let gnnsSData):
                XCTAssertEqual(gnnsSData.timestamp?.timeIntervalSince1970, 884621549.487)
                XCTAssertEqual(gnnsSData.status, GNNSStatus.dataValid)
                
                XCTAssertEqual(gnnsSData.coordinate2D?.latitude.value, 37.38746)
                XCTAssertEqual(gnnsSData.coordinate2D?.longitude.value, -372.05413)

                XCTAssertEqual(gnnsSData.speedOverGround.value, 0.13)
                XCTAssertEqual(gnnsSData.speedOverGround.unit, UnitSpeed.knots)
                XCTAssertEqual(gnnsSData.courseOverGround.value, 309.62)
                XCTAssertEqual(gnnsSData.courseOverGround.unit, UnitAngle.degrees)

                XCTAssertEqual(gnnsSData.mode, LocationMode.defaultValue)

            case .failure(_):
                XCTFail("Not expected result failure")
            }

        default:
            XCTFail("unexpected message type")
        }
    }
}
