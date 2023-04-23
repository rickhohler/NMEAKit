//
//  NMEAData.swift
//  
//
//  Created by Rick Hohler on 2023-04-17.
//

import Foundation

public struct NMEAData: Identifiable {
    public let id = UUID()
    public let timestamp = Date()
    public let message: NMEAMessage
    public let statement: NMEAStatement
}
