//
//  UTCDateTests.swift
//  
//
//  Created by Rick Hohler on 10/31/22.
//

import Foundation
import XCTest

@testable import NMEAKit

final class UTCDateTests: XCTestCase {
    
    func testTimeSimple1() throws {
        let time = UTCTimetamp.UTCTime.HHmmss("110105")
        let (format, value) = try time.formatWithValue()
        
        XCTAssertEqual(format, "HHmmss")
        XCTAssertEqual(value, "110105")
    }

    func testTimeSimple2() throws {
        let time = UTCTimetamp.UTCTime.HHmmss_SSS("110105.333")
        let (format, value) = try time.formatWithValue()
        
        XCTAssertEqual(format, "HHmmss.SSS")
        XCTAssertEqual(value, "110105.333")
    }

    func testTimeError1() throws {
        let time = UTCTimetamp.UTCTime.HHmmss("Eleven o'clock")
        do {
            let (_, _) = try time.formatWithValue()
        } catch {
            XCTAssertEqual(error as! UTCTimetampError,
                           UTCTimetampError.invalidUTCTime("Eleven o'clock", "HHmmss(\"Eleven o\\\'clock\")"))
        }
    }
    
    func testTimeError2() throws {
        let time = UTCTimetamp.UTCTime.HHmmss("11:01PM")
        do {
            let (_, _) = try time.formatWithValue()
        } catch {
            XCTAssertEqual(error as! UTCTimetampError,
                           UTCTimetampError.invalidUTCTime("11:01PM", "HHmmss(\"11:01PM\")"))
        }
    }
    
    func testTimeError3() throws {
        let time = UTCTimetamp.UTCTime.HHmmss_SSS("Eleven o'clock")
        do {
            let (_, _) = try time.formatWithValue()
        } catch {
            XCTAssertEqual(error as! UTCTimetampError,
                           UTCTimetampError.invalidUTCTime("Eleven o'clock", "HHmmss_SSS(\"Eleven o\\\'clock\")"))
        }
    }
    
    func testTimeError4() throws {
        let time = UTCTimetamp.UTCTime.HHmmss_SSS("11:01PM")
        do {
            let (_, _) = try time.formatWithValue()
        } catch {
            XCTAssertEqual(error as! UTCTimetampError,
                           UTCTimetampError.invalidUTCTime("11:01PM", "HHmmss_SSS(\"11:01PM\")"))
        }
    }
}
