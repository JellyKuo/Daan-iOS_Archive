//
//  NotificationTableViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2018/3/3.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationTableViewController: UITableViewController {
    
    @IBOutlet weak var allowNoti: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allowNoti.setOn(UIApplication.shared.isRegisteredForRemoteNotifications, animated: true)
        print("Notification remote register now state \(UIApplication.shared.isRegisteredForRemoteNotifications)")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func togAllowNoti(_ sender: Any) {
        if !allowNoti.isOn {
            UIApplication.shared.unregisterForRemoteNotifications()
            print("Unregister from remote notification, now state \(UIApplication.shared.isRegisteredForRemoteNotifications)")
        }
        else{
            let application = UIApplication.shared
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {granted, err in
                        if err != nil {
                            fatalError("UNUserNotificationCenter requestAuthorization returned an error! \(String(describing: err))")
                        }
                        if granted{
                            print("Notification permission granted")
                            DispatchQueue.main.async {
                                application.registerForRemoteNotifications()
                                print("Registred from remote notification, now state \(application.isRegisteredForRemoteNotifications)")
                            }
                        }
                        else{
                            print("Notification permission denied")
                            let alert = UIAlertController(title: NSLocalizedString("Failed", comment: "Failed"), message: NSLocalizedString("Notification permission was denied. It's ok, you can always turn it on or off in settings", comment: "NotificationPermDenied"), preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                                print("NotificationPermDenied alert dismissed!")
                            }))
                            self.present(alert,animated: true,completion: nil)
                        }
                })
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
        }
    }
    

    // MARK: - Table view data source
    /*

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    */
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
