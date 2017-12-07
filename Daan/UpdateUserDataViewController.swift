//
//  UpdateUserDataViewController.swift
//  Daan
//
//  Created by 郭東岳 on 2017/11/20.
//  Copyright © 2017年 郭東岳. All rights reserved.
//

import UIKit

class UpdateUserDataViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SaveBtnTap(_ sender: Any) {
        //TODO: Perform user data update
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CancelBtnTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
