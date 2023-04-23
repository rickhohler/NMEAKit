//
//  GSAParserTests.swift
//  
//
//  Created by Rick Hohler on 10/27/22.
//

import Foundation
import XCTest

@testable import NMEAKit

final class GSAParserTests: XCTestCase {
    
    let expectedRawDataTesterDataCount = 18

    func testSimple() throws {
        let statement = NMEAStatement("$GPGSA,A,3,07,02,26,27,09,04,15,,,,,,1.8,1.0,1.5*33")
        XCTAssertNil(statement.lastError)
    
        let gsa = GSAParser()
        let message = try gsa.buildMessage(statement)
        switch message {
        case .gsa(let rawData, let gsaTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPGSA")
            tester.assertValue(key: "mode1", expectedValue: "A")
            tester.assertValue(key: "mode2", expectedValue: "3")
            tester.assertValue(key: "satelliteUsed1", expectedValue: "07")
            tester.assertValue(key: "satelliteUsed2", expectedValue: "02")
            tester.assertValue(key: "satelliteUsed3", expectedValue: "26")
            tester.assertValue(key: "satelliteUsed4", expectedValue: "27")
            tester.assertValue(key: "satelliteUsed5", expectedValue: "09")
            tester.assertValue(key: "satelliteUsed6", expectedValue: "04")
            tester.assertValue(key: "satelliteUsed7", expectedValue: "15")
            tester.assertValue(key: "satelliteUsed8", expectedValue: "")
            tester.assertValue(key: "satelliteUsed9", expectedValue: "")
            tester.assertValue(key: "satelliteUsed10", expectedValue: "")
            tester.assertValue(key: "satelliteUsed11", expectedValue: "")
            tester.assertValue(key: "satelliteUsed12", expectedValue: "")
            tester.assertValue(key: "pdop", expectedValue: "1.8")
            tester.assertValue(key: "hdop", expectedValue: "1.0")
            tester.assertValue(key: "vdop", expectedValue: "1.5")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            do {
                let activeSatellitesData = try gsaTypedData.activeSatellitesData()
                XCTAssertEqual(activeSatellitesData.mode1, ActiveSatellitesData.Mode1.automatic)
                XCTAssertEqual(activeSatellitesData.mode2, ActiveSatellitesData.Mode2.three)
                XCTAssertEqual(activeSatellitesData.satellitesUsed[0], "07")
                XCTAssertEqual(activeSatellitesData.satellitesUsed[1], "02")
                XCTAssertEqual(activeSatellitesData.satellitesUsed[2], "26")
                XCTAssertEqual(activeSatellitesData.satellitesUsed[3], "27")
                XCTAssertEqual(activeSatellitesData.satellitesUsed[4], "09")
                XCTAssertEqual(activeSatellitesData.satellitesUsed[5], "04")
                XCTAssertEqual(activeSatellitesData.satellitesUsed[6], "15")
                // Rawdata empty strings for satelliteUsed array data will not be included in the
                // activeSatellitesData.satelitesUsed string array.
                XCTAssertEqual(activeSatellitesData.satellitesUsed.count, 7)
                
                XCTAssertEqual(activeSatellitesData.positionDilutionOfPrecision.rawValue, 1.8)
                XCTAssertEqual(activeSatellitesData.horizontalDilutionOfPrecision.rawValue, 1.0)
                XCTAssertEqual(activeSatellitesData.verticalDilutionOfPrecision.rawValue, 1.5)
            } catch {
                XCTFail("Not expected result failure")
            }
        default:
            XCTFail("unexpected message type")
        }
    }

    func testInvalidMode1() throws {
        let statement = NMEAStatement("$GPGSA,X,3,07,02,26,27,09,04,15,,,,,,1.8,1.0,1.5*2A")
        XCTAssertNil(statement.lastError)

        let gsa = GSAParser()
        let message = try gsa.buildMessage(statement)
        switch message {
        case .gsa(let rawData, let gsaTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPGSA")
            tester.assertValue(key: "mode1", expectedValue: "X")
            tester.assertValue(key: "mode2", expectedValue: "3")
            tester.assertValue(key: "satelliteUsed1", expectedValue: "07")
            tester.assertValue(key: "satelliteUsed2", expectedValue: "02")
            tester.assertValue(key: "satelliteUsed3", expectedValue: "26")
            tester.assertValue(key: "satelliteUsed4", expectedValue: "27")
            tester.assertValue(key: "satelliteUsed5", expectedValue: "09")
            tester.assertValue(key: "satelliteUsed6", expectedValue: "04")
            tester.assertValue(key: "satelliteUsed7", expectedValue: "15")
            tester.assertValue(key: "satelliteUsed8", expectedValue: "")
            tester.assertValue(key: "satelliteUsed9", expectedValue: "")
            tester.assertValue(key: "satelliteUsed10", expectedValue: "")
            tester.assertValue(key: "satelliteUsed11", expectedValue: "")
            tester.assertValue(key: "satelliteUsed12", expectedValue: "")
            tester.assertValue(key: "pdop", expectedValue: "1.8")
            tester.assertValue(key: "hdop", expectedValue: "1.0")
            tester.assertValue(key: "vdop", expectedValue: "1.5")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            do {
                let _ = try gsaTypedData.activeSatellitesData()
                XCTFail("Expected result failure")
            } catch (let error) {
                XCTAssertEqual(error as! ActiveSatellitesData.InitError, ActiveSatellitesData.InitError.invalidActiveMode1Value(rawValue: "X", expected: ActiveSatellitesData.Mode1.expectedValues))
            }
            
        default:
            XCTFail("unexpected message type")
        }
    }

    func testInvalidMode2() throws {
        let statement = NMEAStatement("$GPGSA,M,X,07,02,26,27,09,04,15,,,,,,1.8,1.0,1.5*54")
        XCTAssertNil(statement.lastError)

        let gsa = GSAParser()
        let message = try gsa.buildMessage(statement)
        switch message {
        case .gsa(let rawData, let gsaTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPGSA")
            tester.assertValue(key: "mode1", expectedValue: "M")
            tester.assertValue(key: "mode2", expectedValue: "X")
            tester.assertValue(key: "satelliteUsed1", expectedValue: "07")
            tester.assertValue(key: "satelliteUsed2", expectedValue: "02")
            tester.assertValue(key: "satelliteUsed3", expectedValue: "26")
            tester.assertValue(key: "satelliteUsed4", expectedValue: "27")
            tester.assertValue(key: "satelliteUsed5", expectedValue: "09")
            tester.assertValue(key: "satelliteUsed6", expectedValue: "04")
            tester.assertValue(key: "satelliteUsed7", expectedValue: "15")
            tester.assertValue(key: "satelliteUsed8", expectedValue: "")
            tester.assertValue(key: "satelliteUsed9", expectedValue: "")
            tester.assertValue(key: "satelliteUsed10", expectedValue: "")
            tester.assertValue(key: "satelliteUsed11", expectedValue: "")
            tester.assertValue(key: "satelliteUsed12", expectedValue: "")
            tester.assertValue(key: "pdop", expectedValue: "1.8")
            tester.assertValue(key: "hdop", expectedValue: "1.0")
            tester.assertValue(key: "vdop", expectedValue: "1.5")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            do {
                let _ = try gsaTypedData.activeSatellitesData()
                XCTFail("Expected result failure")
            } catch (let error) {
                XCTAssertEqual(error as! ActiveSatellitesData.InitError, ActiveSatellitesData.InitError.invalidActiveMode2Value(rawValue: "X", expected: ActiveSatellitesData.Mode2.expectedValues))
            }
            
        default:
            XCTFail("unexpected message type")
        }
    }
}

