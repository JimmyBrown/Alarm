//
//  AlarmListTableTableViewController.swift
//  Alarm
//
//  Created by Jimmy Brown on 4/21/20.
//  Copyright © 2020 Jimmy Brown. All rights reserved.
//

import UIKit

class AlarmListTableTableViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        AlarmController.sharedInstance.loadFromPersistentStorage()
        updateView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    func updateView() {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedInstance.alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
        
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        cell.updateViews(with: alarm)
        cell.delegate = self
        
        // Configure the cell...
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // grabs cell to be deleted
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            
            // calls the delete function from the AlarmController
            AlarmController.sharedInstance.delete(alarm: alarm)
            
            // deletes alarm from tableView
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let indexPatch = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? AlarmDetailTableViewController else { return }
            let alarmToSend = AlarmController.sharedInstance.alarms[indexPatch.row]
            destinationVC.alarm = alarmToSend
            destinationVC.title = alarmToSend.name
        }
    }
} // End of Class

extension AlarmListTableTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueChanged(for cell: SwitchTableViewCell) {
        guard let indexPatch = tableView.indexPath(for: cell) else { return }
        let alarmToChange = AlarmController.sharedInstance.alarms[indexPatch.row]
        AlarmController.toggleIsOn(for: alarmToChange)
        cell.updateViews(with: alarmToChange)
    }
}
