//
//  GNNSStatus.swift
//  
//
//  Created by Rick Hohler on 8/28/22.
//

public enum GNNSStatus: String, CaseIterable, Decodable {
    
    case dataValid = "A"
    case dataNotValid = "V"
    case unknown

    static var expectedValues: String {
        "\(GNNSStatus.allCases)"
    }

    static let defaultValue = GNNSStatus.unknown
}
