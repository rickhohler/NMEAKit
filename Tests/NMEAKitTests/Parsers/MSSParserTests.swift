//
//  MSSParserTests.swift
//  
//
//  Created by Rick Hohler on 10/30/22.
//

import Foundation
import XCTest

@testable import NMEAKit

final class MSSParserTests: XCTestCase {
    
    let expectedRawDataTesterDataCount = 6
    
    func testSimple1() throws {
        let statement = NMEAStatement("$GPMSS,55,27,318.0,100,1,*7B")
        XCTAssertNil(statement.lastError)
        
        let mss = MSSParser()
        let message = try mss.buildMessage(statement)
        switch message {
        case .mss(let rawData, let mssTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPMSS")
            tester.assertValue(key: "signalStrength", expectedValue: "55")
            tester.assertValue(key: "signalToNoiseRatio", expectedValue: "27")
            tester.assertValue(key: "beaconFrequency", expectedValue: "318.0")
            tester.assertValue(key: "beaconBitRate", expectedValue: "100")
            tester.assertValue(key: "channelNumber", expectedValue: "1")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            let receiverSignalDataResult = mssTypedData.receiverSignalData
            switch receiverSignalDataResult {
            case .success(let receiverSignalData):
                XCTAssertEqual(receiverSignalData.signalStrength, DecibelUnit(55))
                XCTAssertEqual(receiverSignalData.signalToNoiseRatio, DecibelUnit(27))
                XCTAssertEqual(receiverSignalData.beaconFrequency.value, 318.0)
                XCTAssertEqual(receiverSignalData.beaconFrequency.unit, UnitFrequency.kilohertz)
                XCTAssertEqual(receiverSignalData.beaconBitRate, 100)
                XCTAssertEqual(receiverSignalData.channelNumber, 1)

            case .failure(_):
                XCTFail("Not expected result failure")
            }
            
        default:
            XCTFail("unexpected message type")
        }
    }
    
    func testInvalidSignalStrenth() throws {
        let statement = NMEAStatement("$GPMSS,X,27,318.0,100,1,*23")
        XCTAssertNil(statement.lastError)
        
        let mss = MSSParser()
        let message = try mss.buildMessage(statement)
        switch message {
        case .mss(let rawData, let mssTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPMSS")
            tester.assertValue(key: "signalStrength", expectedValue: "X")
            tester.assertValue(key: "signalToNoiseRatio", expectedValue: "27")
            tester.assertValue(key: "beaconFrequency", expectedValue: "318.0")
            tester.assertValue(key: "beaconBitRate", expectedValue: "100")
            tester.assertValue(key: "channelNumber", expectedValue: "1")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            let receiverSignalDataResult = mssTypedData.receiverSignalData
            switch receiverSignalDataResult {
            case .success(_):
                XCTFail("Expected result failure")
            case .failure(let error):
                XCTAssertEqual(error as! ReceiverSignalData.InitError, ReceiverSignalData.InitError.invalidSignalStrength(raw: "X", expected: "Valid dB"))
            }
            
        default:
            XCTFail("unexpected message type")
        }
    }
    
    func testInvalidSignalToNoiseRatio() throws {
        let statement = NMEAStatement("$GPMSS,91,X,318.0,100,1,*2E")
        XCTAssertNil(statement.lastError)
        
        let mss = MSSParser()
        let message = try mss.buildMessage(statement)
        switch message {
        case .mss(let rawData, let mssTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPMSS")
            tester.assertValue(key: "signalStrength", expectedValue: "91")
            tester.assertValue(key: "signalToNoiseRatio", expectedValue: "X")
            tester.assertValue(key: "beaconFrequency", expectedValue: "318.0")
            tester.assertValue(key: "beaconBitRate", expectedValue: "100")
            tester.assertValue(key: "channelNumber", expectedValue: "1")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            let receiverSignalDataResult = mssTypedData.receiverSignalData
            switch receiverSignalDataResult {
            case .success(_):
                XCTFail("Expected result failure")
            case .failure(let error):
                XCTAssertEqual(error as! ReceiverSignalData.InitError, ReceiverSignalData.InitError.invalidSignalToNoiseRatio(raw: "X", expected: "Valid dB"))
            }
            
        default:
            XCTFail("unexpected message type")
        }
    }
    
    func testInvalidBeaconFrequency() throws {
        let statement = NMEAStatement("$GPMSS,91,51,XX,100,1,*56")
        XCTAssertNil(statement.lastError)
        
        let mss = MSSParser()
        let message = try mss.buildMessage(statement)
        switch message {
        case .mss(let rawData, let mssTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPMSS")
            tester.assertValue(key: "signalStrength", expectedValue: "91")
            tester.assertValue(key: "signalToNoiseRatio", expectedValue: "51")
            tester.assertValue(key: "beaconFrequency", expectedValue: "XX")
            tester.assertValue(key: "beaconBitRate", expectedValue: "100")
            tester.assertValue(key: "channelNumber", expectedValue: "1")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            let receiverSignalDataResult = mssTypedData.receiverSignalData
            switch receiverSignalDataResult {
            case .success(_):
                XCTFail("Expected result failure")
            case .failure(let error):
                XCTAssertEqual(error as! ReceiverSignalData.InitError, ReceiverSignalData.InitError.invalidBeaconFrequency(raw: "XX", expected: "Valid Double in Kilohertz"))
            }
            
        default:
            XCTFail("unexpected message type")
        }
    }
    
    func testInvalidBeaconBitRate() throws {
        let statement = NMEAStatement("$GPMSS,51,61,158.1,X,1,*13")
        XCTAssertNil(statement.lastError)
        
        let mss = MSSParser()
        let message = try mss.buildMessage(statement)
        switch message {
        case .mss(let rawData, let mssTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPMSS")
            tester.assertValue(key: "signalStrength", expectedValue: "51")
            tester.assertValue(key: "signalToNoiseRatio", expectedValue: "61")
            tester.assertValue(key: "beaconFrequency", expectedValue: "158.1")
            tester.assertValue(key: "beaconBitRate", expectedValue: "X")
            tester.assertValue(key: "channelNumber", expectedValue: "1")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            let receiverSignalDataResult = mssTypedData.receiverSignalData
            switch receiverSignalDataResult {
            case .success(_):
                XCTFail("Expected result failure")
            case .failure(let error):
                XCTAssertEqual(error as! ReceiverSignalData.InitError, ReceiverSignalData.InitError.invalidBeaconBitRate(raw: "X", expected: "Valid Int"))
            }
            
        default:
            XCTFail("unexpected message type")
        }
    }
    
    func testInvalidChannelNumber() throws {
        let statement = NMEAStatement("$GPMSS,16,27,318.0,100,X,*15")
        XCTAssertNil(statement.lastError)
        
        let mss = MSSParser()
        let message = try mss.buildMessage(statement)
        switch message {
        case .mss(let rawData, let mssTypedData):
            let tester = RawDataTester(rawData: rawData)
            tester.assertValue(key: "messageId", expectedValue: "$GPMSS")
            tester.assertValue(key: "signalStrength", expectedValue: "16")
            tester.assertValue(key: "signalToNoiseRatio", expectedValue: "27")
            tester.assertValue(key: "beaconFrequency", expectedValue: "318.0")
            tester.assertValue(key: "beaconBitRate", expectedValue: "100")
            tester.assertValue(key: "channelNumber", expectedValue: "X")
            tester.assertCount(expectedValue: expectedRawDataTesterDataCount)

            let receiverSignalDataResult = mssTypedData.receiverSignalData
            switch receiverSignalDataResult {
            case .success(_):
                XCTFail("Expected result failure")
            case .failure(let error):
                XCTAssertEqual(error as! ReceiverSignalData.InitError, ReceiverSignalData.InitError.invalidChannelNumber(raw: "X", expected: "Valid Int"))
            }
            
        default:
            XCTFail("unexpected message type")
        }
    }
}
