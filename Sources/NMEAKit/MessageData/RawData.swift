//
//  RawData.swift
//  
//
//  Created by Rick Hohler on 10/25/22.
//

import Foundation

public typealias RawDataDictionary = [String:String]

@dynamicMemberLookup
public struct RawData {
    public var data: RawDataDictionary
    
    init(_ data: [String:String] = [:]) {
        self.data = data
    }
    
    public subscript(dynamicMember member: String) -> String {
        if let value = data[member] {
            return value
        }
        print("@dynamicMemberLookup \(member) not found\n\(#function)")
        return ""
    }
    
    mutating func appendData(newData: RawDataDictionary) {
        self.data.merge(newData) { (current, _) in current }
    }
}

public protocol RawDataBuildable {
    static var orderedHeaders: [String] { get }
}

extension RawDataBuildable {

    func buildRawData(statement: NMEAStatement) throws -> RawData{
        let components = statement.components
        return RawData(Dictionary(uniqueKeysWithValues: zip(Self.orderedHeaders, components)))
    }
    
    func buildRawData(range: ClosedRange<Int>, keys: [String], statement: NMEAStatement) throws -> RawData{
        let components = statement.components[range]
        let data = Dictionary(uniqueKeysWithValues: zip(keys, components))
        return RawData(data)
    }
}
