//
//  NMEAMessage.swift
//  
//
//  Created by Rick Hohler on 10/23/22.
//

import Foundation

public enum NMEAMessage: Equatable {
    case error(Error)
    case gga(RawData, GGATypedData)
    case gll(RawData, GLLTypedData)
    case gsa(RawData, GSATypedData)
    case gsv(RawData, GSVTypedData)
    case mss(RawData, MSSTypedData)
    case rmc(RawData, RMCTypedData)
    case vtg(RawData, VTGTypedData)
    case zda(RawData, ZDATypedData)
    
    public static func == (lhs: NMEAMessage, rhs: NMEAMessage) -> Bool {
        "\(lhs)" == "\(rhs)"
    }
}
