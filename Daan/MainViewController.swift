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
    
    var token:Token? {
        didSet{
            print("Did set token in MainViewController")
            tokenDelegate?.tokenChanged(token: self.token)
        }
    }
    var userInfo:UserInfo?
    weak var tokenDelegate:tokenDelegate?
    
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var nextClassLab: UILabel!
    @IBOutlet weak var nextClassDescLab: UILabel!
    
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
        
        WelcomeSplash()
        NextClassRefresh()
        getUserInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserInfo() {
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else {
            fatalError("Cannot init UserDefaults with suiteName group.com.Jelly.Daan")
        }
        if let dispName = userDefaults.string(forKey: "dispName") {
            print("Got dispName in userDefaults, using that")
            self.nameLab.text = dispName
        }
        
        let req = ApiRequest(path: "actmanage/getUserInfo", method: .get, token: self.token)
        req.request {(res,apierr,alaerr) in
            if let result = res {
                self.userInfo = UserInfo(JSON: result)
                self.nameLab.text = self.userInfo?.name
            }
            else if let apiError = apierr{
                if apiError.code == 103{
                    fatalError("Token should be valid at this point!")
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
                self.tokenDelegate?.tokenChanged(token: self.token)
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
    
    func WelcomeSplash() {
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else{
            fatalError("Cannot init new UserDefaults with suiteName")
        }
        if userDefaults.bool(forKey: "SplashDismiss"){
            print("SplashDismiss is true, skipping WelcomeSplash")
            return
        }
        print("Splash hasn't displayed before, displaying...")
        performSegue(withIdentifier: "SplashSegue", sender: self)
    }
    
    func NextClassRefresh() {
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else {
            fatalError("Cannot init UserDefaults with suiteName group.com.Jelly.Daan")
        }
        if let JSON = userDefaults.string(forKey: "curriculumJSON"), JSON != "" {
            if let curr = CurriculumWeek(JSONString: JSON){
                print("Got curriculum JSON from UserDefaults and mapped to object")
                let currRes = getCurr(currWeek: curr)
                nextClassLab.text = " " + currRes.subject! + " "
            }
        }
        else{
            print("curriculum JSON is empty, prompting to open curriculum")
            nextClassLab.text = " "+NSLocalizedString("OpenCurriculumToCache", comment: "Tap curriculum below to download cache")+" "
        }
    
    }
    
    func getCurr(currWeek:CurriculumWeek) -> Curriculum {
        let date = Date()
        let weekday = Calendar.current.component(.weekday, from: date)
        let index:Int
        let today:Bool
        if weekday <= 6 && weekday >= 2 {
            let hour = Calendar.current.component(.hour, from: date)
            if hour < 16{
                let minute = Calendar.current.component(.minute, from: date)
                if hour == 15 && minute > 10{
                    today = false
                    if weekday != 6{
                        index = weekday - 1
                    }
                    else{
                        index = 0
                        nextClassDescLab.text = NSLocalizedString("Monday", comment: "Monday")
                        return currWeek.week1![0]
                    }
                }
                else{
                    index = weekday - 2
                    today = true
                }
            }
            else{
                today = false
                if weekday != 6{
                    index = weekday - 1
                }
                else{
                    index = 0
                    nextClassDescLab.text = NSLocalizedString("Monday", comment: "Monday")
                    return currWeek.week1![0]
                }
            }
        }
        else{
            today = false
            index = 0
        }
        
        let res:[Curriculum]?
        switch index {
        case 0:
            res = currWeek.week1
        case 1:
            res = currWeek.week2
        case 2:
            res = currWeek.week3
        case 3:
            res = currWeek.week4
        case 4:
            res = currWeek.week5
        default:
            fatalError("index for Monday to Friday is out of range! Date: \(date), Index: \(index)")
        }
        if let day = res{
            if today{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd "
                let dateStr = dateFormatter.string(from: date)
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                
                for cls in day{
                    let clsTime = dateFormatter.date(from: dateStr + cls.start!)!
                    if date < clsTime{
                        nextClassDescLab.text = NSLocalizedString("Next", comment: "Next")
                        return cls
                    }
                }
                fatalError()
                
            }
            else{
                nextClassDescLab.text = NSLocalizedString("Tomorrow", comment: "Tomorrow")
                return day[0]
            }
        }
        else{
            fatalError("result is NIL")
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
        if segue.identifier == "EmbedTableViewSegue"{
            print("Preparing EmbedTableViewSegue")
            let destVC = segue.destination as! MainTableViewController
            self.tokenDelegate = destVC
        }
    }
}

protocol tokenDelegate:class {
    func tokenChanged(token: Token?)
}
