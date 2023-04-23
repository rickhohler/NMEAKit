//
//  MSSView.swift
//  
//
//  Created by Rick Hohler on 2023-04-20.
//

import SwiftUI
import NMEAKit

struct MSSView: View {
    
    let signalData: ReceiverSignalData
    
    var body: some View {
        Form {
            SignalSection(data: signalData)
        }
    }
}

#if targetEnvironment(simulator)

struct MSSView_Previews: PreviewProvider {
    static var previews: some View {
        MSSView(signalData: ReceiverSignalData())
    }
}

#endif
