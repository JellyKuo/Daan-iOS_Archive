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
    
    @IBOutlet weak var stackView: UIStackView!
    var height:CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // Fallback on earlier versions
            //TODO: Earlier version?
        }
        
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
                generateFullUI(curriculum: curriculum)
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
    
    func generateFullUI(curriculum:CurriculumWeek){
        
        let date = Date()
        let weekday = Calendar.current.component(.weekday, from: date)
        let index:Int
        if weekday <= 6 && weekday >= 2 {
            let hour = Calendar.current.component(.hour, from: date)
            if hour < 16{
                index = weekday - 2
            }
            else{
                index = weekday - 1
            }
        }
        else{
            index = 0
        }
        
        let day:[Curriculum]?
        switch index {
        case 0:
            day = curriculum.week1
        case 1:
            day = curriculum.week2
        case 2:
            day = curriculum.week3
        case 3:
            day = curriculum.week4
        case 4:
            day = curriculum.week5
        default:
            fatalError("index for Monday to Friday is out of range! Date: \(date), Index: \(index)")
        }
        if day == nil {
            fatalError("Got nil in day index \(index)")
        }
        height = 20.0
        for cls in day!{
            let newEntry = createEntry(cls: cls)
            //newEntry.isHidden = true
            stackView.addArrangedSubview(newEntry)
            height += newEntry.frame.height
        }
    }
    
    func createEntry(cls:Curriculum) -> UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor(hex: "fa9d29")
        label.text = " " + cls.start! + "\t" + cls.subject!
        label.font = UIFont.systemFont(ofSize: 24)
        label.textColor = UIColor.white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 2.5
        label.layer.borderColor = label.backgroundColor!.cgColor
        return label
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0.0, height: height)
        } else if activeDisplayMode == .compact {
            preferredContentSize = maxSize
        }
    }
}
