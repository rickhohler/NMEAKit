//
//  ActiveSatellitesSection.swift
//  Mapa
//
//  Created by Rick Hohler on 2023-04-19.
//

import SwiftUI
import NMEAKit

struct ActiveSatellitesSection: View {
    
    let data: ActiveSatellitesData
    
    var body: some View {
        Section(header: Text("Active Satellites Data", bundle: .module)) {
            RowContent("mode1", value: "\(data.mode1)")
            RowContent("mode2", value: "\(data.mode2)")
        }
    }
}

#if targetEnvironment(simulator)

struct ActiveSatellitesSection_Previews: PreviewProvider {
        
    static var previews: some View {
        Form {
            ActiveSatellitesSection(data: ActiveSatellitesData())
        }
    }
}

#endif
