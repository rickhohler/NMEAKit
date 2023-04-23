//
//  VTGParser.swift
//  
//
//  Created by Rick Hohler on 8/26/22.
//

import Foundation

struct VTGParser: StatementParser, RawDataBuildable {
    static let messageId = "$GPVTG"

    static let orderedHeaders =
        ["messageId", "course1", "course1Ref", "course2", "course2Ref", "speed1",
         "speed1Units", "speed2", "speed2Units", "mode"]
    
    func buildMessage(_ statement: NMEAStatement) throws -> NMEAMessage {
        let rawData = try buildRawData(statement: statement)
        let typedData = VTGTypedData(rawData: rawData)
        return NMEAMessage.vtg(rawData, typedData)
    }
}

public struct VTGTypedData: TypedData {
    private let rawData: RawData

    public var courseAndSpeedData: Result<CourseAndSpeedData, Error> {
        do {
            return .success(try self.buildCourseAndSpeedData())
        } catch {
            return .failure(error)
        }
    }
    
    init(rawData: RawData) {
        self.rawData = rawData
    }
    
    private func buildCourseAndSpeedData() throws -> CourseAndSpeedData {
        try CourseAndSpeedData(rawData: rawData)
    }

    public static func sanitizeData(rawData: inout RawData) {
    }
}
