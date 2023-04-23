//
//  MSSParser.swift
//  
//
//  Created by Rick Hohler on 8/26/22.
//

struct MSSParser: StatementParser, RawDataBuildable {
    static let messageId = "$GPMSS"

    static let orderedHeaders =
        ["messageId", "signalStrength", "signalToNoiseRatio", "beaconFrequency", "beaconBitRate", "channelNumber"]
    
    func buildMessage(_ statement: NMEAStatement) throws -> NMEAMessage {
        let rawData = try buildRawData(statement: statement)
        let typedData = MSSTypedData(rawData: rawData)
        return NMEAMessage.mss(rawData, typedData)
    }
}

public struct MSSTypedData: TypedData {
    let rawData: RawData

    public var receiverSignalData: Result<ReceiverSignalData, Error> {
        do {
            return .success(try ReceiverSignalData(rawData: self.rawData))
        } catch {
            return .failure(error)
        }
    }

    public static func sanitizeData(rawData: inout RawData) {
    }
}
