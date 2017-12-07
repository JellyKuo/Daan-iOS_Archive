//
//  AbsentTableViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/14.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import ObjectMapper  //TODO: Split array mapping to mapper

class AbsentTableViewController: UITableViewController {
    
    var token:Token? = nil
    var absentState:[AbsentState]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetData()
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let states = absentState{
            return states.count
        }
        else {
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "AbsentTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AbsentTableViewCell
            else{
                fatalError("The dequeued cell is not an instance of AbsentTableViewCell")
        }
        let state = absentState![indexPath.row]
        cell.dateLab.text = state.date
        cell.classLab.text = state.cls
        cell.typeLab.text = state.type
        /*
        if let type = state?.type
        {
            if(type.range(of: "公假") != nil){
                cell.typeLab.textColor = UIColor.green
            }
            else if(type.range(of: "警告") != nil){
                cell.typeLab.textColor = UIColor.yellow
            }
            else if(type.range(of: "小過") != nil ||
                status.range(of: "大過") != nil ){
                cell.typeLab.textColor = UIColor.red
            }
            else{
                cell.typeLab.textColor = UIColor.blue
            }
        }
        */
        return cell
    }
    
    
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
    
    func GetData() {
        let req = ApiRequest(path: "absentstate", method: .get, token: self.token)
        req.requestArr {(res,apierr,alaerr) in
            if let result = res {
                self.absentState = Mapper<AbsentState>().mapArray(JSONArray: result)
                self.tableView.reloadData()
            }
            else if let apiError = apierr{
                let alert = UIAlertController(title: "錯誤", message: apiError.error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    print("Absent Error Api alert occured")
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else if let alamoError = alaerr{
                let alert = UIAlertController(title: "連線錯誤", message: alamoError.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    print("Alamofire Error alert occured")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
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
