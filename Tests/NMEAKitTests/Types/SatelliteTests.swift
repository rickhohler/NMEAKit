//
//  SatelliteTests.swift
//  
//
//  Created by Rick Hohler on 10/29/22.
//

import Foundation
import XCTest

@testable import NMEAKit

final class SatelliteTests: XCTestCase {
    
    func testActiveSatellitesDataMode1() throws {
        // positive test
        let positive = ActiveSatellitesData.Mode1(rawValue: "M")
        XCTAssertEqual(positive, ActiveSatellitesData.Mode1.manual)

        // negative test
        do {
            _ = try ActiveSatellitesData(rawData: RawData(["mode1": "X"]))
        } catch {
            XCTAssertEqual(error as! ActiveSatellitesData.InitError, ActiveSatellitesData.InitError.invalidActiveMode1Value(rawValue: "X", expected: ActiveSatellitesData.Mode1.expectedValues))
        }
        let negative = ActiveSatellitesData.Mode1(rawValue: "X")
        XCTAssertNil(negative)

    }
}
