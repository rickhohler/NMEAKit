//
//  RowContent.swift
//
//
//  Created by Rick Hohler on 2023-04-19.
//

import SwiftUI
import NMEAKit

struct RowContent: View {
    let title: String
    let value: String
    let infoText: String?
    
    @State private var showInfo = false

    init(_ title: String, value: String, infoText: String? = nil, localizeValue: Bool = false) {
        self.title = title
        self.value = localizeValue ?
            LocalizedString("\(value)").description : value
        self.infoText = infoText
    }

    init(_ title: String, value: DecibelUnit, infoText: String? = nil) {
        self.title = title
        self.value = "\(value) dB"
        self.infoText = infoText
    }

    init<T: Dimension>(measurement title: String, value: Measurement<T>, infoText: String? = nil) {
        self.title = title
        self.value = value.formatted(.measurement(width: .wide))
        self.infoText = infoText
    }

    var body: some View {
        HStack {
            Text(LocalizedStringKey(title), bundle: .module)
            HStack {
                Text(self.value)
                if let infoText = self.infoText {
                    Button(action: {
                        self.showInfo = true
                    }) {
                        Image(systemName: "info.circle")
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .popover(isPresented: $showInfo, content: {
                        VStack {
                            Text(infoText)
                                .font(.title2)
                            Button("Dismiss") {
                                self.showInfo = false
                            }
                        }
                        .frame(minWidth: 200, minHeight: 200)
                        .cornerRadius(8)
                    })
                }
            }.frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

#if targetEnvironment(simulator)

struct RowContent_Previews: PreviewProvider {
        
    static var previews: some View {
        Form {
            RowContent("foo", value: "fee", infoText: "info info")
        }
    }
}

#endif
