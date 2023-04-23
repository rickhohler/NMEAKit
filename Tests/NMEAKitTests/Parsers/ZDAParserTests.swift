//
//  ZDAParserTests.swift
//  
//
//  Created by Rick Hohler on 11/2/22.
//

import Foundation
import XCTest

@testable import NMEAKit

final class ZDAParserTests: XCTestCase {
    
    let expectedRawDataTesterDataCount = 7

    func testSimple1() throws {
        let statement = NMEAStatement("$GPZDA,181813,14,10,2003,00,00*4F")
        XCTAssertNil(statement.lastError)
        
        let zda = ZDAParser()
        let message = try zda.buildMessage(statement)
        switch message {
        case .zda(let rawData, let zdaTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPZDA")
            tester.assertValue(key: "utcTime", expectedValue: "181813")
            tester.assertValue(key: "day", expectedValue: "14")
            tester.assertValue(key: "month", expectedValue: "10")
            tester.assertValue(key: "year", expectedValue: "2003")
            tester.assertValue(key: "localZoneHour", expectedValue: "00")
            tester.assertValue(key: "localZoneMinutes", expectedValue: "00")

            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)
            
            let timingData = zdaTypedData.timingData
            XCTAssertEqual(try timingData.timestamp.asDate().timeIntervalSince1970, 1042568293.0)
            XCTAssertEqual(timingData.localZoneHour, 0)
            XCTAssertEqual(timingData.localZoneMinutes, 0)

        default:
            XCTFail("unexpected message type")
        }
    }
}
