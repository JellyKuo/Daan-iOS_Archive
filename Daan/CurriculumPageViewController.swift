//
//  CurriculumPageViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/18.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class CurriculumPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var token:Token? = nil
    var curriculumWeek:CurriculumWeek? = nil
    var tableVCs:[CurriculumTableViewController]? = nil
    @IBOutlet weak var weekNavItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //TODO: Offline data storing
        GetData()
        
        self.delegate = self
        self.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: Make this code better
    func GetData() {
        let req = ApiRequest(path: "curriculum", method: .get, token: self.token)
        req.request {(res,apierr,alaerr) in
            if let result = res {
                self.curriculumWeek = CurriculumWeek(JSON: result)
                self.CreatePages()
            }
            else if let apiError = apierr{
                let alert = UIAlertController(title: "錯誤", message: apiError.error, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                    print("Curriculum Error Api alert occured")
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
    
    func CreatePages(){
        guard let data = curriculumWeek else{
            let alert = UIAlertController(title: "錯誤", message: "Create page is called but curriculumWeek is nil", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
                print("Create page is called but curriculumWeek is nil")
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        tableVCs = []
        let w1VC = storyboard?.instantiateViewController(withIdentifier: "CurriculumTableView") as! CurriculumTableViewController
        let w2VC = storyboard?.instantiateViewController(withIdentifier: "CurriculumTableView") as! CurriculumTableViewController
        let w3VC = storyboard?.instantiateViewController(withIdentifier: "CurriculumTableView") as! CurriculumTableViewController
        let w4VC = storyboard?.instantiateViewController(withIdentifier: "CurriculumTableView") as! CurriculumTableViewController
        let w5VC = storyboard?.instantiateViewController(withIdentifier: "CurriculumTableView") as! CurriculumTableViewController
        w1VC.curriculums = data.week1
        w2VC.curriculums = data.week2
        w3VC.curriculums = data.week3
        w4VC.curriculums = data.week4
        w5VC.curriculums = data.week5
        tableVCs?.append(w1VC)
        tableVCs?.append(w2VC)
        tableVCs?.append(w3VC)
        tableVCs?.append(w4VC)
        tableVCs?.append(w5VC)
        
        let date = Date()
        let weekday = Calendar.current.component(.weekday, from: date)
        let index:Int
        if weekday < 5 && weekday != 1{
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
        SetNavTitle(week: index)
        setViewControllers([tableVCs![index]], direction: .forward, animated: false, completion: nil)
    }
    
    func SetNavTitle(week:Int){
        let weekdayStr:String
        switch week {
        case 0:
            weekdayStr = NSLocalizedString("Mon", comment: "Monday")
        case 1:
            weekdayStr = NSLocalizedString("Tue", comment: "Tuesday")
        case 2:
            weekdayStr = NSLocalizedString("Wed", comment: "Wednesday")
        case 3:
            weekdayStr = NSLocalizedString("Thu", comment: "Thursday")
        case 4:
            weekdayStr = NSLocalizedString("Fri", comment: "Friday")
        default:
            print("Got \(week) as week number in CurriculumTableViewController, which doesn't match 0~5")
            weekdayStr = String(week)
        }
        
        weekNavItem.title = weekdayStr
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = tableVCs!.index(of: viewController as! CurriculumTableViewController) else {
            return nil
        }
        let previousIndex = index - 1
        guard previousIndex >= 0 && previousIndex < tableVCs!.count else {
            return nil
        }
        return tableVCs![previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = tableVCs!.index(of: viewController as! CurriculumTableViewController) else {
            return nil
        }
        let nextIndex = index + 1
        guard nextIndex >= 0 && nextIndex < tableVCs!.count else {
            return nil
        }
        return tableVCs![nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        if !completed{
            return
        }
        if let currentTableViewController = pageViewController.viewControllers![0] as? CurriculumTableViewController{
            let index = tableVCs?.index(of: currentTableViewController)
            SetNavTitle(week: index!)
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
