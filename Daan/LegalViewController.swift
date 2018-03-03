//
//  LicenseViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2018/2/28.
//  Copyright © 2018年 郭東岳. All rights reserved.
//

import UIKit
import SafariServices

class LegalViewController: UIViewController {
    
    @IBOutlet weak var txtView: UITextView!
    var license = ""
    var urlStr = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtView.text = license
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ActionTap(_ sender: Any) {
        print("Act Tap")
        
        guard let url = URL(string: urlStr) else {
            print("No url configured")
            return
        }
        
        if #available(iOS 11.0, *) {
            SFSafariShow(url)
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @available(iOS 11.0, *)
    func SFSafariShow(_ url:URL) {
        let config = SFSafariViewController.Configuration()
        let vc = SFSafariViewController(url: url, configuration: config)
        present(vc, animated: true)
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
