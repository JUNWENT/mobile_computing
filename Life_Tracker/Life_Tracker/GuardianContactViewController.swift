//
//  GuardianContactViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/10/3.
//  Copyright © 2017年 Microsoft. All rights reserved.
//

import UIKit

class GuardianContactViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    @IBAction func UserPressedOnLogout(_ sender: UIButton) {
        UserDefaults.standard.set(nil,forKey:"GuardianUsername")
    }
    
    @IBAction func changePhoto(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
