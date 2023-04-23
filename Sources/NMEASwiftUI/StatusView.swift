//
//  StatusView.swift
//  
//
//  Created by Rick Hohler on 2023-04-19.
//

import SwiftUI
import NMEAKit

struct StatusView: View {
    
    let data: Status
    
    var body: some View {
        VStack {
            HStack {
                Text("status", bundle: .module)
                data.localized()
            }
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatusView(data: Status.dataValid)
                .environment(\.locale, .init(identifier: "en"))
        }
    }
}

extension Status {

    public func localized() -> Text {
        switch self {
        case .dataValid:
            return Text("valid", bundle: .module)
        case .dataNotValid:
            return Text("notvalid", bundle: .module)
        case .unknown:
            return Text("unknown", bundle: .module)
        }
    }
}
