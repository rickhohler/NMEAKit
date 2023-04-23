//
//  GGAParser.swift
//
//
//  Created by Rick Hohler on 8/18/22.
//

import Foundation

struct GGAParser: StatementParser, RawDataBuildable {
    
    static let messageId = "$GPGGA"
    
    static let orderedHeaders =
        ["messageId", "utcTime", "latitude", "latitudeDirection", "longitude",
         "longitudeDirection", "positionFixIndicator", "satellitesUsed",
         "hdop", "altitude", "altitudeUnits", "geoidSeparation",
         "geoidSeparationUnits", "ageOfDifferentialCorrections", "differentialReferenceStationID"]
    
    func buildMessage(_ statement: NMEAStatement) throws -> NMEAMessage {
        var rawData = try buildRawData(statement: statement)
        
        // TODO: rework?
        if let listenerData = statement.timingDataListener?.value as? Data {
            let siRFTimingData = try JSONDecoder().decode(SiRFTimingData.self, from: listenerData)
            switch siRFTimingData.timestamp.date {
            case .day_month_year(let day, let month, let year):
                rawData.appendData(newData: ["day": String(day), "month": String(month), "year": String(year)])
            case .ddmmyy(_):
                // set default values
                rawData.appendData(newData: ["day": "01", "month": "01", "year": "2001"])
            }
        } else {
            // set default values
            rawData.appendData(newData: ["day": "01", "month": "01", "year": "2001"])
        }
        let typedData = GGATypedData(rawData: rawData)
        return NMEAMessage.gga(rawData, typedData)
    }
}

public struct GGATypedData: TypedData {
    let rawData: RawData

    public var gpsFixedData: Result<GPSFixedData, Error> {
        self.buildGPSFixedData()
    }
     
    private func buildGPSFixedData() -> Result<GPSFixedData, Error> {
        do {
            return .success(try GPSFixedData(rawData: self.rawData))
        } catch {
            return .failure(error)
        }
    }
}
