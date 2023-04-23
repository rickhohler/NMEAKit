//
//  RMCParser.swift
//
//
//  Created by Rick Hohler on 8/18/22.
//

struct RMCParser: StatementParser, RawDataBuildable {
    static let messageId = "$GPRMC"

    static let orderedHeaders: [String] =
        ["messageId", "utcTime", "status", "latitude", "latitudeDirection", "longitude", "longitudeDirection", "speed",
         "course", "date", "magneticVariation", "eastWestIndicator", "mode"]
    
    func buildMessage(_ statement: NMEAStatement) throws -> NMEAMessage {
        let rawData = try buildRawData(statement: statement)
        let typedData = RMCTypedData(rawData: rawData)
        return NMEAMessage.rmc(rawData, typedData)
}
}

public struct RMCTypedData: TypedData {
    let rawData: RawData

    public var gnssData: Result<GNSSData, Error> {
        self.buildGNSSData()
    }
    
    private func buildGNSSData() -> Result<GNSSData, Error> {
        do {
            let data = try GNSSData(rawData: self.rawData)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }

    public static func sanitizeData(rawData: inout RawData) {
    }
}
