//
//  TimingDataNotifier.swift
//  
//
//  Created by Rick Hohler on 10/26/22.
//

import Foundation

class TimingDataNotifier {
    static let notificationName = "TimingDataNotification"
    static let userInfoKeyName = "timestamp"
    
    static func post(data: SiRFTimingData) throws {
        let encodedTimingData = try JSONEncoder().encode(data)
        NotificationCenter.default
            .post(name: NSNotification.Name(TimingDataNotifier.notificationName),
                  object: nil,
                  userInfo: [TimingDataNotifier.userInfoKeyName: encodedTimingData])
    }
    
    class Listener: StatementListener {
        var value: Data?

        init() {
            let nc = NotificationCenter.default
            nc.addObserver(self, selector: #selector(receiveTimingData(_:)), name: Notification.Name(TimingDataNotifier.notificationName), object: nil)
        }
        
        @objc func receiveTimingData(_ notification: Notification) {
            let userInfo = notification.userInfo as? [String: Data] ?? [:]
            self.value = userInfo[TimingDataNotifier.userInfoKeyName]
        }
    }
}
