//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Jimmy Brown on 4/21/20.
//  Copyright © 2020 Jimmy Brown. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(for cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {

    var alarm: Alarm? {
       didSet {
           updateViews(with: alarm!)
      }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    // Step 2: create the Delegate
    weak var delegate: SwitchTableViewCellDelegate?
    
    func updateViews(with alarm: Alarm) {
        timeLabel.text = alarm.fireTimeString
        nameLabel.text = alarm.name
        alarmSwitch.isOn = alarm.enabled
        
        self.backgroundColor = alarm.enabled ? .orange : .white
    }
    
    
    // MARK: Actions
    @IBAction func switchValueChanged(_ sender: Any) {
        delegate?.switchCellSwitchValueChanged(for: self)
    }
    
} // End of Class
