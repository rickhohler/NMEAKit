//
//  RawDataTester.swift
//  
//
//  Created by Rick Hohler on 10/25/22.
//

import XCTest

import Foundation

@testable import NMEAKit

struct RawDataTester {
    let rawData: RawData
    
    func assertValue(key: String, expectedValue: String) {
        XCTAssertEqual(rawData[dynamicMember: key], expectedValue)
    }
    
    func assertCount(expectedValue: Int) {
        XCTAssertEqual(rawData.data.count, expectedValue)
    }
}
