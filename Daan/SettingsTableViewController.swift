//
//  SettingsTableViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/12/9.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import KeychainSwift

class SettingsTableViewController: UITableViewController {

    var token:Token? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row{
            case 4:
                clearCurriculum(supressAlert: false)
                break;
            default:
                break;
            }
        }

        else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                logout(supressAlert: false)
                break;
            case 1:
                resetApp()
            default:
                break;
            }
        }
        
        else if indexPath.section == 2 {
            switch indexPath.row{
            case 0:
                guard let usersDefault = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
                    fatalError("Cannot init userdefaults with suiteName group.com.Jelly.Daan")
                }
                usersDefault.removeObject(forKey: "SplashDismiss")
                break
            case 1:
                guard let usersDefault = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
                    fatalError("Cannot init userdefaults with suiteName group.com.Jelly.Daan")
                }
                if let JSON = usersDefault.string(forKey: "curriculumJSON"){
                    let alert = UIAlertController(title: "Cached curriculum", message: JSON, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                        UIPasteboard.general.string = JSON
                    }))
                    self.present(alert,animated: true,completion: nil)
                }
                break
            case 2:
                break
            default:
                break
            }
        }
    }
    
    func clearCurriculum(supressAlert:Bool){
        guard let usersDefault = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
            fatalError("Cannot init userdefaults with suiteName group.com.Jelly.Daan")
        }
        usersDefault.removeObject(forKey: "curriculumJSON")
        if(usersDefault.object(forKey: "curriculumJSON") == nil && !supressAlert){
            let alert = UIAlertController(title: NSLocalizedString("Success", comment: "Success"), message: NSLocalizedString("CurrCacheClearSucc", comment: "Curriculum Cache Cleared Successful Message"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                print("Curriculum data cleared alert dismissed!")
            }))
            self.present(alert,animated: true,completion: nil)
        }
    }
    
    func logout(supressAlert:Bool) {
        let keychain = KeychainSwift()
        keychain.clear()
        if(keychain.get("account") == nil&&keychain.get("password") == nil && !supressAlert){
            let alert = UIAlertController(title: NSLocalizedString("Success", comment: "Success"), message: NSLocalizedString("LogoutSuccMsg", comment: "Logout successful message"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                print("Logout success! Clearing nav stack")
                guard let navC = self.navigationController else{
                    fatalError("Cannot get nav controller")
                }
                navC.popToRootViewController(animated: false)
                if let mainVC = navC.childViewControllers[0] as? MainViewController{
                    mainVC.autoLogin()
                }
            }))
            self.present(alert,animated: true,completion:nil)
        }
    }
    
    func resetApp() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        guard let usersDefault = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
            fatalError("Cannot init userdefaults with suiteName group.com.Jelly.Daan")
        }
        usersDefault.removePersistentDomain(forName: "group.com.Jelly.Daan")
        UserDefaults.standard.synchronize()
        logout(supressAlert: true)
        let alert = UIAlertController(title: NSLocalizedString("Success", comment: "Success"), message: NSLocalizedString("AppRstSuccMsg", comment: "Application Reset Successful Message"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            print("Reset success! Clearing nav stack")
            guard let navC = self.navigationController else{
                fatalError("Cannot get nav controller")
            }
            navC.popToRootViewController(animated: false)
            if let mainVC = navC.childViewControllers[0] as? MainViewController{
                mainVC.autoLogin()
            }
        }))
        self.present(alert,animated: true,completion:nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "UpdateUserDataSegue"?:
            let navC = segue.destination as? UINavigationController
            let updateUserDataVC = navC?.viewControllers.first as? UpdUsrAuthViewController
            updateUserDataVC?.token = token
        default:
            break
        }
    }

}
