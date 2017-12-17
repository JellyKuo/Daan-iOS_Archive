//
//  SignUpViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/12.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class FirstSignUpViewController: UIViewController {
    
    var token:Token? = nil
    @IBOutlet weak var EmailTxt: TextField!
    @IBOutlet weak var PasswordTxt: TextField!
    @IBOutlet weak var NickTxt: TextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ViewTap(_ sender: Any) {
        self.view.endEditing(false)
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
        let destVC = segue.destination as! SecondSignUpViewController
        destVC.token = self.token
        destVC.Email = self.EmailTxt.text!
        destVC.Password = self.PasswordTxt.text!
        destVC.Nickname = self.NickTxt.text!
    }
    
}

class SecondSignUpViewController: UIViewController {
    
    var token:Token? = nil
    
    var Email:String! = nil
    var Password:String! = nil
    var Nickname:String! = nil
    
    @IBOutlet weak var SchoolAcc: UITextField!
    @IBOutlet weak var SchoolPass: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func PopViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ViewTap(_ sender: Any) {
        self.view.endEditing(false)
    }
    
    @IBAction func RegisterTouch(_ sender: Any) {
        var reg:Register = Register(JSON: [:])!
        reg.email=Email!
        reg.password = Password!
        reg.nick = Nickname!
        reg.user_group = "student"
        reg.school_account = SchoolAcc.text!
        reg.school_pwd = SchoolPass.text!
        
        let req = ApiRequest(path: "actmanage/register", method: .post, params: reg.toJSON())
        req.request{(res,apierr,alaerr) in
            if let result = res {
                self.token = Token(JSON: result)
                print("Got result:\(result)")
                print("Calling performSegue ID:MainSegue")
                self.performSegue(withIdentifier: "MainSegue", sender: self)
            }
            else if let apiError = apierr{
                let alert = UIAlertController(title: "註冊錯誤", message: apiError.error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    print("Register Error Api alert occured")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainSegue" {
            print("Preparing MainSegue")
            let navC = segue.destination as? UINavigationController
            let destVC = navC?.topViewController as! MainViewController
            destVC.token = self.token
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
