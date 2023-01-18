//
//  ViewController.swift
//  Reminders
//
//  Created by Robert Lin on 2023/1/16.
//

import UIKit
import UserNotifications


class ViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    
    var models = [MyReminder](){
        didSet {
            MyReminder.saveModels(models)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        table.delegate = self
        table.dataSource = self
        
        if let models = MyReminder.loadModels(){
            self.models = models
        }
    }
    
    @IBAction func didTapAdd() {
        // show add vc
        guard let vc = storyboard?.instantiateViewController(identifier: "add") as? AddViewController else {
            return
        }
        
        vc.title = "New Reminder"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = MyReminder(title: title, body: body, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.table.reloadData()

                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body

                let targetDate = date
                print(targetDate)
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                          from: targetDate),
                                                            repeats: false)

                let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("something went wrong")
                    }
                })
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTaptest() {
        // fire test notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
            if success {
                //schedule test
                self.scheduleTest()
            }
            else if error != nil {
                print("error occurred")
            }
        })
    }
    
    func scheduleTest(){
        let content = UNMutableNotificationContent()
        content.title = "時間到！"
        content.sound = .default
        content.body = "時光匆匆，一分鐘到了！"
        
        let targetDate = Date().addingTimeInterval(60)
        print(targetDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second],
                                                                                                  from: targetDate),
                                                    repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let controller = segue.destination as? DetailViewController,
           let row = table.indexPathForSelectedRow?.row {
            
            controller.reminder = models[row]
        }
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        models.remove(at: indexPath.row)
        table.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        cell.detailTextLabel?.text = formatter.string(from: date)

        cell.textLabel?.font = UIFont(name: "Arial", size: 25)
        cell.detailTextLabel?.font = UIFont(name: "Arial", size: 22)
        return cell
    }
}
    


