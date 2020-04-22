//
//  Alarm.swift
//  Alarm
//
//  Created by Jimmy Brown on 4/21/20.
//  Copyright © 2020 Jimmy Brown. All rights reserved.
//

import Foundation

class Alarm: Codable {
    var fireDate: Date
    var name: String
    var enabled: Bool
    var uuid: String
    var fireTimeString: String {
        let dateFormat = DateFormatter()
        dateFormat.timeStyle = .short
        return dateFormat.string(from: fireDate)
    }

    init(fireDate: Date, name: String, enabled: Bool, uuid: String = UUID().uuidString ) {
        self.fireDate = fireDate
        self.name = name
        self.enabled = enabled
        self.uuid = uuid

    }
}

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

