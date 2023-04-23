//
//  NMEAKit.swift
//
//
//  Created by Rick Hohler on 8/28/22.
//

import Foundation

public enum NMEAKit {
    
    public static func parseStatements(lines: [String]) throws -> NMEAStatements {
        return try NMEAStatements(lines: lines)
    }
    
    public static func parseStatement(line: String) throws -> NMEAStatements {
        return try NMEAStatements(lines: [line])
    }
}

public class NMEAStatements {
    public let nmeaData: [NMEAData]

    public init(lines: [String]) throws {
        var data = [NMEAData]()

        for line in lines {
            let statement = NMEAStatement(line)
            data.append(statement.parseMessage())
        }
        
        self.nmeaData = data
    }
}
