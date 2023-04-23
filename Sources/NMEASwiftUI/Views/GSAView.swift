//
//  GSAView.swift
//  
//
//  Created by Rick Hohler on 2023-04-20.
//

import SwiftUI
import NMEAKit

struct GSAView: View {
    
    let activeSatellitesData: ActiveSatellitesData?
    let error: (any Error)?
    
    init(typedData: GSATypedData) {
        do {
            self.activeSatellitesData = try typedData.activeSatellitesData()
            self.error = nil
        } catch (let error) {
            self.error = error
            self.activeSatellitesData = nil
        }
    }
    
    var body: some View {
        List {
            if let data = self.activeSatellitesData {
                Section(header: Text("Active Satellites Data", bundle: .module)) {
                    RowContent("mode1", value: "\(data.mode1)", localizeValue: true)
                    RowContent("mode2", value: "\(data.mode2)", localizeValue: true)
                }
            } else if let error = self.error {
                Text(verbatim: "\(error)")
            }
        }.navigationTitle("GSA Message")
    }
}

#if targetEnvironment(simulator)

struct GSAView_Previews: PreviewProvider {
    
    static var gSATypedData: GSATypedData? {
        let statement = try? NMEAKit.parseStatement(line: "$GPGSA,A,3,07,02,26,27,09,04,15,,,,,,1.8,1.0,1.5*33")
        let message = statement?.nmeaData[0].message
        switch message {
        case .gsa(_, let gsaTypedData):
            return gsaTypedData
        default:
            ()
        }
        return nil
    }
    
    static var previews: some View {
        GSAView(typedData: gSATypedData!)
    }
}

#endif
