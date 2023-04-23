//
//  LocalizedString.swift
//  
//
//  Created by Rick Hohler on 2023-04-20.
//

import Foundation

struct LocalizedString: CustomStringConvertible {
    
    var key: String

    init(_ key: String) {
        self.key = key
    }

    var description: String {
        NSLocalizedString(key, bundle: .module, comment: "")
    }
}
