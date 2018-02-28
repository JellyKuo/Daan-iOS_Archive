//
//  LicenseTableViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2018/2/28.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import UIKit

class LicenseTableViewController: UITableViewController {

    let licenses = NSDictionary(contentsOfFile:Bundle.main.path(forResource: "Licenses", ofType: "plist")!)
    
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
    */
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let licName:String
        if indexPath.section == 0{
            //Softwares
            switch indexPath.row{
            case 0:
                licName = "Daan-iOS"
                break
            case 1:
                licName = "Kesshou-Android"
                break
            default:
                return
            }
        }
        else if indexPath.section == 1{
            //Libraries
            switch indexPath.row{
            case 0:
                licName = "Alamofire"
                break
            case 1:
                licName = "ObjectMapper"
                break
            case 2:
                licName = "KeychainSwift"
                break
            default:
                return
            }
        }
        else if indexPath.section == 2{
            switch indexPath.row{
            case 0:
                licName = "Icons8"
                break
            default:
                return
            }
        }
        else {
            return
        }
        let license = licenses?.object(forKey: licName) as? NSDictionary
        let licenseViewController = storyboard?.instantiateViewController(withIdentifier: "LicenseView") as! LicenseViewController
        licenseViewController.navigationItem.title = licName
        licenseViewController.license = license?.object(forKey: "License") as! String
        licenseViewController.urlStr = license?.object(forKey: "Url") as! String
        navigationController?.pushViewController(licenseViewController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
