//
//  AlarmController.swift
//  Alarm
//
//  Created by Jimmy Brown on 4/21/20.
//  Copyright © 2020 Jimmy Brown. All rights reserved.
//

import UIKit

protocol AlarmSchedulerDelegate: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

class AlarmController {
    
    // MARK: - Singleton
    static let sharedInstance = AlarmController()
    
    weak var delegate: AlarmSchedulerDelegate?
    
    // MARK: - Source of Truth
    var alarms: [Alarm] = {
        let mockAlarm = Alarm(fireDate: Date(), name: "Alarm1", enabled: true)
        return [mockAlarm]
    }()
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let newAlarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        alarms.append(newAlarm)
        scheduleUserNotifications(for: newAlarm)
        saveToPersistentStorage()
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        cancelUserNotifications(for: alarm)
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        scheduleUserNotifications(for: alarm)
        saveToPersistentStorage()
    }
    
    func delete(alarm: Alarm) {
        guard let indexToDelete = alarms.firstIndex(of: alarm) else { return }
        cancelUserNotifications(for: alarm)
        alarms.remove(at: indexToDelete)
        saveToPersistentStorage()
    }
    
    static func toggleIsOn(for alarm: Alarm) {
        alarm.enabled = !alarm.enabled
        print("\(alarm.enabled)")
    }
    
    // MARK: Persistence
    
    private static func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = urls[0].appendingPathComponent("alarms.json")
        return fileURL
    }

    private func saveToPersistentStorage() {
        let jsonEncoder = JSONEncoder()
        
        do {
            let data = try jsonEncoder.encode(alarms)
            
            try data.write(to: AlarmController.fileURL())
        } catch {
            print("There was an error encoding data \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStorage() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: AlarmController.fileURL())
            let decodedAlarms = try jsonDecoder.decode([Alarm].self, from: data)
            alarms = decodedAlarms
        } catch {
            print("There was an error \(error.localizedDescription)")
        }
    }
} // End of Class


extension AlarmController: AlarmSchedulerDelegate {
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
    
    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        
        notificationContent.title = "Test 1"
        notificationContent.body = "Test 2"
        notificationContent.sound = .default
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: alarm.fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}


