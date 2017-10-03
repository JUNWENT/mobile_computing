//
//  DependentResetPasswordViewController.swift
//  Life_Tracker
//
//  Created by 张子一 on 03/10/2017.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class DependentResetPasswordViewController: UIViewController {

    @IBOutlet weak var EnterExistingPassword: UITextField!
   
    @IBOutlet weak var EnterNewPassword: UITextField!
    
    
    @IBOutlet weak var ConfirmNewPassword: UITextField!
    

    @IBAction func UserPressOnReset(_ sender: UIButton) {
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
