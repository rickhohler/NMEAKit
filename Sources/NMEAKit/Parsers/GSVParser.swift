//
//  GSVParser.swift
//  
//
//  Created by Rick Hohler on 8/16/22.
//

import Foundation

struct GSVParser: StatementParser, RawDataBuildable {
    static let messageId = "$GPGSV"

    static let satellitesEntryStart = 4

    static let orderedHeaders = ["messageId", "numberOfStatements", "messageNumber", "satellitesInView"]

    func buildMessage(_ statement: NMEAStatement) throws -> NMEAMessage {
        var rawData = try buildRawData(range: 0...3, keys: GSVParser.orderedHeaders, statement: statement)
        let satellitesInViewData = SatellitesInViewData(rawData: rawData)
        
        // parse out satellite entries
        var index = GSVParser.satellitesEntryStart
        var satellites = [SatelliteData]()
        var entryCount = 1
        while true {
            guard let entry = try parseSatelliteEntry(startIndex: index, statement: statement) else {
                break
            }
            satellites.append(entry.satellite)
            
            let keys = GSVParser.fields.map { String("\($0)\(entryCount)") }
            let dict = Dictionary(uniqueKeysWithValues: zip(keys, entry.rawValues))
            rawData.appendData(newData: dict)

            index = index + SatelliteData.numberOfElements
            entryCount += 1
        }
        let typedData = GSVTypedData(satellitesInViewData: satellitesInViewData, satellites: satellites)
        return NMEAMessage.gsv(rawData, typedData)
    }
    
    static let fields = ["id", "elevation", "azimuth", "snr"]

    private func parseSatelliteEntry(startIndex: Int, statement: NMEAStatement) throws -> (satellite: SatelliteData, rawValues: [String])? {
         let components = statement.components
         if startIndex <= (components.count - SatelliteData.numberOfElements) {
             let endIndex = startIndex + SatelliteData.numberOfElements - 1
             let rawValues = Array(components[startIndex...endIndex])
             return (try SatelliteData(rawValues: rawValues), rawValues)
         }
         return nil
     }
}

public struct GSVTypedData: TypedData {
    public let satellitesInViewData: SatellitesInViewData
    public let satellites: [SatelliteData]

    public static func sanitizeData(rawData: inout RawData) {
    }
}
