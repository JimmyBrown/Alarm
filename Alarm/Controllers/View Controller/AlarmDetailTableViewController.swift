//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Jimmy Brown on 4/21/20.
//  Copyright © 2020 Jimmy Brown. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
  
    
    // MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmTitleLabel: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews() {
        guard let alarm = alarm else { return }
        datePicker.date = alarm.fireDate
        alarmTitleLabel.text = alarm.name
        if alarm.enabled {
            enableButton.setTitle("Disable", for: .normal)
        } else {
            enableButton.setTitle("Enable", for: .normal)
        }
    }
    
    // MARK: Actions
    @IBAction func enableButtonTapped(_ sender: Any) {
        guard let alarm = alarm else { return }
        AlarmController.toggleIsOn(for: alarm)
        if alarm.enabled {
            enableButton.setTitle("Disable", for: .normal)
            enableButton.backgroundColor = .red
        } else {
            enableButton.setTitle("Enable", for: .normal)
            enableButton.backgroundColor = .gray
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if alarm != nil {
            let date = datePicker.date
            let enabled = enableButton.isEnabled
            guard let theName = alarmTitleLabel.text else { return }
            guard let theAlarm = alarm else { return }
            AlarmController.sharedInstance.update(alarm: theAlarm, fireDate: date, name: theName, enabled: enabled)
            print("Updated Alarm")
        } else {
            let date = datePicker.date
            let enabled = enableButton.isEnabled
            guard let theName = alarmTitleLabel.text  else { return }
            AlarmController.sharedInstance.addAlarm(fireDate: date, name: theName, enabled: enabled)
        }
        self.navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
}
