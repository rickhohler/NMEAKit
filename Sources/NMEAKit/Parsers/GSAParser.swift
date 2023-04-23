//
//  GSAParser.swift
//  
//
//  Created by Rick Hohler on 8/16/22.
//

struct GSAParser: StatementParser, RawDataBuildable {
    static let messageId = "$GPGSA"

    static let orderedHeaders =
        ["messageId", "mode1", "mode2", "satelliteUsed1", "satelliteUsed2",
         "satelliteUsed3", "satelliteUsed4", "satelliteUsed5", "satelliteUsed6",
         "satelliteUsed7", "satelliteUsed8", "satelliteUsed9", "satelliteUsed10",
         "satelliteUsed11", "satelliteUsed12", "pdop", "hdop", "vdop"]

    func buildMessage(_ statement: NMEAStatement) throws -> NMEAMessage {
        let rawData = try buildRawData(statement: statement)
        let typedData = GSATypedData(rawData: rawData)
        return NMEAMessage.gsa(rawData, typedData)
    }
}

public struct GSATypedData: TypedData {
    let rawData: RawData
    
    public func activeSatellitesData() throws -> ActiveSatellitesData  {
        try ActiveSatellitesData(rawData: self.rawData)
    }

    public static func sanitizeData(rawData: inout RawData) {
    }
}
