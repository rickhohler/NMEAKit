//
//  MessageListView.swift
//  
//
//  Created by Rick Hohler on 2023-04-19.
//

import SwiftUI

struct MessageListView: View {
    var body: some View {
        Label {
            Text("status", bundle: .module)
        } icon: {
            Image("gnss", bundle: .module)
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
