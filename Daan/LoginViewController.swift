//
//  LoginViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/8.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import KeychainSwift

class LoginViewController: UIViewController {
    
    var token:Token? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var EmailTxt: UITextField!
    @IBOutlet weak var PasswordTxt: UITextField!
    var activeField: UITextField?
    
    @IBAction func BackBtnTap() {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func ViewTap(_ sender: Any) {
        self.view.endEditing(false)
    }
    
    
    @IBAction func Login(_ sender: Any) {
        let account = EmailTxt.text!
        let password = PasswordTxt.text!
        let req = ApiRequest(path: "actmanage/login", method: .post, params: ["account":account,"password":password])
        req.request {(res,apierr,alaerr) in
            if let result = res {
                self.token = Token(JSON: result)
                print("Got result:\(result)")
                let keychain = KeychainSwift()
                keychain.set(account, forKey: "account")
                keychain.set(password, forKey: "password")
                print("Keychain value set")
                print("Calling performSegue ID:MainSegue")
                self.performSegue(withIdentifier: "MainSegue", sender: self)
            }
            else if let apiError = apierr{
                let alert = UIAlertController(title: "登入錯誤", message: apiError.error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    print("Login Error Api alert occured")
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
/*
class MainSegue: UIStoryboardSegue {
    override func perform() {
        print("MainSegue Performing")
        self.source.present(self.destination as UIViewController,
                            animated: true,
                            completion: nil)
    }
}
*/
