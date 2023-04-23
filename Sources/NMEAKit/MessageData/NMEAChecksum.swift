//
//  NMEAChecksum.swift
//  
//
//  Created by Rick Hohler on 10/25/22.
//

import Foundation

public enum NMEAChecksumError: Error, Equatable {
    case invalidValue(String)
    case invalidLength(Int)
    case invalidVerification(String, String, String)
    case invalidLastElementAndChecksumValue
    
    public static func == (lhs: NMEAChecksumError, rhs: NMEAChecksumError) -> Bool {
        lhs.localizedDescription == rhs.localizedDescription
    }
}

struct NMEAChecksum {

    static func verify(line: String, expectedChecksumValue: String) throws {
        // Compute the checksum by XORing all the character values in the string.
        var checksum = 0;

        let start = line.index(line.startIndex, offsetBy: 1)
        let end = line.index(line.endIndex, offsetBy: -1 * (2 + expectedChecksumValue.count))
        let chkLine = line[start...end]
        for ch in chkLine {
            if let asciiVal = ch.asciiValue {
                checksum = checksum ^ Int(asciiVal)
            }
        }
        
        let formattedValue = String(format:"%02X", checksum)
        guard expectedChecksumValue == formattedValue else {
            throw NMEAChecksumError.invalidVerification(line, formattedValue, expectedChecksumValue)
        }
    }

    static func lastElementValues(components: [String]) throws -> (lastElement: String, checksum: String)? {
        guard components.count > 2 else {
            throw NMEAChecksumError.invalidLastElementAndChecksumValue
        }
        // parse last component; separate out last element and checksum
        // Example 0000*5E; 0000 last element; 5E checksum value
        let lastVal = components[components.count-1]
        let lastComps = lastVal.components(separatedBy: "*")
        guard lastComps.count == 2 else {
            throw NMEAChecksumError.invalidLength(lastComps.count)
        }
        let lastElement = lastComps[0]
        if lastComps.count > 1 {
            let checksum = lastComps[1]
            guard checksum.count == 2 else {
                throw NMEAChecksumError.invalidValue(checksum)
            }
            return (lastElement, checksum)
        }
        return nil
    }
}
