//
//  ViewController.swift
//  Reminders
//
//  Created by Larissa Uchoa on 30/04/20.
//  Copyright © 2020 Larissa Uchoa. All rights reserved.
//

import UserNotifications
import UIKit

class ViewController: UIViewController {

    @IBOutlet var table: UITableView!
    
    var models = [MyReminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        navigationItem.rightBarButtonItem?.tintColor = .magenta
        navigationItem.leftBarButtonItem?.tintColor = .magenta
        navigationItem.backBarButtonItem?.tintColor = .magenta
        
        guard let tabBar = self.tabBarController?.tabBar else { return }
        
        tabBar.tintColor = .magenta
        tabBar.unselectedItemTintColor = .magenta
    }

    @IBAction func didTapAdd () {
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }
        
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        
        scheduleReminder(vc: vc)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func scheduleReminder(vc: AddViewController) {
        vc.completion = {title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, data: date, identifier: "id_\(title)")
                self.models.append(new)
                self.table.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "long_id", content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("something went wrong")
                    }
                })
            }
        }
    }

}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = completeAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [complete])
    }
    
    func completeAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Complete") { (action, view, completion) in
            self.models.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .green
        
        return action
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            self.models.remove(at: indexPath.row)
            self.table.deleteRows(at: [indexPath], with: .automatic)
        }
        action.backgroundColor = .red
        
        return action
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = models[indexPath.row].title

        let date = models[indexPath.row].data
        let formatter = DateFormatter()
        formatter.dateFormat = "dd, MMM, YYY"
        cell.detailTextLabel?.text = formatter.string(from: date)
        
        return cell
        
    }
}
