//
//  MainViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/8.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import KeychainSwift

class MainViewController: UIViewController {
    
    var token:Token?
    var userInfo:UserInfo?
    
    @IBOutlet weak var groupLab: UILabel!
    @IBOutlet weak var clsLab: UILabel!
    @IBOutlet weak var nickLab: UILabel!
    @IBOutlet weak var nameLab: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        autoLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            print("iOS 11 detected! Enabling large navbar title")
        } else {
            print("iOS 11 is not present! Ignoring large navbar title")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserInfo() {
        let req = ApiRequest(path: "actmanage/getUserInfo", method: .get, token: self.token)
        req.request {(res,apierr,alaerr) in
            if let result = res {
                self.userInfo = UserInfo(JSON: result)
                self.nameLab.text = self.userInfo?.name
                self.clsLab.text = self.userInfo?.cls
                self.nickLab.text = self.userInfo?.nick
                self.groupLab.text = self.userInfo?.group
            }
            else if let apiError = apierr{
                if apiError.code == 103{
                    self.autoLogin()
                    return
                }
                let alert = UIAlertController(title: "錯誤", message: apiError.error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    print("Ｍain Error Api alert occured")
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
    
    func autoLogin(){
        let keychain = KeychainSwift()
        guard let account = keychain.get("account"),let password = keychain.get("password") else{
            print("Account and password does not exist in keychain, perform welcome segue")
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "WelcomeSegue", sender: self)
            }
            return
        }
        //TODO: Split this to another class or something
        if(token != nil){
            getUserInfo()
            return
        }
        let req = ApiRequest(path: "actmanage/login", method: .post, params: ["account":account,"password":password])
        req.request {(res,apierr,alaerr) in
            if let result = res {
                self.token = Token(JSON: result)
                print("Got result:\(result)")
                self.getUserInfo()
            }
            else if let apiError = apierr{
                let alert = UIAlertController(title: "登入錯誤", message: apiError.error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    print("Login Error Api alert occured")
                }))
                self.present(alert, animated: true, completion: nil)
                keychain.clear()
                print("Login has API failed! Clearing keychain and performing welcome segue")
                DispatchQueue.main.async(){
                    self.performSegue(withIdentifier: "WelcomeSegue", sender: self)
                }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AttitudeSegue" {
            print("Preparing AttitudeSegue")
            let destVC = segue.destination as! AttitudeTableViewController
            destVC.token = self.token
        }
        else if segue.identifier == "AbsentSegue" {
            print("Preparing AbsentSegue")
            let destVC = segue.destination as! AbsentTableViewController
            destVC.token = self.token
        }
        else if segue.identifier == "SectionalExamSegue" {
            print("Preparing SectionalExamSegue")
            let destVC = segue.destination as! SectionalExamViewController
            destVC.token = self.token
        }
        else if segue.identifier == "HistoryScoreSegue" {
            print("Preparing HistoryScoreSegue")
            let destVC = segue.destination as! HistoryScoreViewController
            destVC.token = self.token
        }
        else if segue.identifier == "CurriculumSegue" {
            print("Preparing CurriculumSegue")
            let destVC = segue.destination as! CurriculumPageViewController
            destVC.token = self.token
        }
        else if segue.identifier == "SettingsSegue" {
            print("Preparing SettingsSegue")
            let destVC = segue.destination as! SettingsTableViewController
            destVC.token = self.token
        }
        else if segue.identifier == "WelcomeSegue" {
            print("Preparing WelcomeSegue")
        }
    }
}
