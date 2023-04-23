//
//  GSVParserTests.swift
//  
//
//  Created by Rick Hohler on 10/27/22.
//

import Foundation
import XCTest

@testable import NMEAKit

final class GSVParserTests: XCTestCase {
    
    let expectedRawDataTesterDataCount = 16

    func testSimple1() throws {
        let statement = NMEAStatement("$GPGSV,2,2,07,09,23,313,42,04,19,159,41,15,12,041,42*41")
        XCTAssertNil(statement.lastError)
        
        let gsv = GSVParser()
        let message = try gsv.buildMessage(statement)
        switch message {
        case .gsv(let rawData, let gsvTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPGSV")
            tester.assertValue(key: "numberOfStatements", expectedValue: "2")
            tester.assertValue(key: "messageNumber", expectedValue: "2")
            tester.assertValue(key: "satellitesInView", expectedValue: "07")
            
            // satellite entry 1
            tester.assertValue(key: "id1", expectedValue: "09")
            tester.assertValue(key: "elevation1", expectedValue: "23")
            tester.assertValue(key: "azimuth1", expectedValue: "313")
            tester.assertValue(key: "snr1", expectedValue: "42")
            
            // satellite entry 2
            tester.assertValue(key: "id2", expectedValue: "04")
            tester.assertValue(key: "elevation2", expectedValue: "19")
            tester.assertValue(key: "azimuth2", expectedValue: "159")
            tester.assertValue(key: "snr2", expectedValue: "41")
            
            // satellite entry 3
            tester.assertValue(key: "id3", expectedValue: "15")
            tester.assertValue(key: "elevation3", expectedValue: "12")
            tester.assertValue(key: "azimuth3", expectedValue: "041")
            tester.assertValue(key: "snr3", expectedValue: "42")
            
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            // assert gps fixed data
            let satellitesInViewData = gsvTypedData.satellitesInViewData
            XCTAssertEqual(satellitesInViewData.numberOfStatements, 2)
            XCTAssertEqual(satellitesInViewData.messageNumber, 2)
            XCTAssertEqual(satellitesInViewData.satellitesInView, 7)
            
            let satellites = gsvTypedData.satellites
            XCTAssertEqual(satellites[0].id, "09")
            XCTAssertEqual(satellites[0].elevation.value, 23.0)
            XCTAssertEqual(satellites[0].elevation.unit, UnitAngle.degrees)
            XCTAssertEqual(satellites[0].azimuth.value, 313.0)
            XCTAssertEqual(satellites[0].azimuth.unit, UnitAngle.degrees)
            XCTAssertEqual(satellites[0].snr, "42")
            
            XCTAssertEqual(satellites[1].id, "04")
            XCTAssertEqual(satellites[1].elevation.value, 19.0)
            XCTAssertEqual(satellites[1].elevation.unit, UnitAngle.degrees)
            XCTAssertEqual(satellites[1].azimuth.value, 159.0)
            XCTAssertEqual(satellites[1].azimuth.unit, UnitAngle.degrees)
            XCTAssertEqual(satellites[1].snr, "41")
            
            XCTAssertEqual(satellites[2].id, "15")
            XCTAssertEqual(satellites[2].elevation.value, 12.0)
            XCTAssertEqual(satellites[2].elevation.unit, UnitAngle.degrees)
            XCTAssertEqual(satellites[2].azimuth.value, 41.0)
            XCTAssertEqual(satellites[2].azimuth.unit, UnitAngle.degrees)
            XCTAssertEqual(satellites[2].snr, "42")
            
        default:
            XCTFail("unexpected message type")
        }
    }
}
