//
//  ReceiverSignalData.swift
//  
//
//  Created by Rick Hohler on 8/28/22.
//

import Foundation

public typealias DecibelUnit = Int
public typealias BeaconBitRate = Int
public typealias ChannelNumber = Int

public struct ReceiverSignalData {
    public let signalStrength: DecibelUnit
    public let signalToNoiseRatio: DecibelUnit
    public let beaconFrequency: Measurement<UnitFrequency> // kHz base
    public let beaconBitRate: BeaconBitRate
    public let channelNumber: ChannelNumber

    public enum InitError: Error, Equatable {
        case invalidSignalStrength(raw: String, expected: String)
        case invalidSignalToNoiseRatio(raw: String, expected: String)
        case invalidBeaconFrequency(raw: String, expected: String)
        case invalidBeaconBitRate(raw: String, expected: String)
        case invalidChannelNumber(raw: String, expected: String)
    }
}

extension ReceiverSignalData {
    init(rawData: RawData) throws {
        guard let signalStrength = DecibelUnit(rawData.signalStrength) else {
            throw InitError.invalidSignalStrength(raw: rawData.signalStrength, expected: "Valid dB")
        }
        self.signalStrength = signalStrength

        guard let signalToNoiseRatio = DecibelUnit(rawData.signalToNoiseRatio) else {
            throw InitError.invalidSignalToNoiseRatio(raw: rawData.signalToNoiseRatio, expected: "Valid dB")
        }
        self.signalToNoiseRatio = signalToNoiseRatio

        guard let beaconFrequency = Double(rawData.beaconFrequency) else {
            throw InitError.invalidBeaconFrequency(raw: rawData.beaconFrequency, expected: "Valid Double in Kilohertz")
        }
        self.beaconFrequency = Measurement(value: beaconFrequency, unit: UnitFrequency.kilohertz)

        guard let beaconBitRate = Int(rawData.beaconBitRate) else {
            throw InitError.invalidBeaconBitRate(raw: rawData.beaconBitRate, expected: "Valid Int")
        }
        self.beaconBitRate = beaconBitRate

        guard let channelNumber = Int(rawData.channelNumber) else {
            throw InitError.invalidChannelNumber(raw: rawData.channelNumber, expected: "Valid Int")
        }
        self.channelNumber = channelNumber
    }
}


#if targetEnvironment(simulator)

extension ReceiverSignalData {
    public init() {
        self.signalStrength = 50
        self.signalToNoiseRatio = 10
        self.beaconFrequency = Measurement(value: 10, unit: UnitFrequency.hertz)
        self.beaconBitRate = 12
        self.channelNumber = 1
    }
}

#endif
