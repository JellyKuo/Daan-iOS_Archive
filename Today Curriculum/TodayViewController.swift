//
//  TodayViewController.swift
//  Today Curriculum
//
//  Created by 郭東岳 on 2017/12/20.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit
import NotificationCenter
import ObjectMapper

class TodayViewController: UIViewController, NCWidgetProviding {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        guard let userDefaults = UserDefaults.init(suiteName: "group.com.Jelly.Daan") else {
            fatalError("Cannot init UserDefaults with suiteName group.com.Jelly.Daan")
        }
        if let JSON = userDefaults.string(forKey: "curriculumJSON"), JSON != "" {
            if let curriculum = CurriculumWeek(JSONString: JSON){
                print("Got curriculum JSON from UserDefaults and mapped to object")
                //TODO: Create UI and display curriculum
            }
            else{
                print("Got curriculum JSON but cannot map it to object")
                //TODO: Prompt to open app
            }
        }
        else {
            print("Got userDefaults but JSON doesn't exist")
            //TODO: Prompt to open app
        }
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
