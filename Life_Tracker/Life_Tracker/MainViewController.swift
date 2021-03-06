//
//  MainViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/10/5.
//  Copyright © 2017年 Microsoft. All rights reserved.
//
// This controller is for mainPage, on this page, user will be able to choose to
// sign in or register. If the user has signed in before, this page will not show
// again

import UIKit

class MainViewController: UIViewController {
    var username:String?
    
    override func viewDidAppear(_ animated: Bool) {
        username = UserDefaults.standard.object(forKey: "Username") as? String
        if( username != nil){
            self.performSegue(withIdentifier: "In", sender: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
