//
//  GLLParser.swift
//  
//
//  Created by Rick Hohler on 8/16/22.
//

import Foundation

struct GLLParser: StatementParser, RawDataBuildable {
    static let messageId = "$GPGLL"

    static let orderedHeaders =
        ["messageId", "latitude", "latitudeDirection", "longitude", "longitudeDirection", "utcTime", "status", "mode"]
    
    func buildMessage(_ statement: NMEAStatement) throws -> NMEAMessage {
        let rawData = try buildRawData(statement: statement)
        let typedData = GLLTypedData(rawData: rawData)
        return NMEAMessage.gll(rawData, typedData)
    }
}

public struct GLLTypedData: TypedData {
    let rawData: RawData

    public var geographicPosition: Result<GeographicPosition, Error> {
        self.buildGeographicPosition()
    }

    private func buildGeographicPosition() -> Result<GeographicPosition, Error> {
        do {
            return .success(try GeographicPosition(rawData: self.rawData))
        } catch {
            return .failure(error)
        }
    }
}
