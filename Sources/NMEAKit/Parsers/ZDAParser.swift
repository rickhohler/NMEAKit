//
//  ZDAParser.swift
//
//  ZDA - SiRF Timing Statement
//
//  Created by Rick Hohler on 8/23/22.
//

struct ZDAParser: StatementParser, RawDataBuildable {
    static let messageId = "$GPZDA"

    static let orderedHeaders =
        ["messageId", "utcTime", "day", "month", "year", "localZoneHour", "localZoneMinutes"]
    
    func buildMessage(_ statement: NMEAStatement) throws -> NMEAMessage {
        let rawData = try buildRawData(statement: statement)
        let timingData = try SiRFTimingData(rawData: rawData)
        try TimingDataNotifier.post(data: timingData)
        let typedData = ZDATypedData(timingData: timingData)
        return NMEAMessage.zda(rawData, typedData)
    }
}

public struct ZDATypedData: TypedData {
    let timingData: SiRFTimingData
}
