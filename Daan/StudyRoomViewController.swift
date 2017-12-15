//
//  StudyRoomViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/12/15.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import WebKit

class StudyRoomViewController: UIViewController,WKNavigationDelegate {
    
    var webView: WKWebView!
    let url:String
    
    required init?(coder aDecoder: NSCoder) {
        let apiConfig = NSDictionary(contentsOfFile:Bundle.main.path(forResource: "ApiConfig", ofType: "plist")!)
        let apiUrl = apiConfig?.object(forKey: "ApiUrl") as! String
        let apiVersion = apiConfig?.object(forKey: "ApiVersion") as! String
        url = "https://" + apiUrl + "/" + apiVersion + "/seatstate"
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let myURL = URL(string: url)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reloadTap(_ sender: Any) {
        webView.reload()
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
