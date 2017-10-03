//
//  AddGuardianViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/9/28.
//  Copyright © 2017年 Microsoft. All rights reserved.
//

import UIKit

class AddGuardianViewController: UIViewController {
    
   
    @IBOutlet weak var DependentSecretPasswordTextfield: UITextField!
    
    @IBOutlet weak var DependentConfirmSecretPasswordTextField: UITextField!
    
    var username:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func userPassedOnAdd(_ sender: UIButton) {
        let guardianSecretPassword = DependentSecretPasswordTextfield.text
        let ConfirmsecretPassword = DependentConfirmSecretPasswordTextField.text
        username = UserDefaults.standard.object(forKey: "DependentUsername") as? String
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserData")
        
        if ((guardianSecretPassword?.isEmpty)! || (ConfirmsecretPassword?.isEmpty)!){
            self.displayAlertMessage(useMessage: "Your must enter a password to reset.")
        }
        
        if (guardianSecretPassword == ConfirmsecretPassword){
            table.update(["id":username!,"secretPassword":guardianSecretPassword!]) {
                (result, error) in
                if let err = error {
                    print("ERROR ", err)
                } else  {
                    self.displayAlertMessage(useMessage: "You have successfully set a secret password!")
                    print("update user secret password")
                }
            }
        } else {
            self.displayAlertMessage(useMessage: "Your password are different.")
        }
    
    }
    
    //display alert message
    func displayAlertMessage(useMessage:String){
        let alert = UIAlertController(title:"ALERT",message:useMessage,preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //display notification message
    func displayNotificationMessage(useMessage:String){
        let alert = UIAlertController(title:"Notification",message:useMessage,preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
