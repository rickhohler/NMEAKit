//
//  SignalSection.swift
//  
//
//  Created by Rick Hohler on 2023-04-19.
//

import SwiftUI
import NMEAKit

struct SignalSection: View {
    
    let data: ReceiverSignalData
    
    var body: some View {
        Section(header: Text("Receiver Signal Data", bundle: .module)) {
            RowContent("signalStrength", value: data.signalStrength)
            RowContent("signalToNoiseRatio", value: data.signalToNoiseRatio)
            RowContent(measurement: "beaconFrequency", value: data.beaconFrequency)
            RowContent("beaconBitRate", value: data.beaconBitRate)
            RowContent("channelNumber", value: data.channelNumber)
        }
    }
}

#if targetEnvironment(simulator)

struct SignalSection_Previews: PreviewProvider {
        
    static var previews: some View {
        Form {
            SignalSection(data: ReceiverSignalData())
        }
    }
}

#endif
