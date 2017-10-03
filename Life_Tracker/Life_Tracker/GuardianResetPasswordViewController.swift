//
//  GuardianResetPasswordViewController.swift
//  Life_Tracker
//
//  Created by 张子一 on 03/10/2017.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class GuardianResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var ExistingPasswordTextField: UITextField!
    @IBOutlet weak var NewPasswordTextField: UITextField!
    @IBOutlet weak var ConfirmNewPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func UserPressOnResetButton(_ sender: UIButton) {
        let userExistingPassword = ExistingPasswordTextField.text
        let userNewPassword = NewPasswordTextField.text
        let userConfirmNewPassword = ConfirmNewPasswordTextField.text
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserData")
        let userType = "Guardian"
        
        
        var username : String?
        username = UserDefaults.standard.object(forKey: "GuardianUsername")as?String
        
        
        // check needed fields empty
        if ( (userExistingPassword?.isEmpty)! || (userNewPassword?.isEmpty)! || (userConfirmNewPassword?.isEmpty)!){
            displayAlertMessage(useMessage: "Not all the required field is entered! Please check")
            return
        }
        
        // check if password match
        if (userNewPassword != userConfirmNewPassword){
            displayAlertMessage(useMessage: "The passwords do not match")
            return
        }
        
        // check password is vaild
        if !(passwordIsValid(userNewPassword!)){
            displayAlertMessage(useMessage: "The password length must be greater than or equal to 8! The password must at least contain one uppercase character,lowercase character,number and special character.")
            return
        }
        
        table.read { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    if(item["type"] as? String == userType){
                        if (item["phoneNumber"] as? String == username! && item["password"] as? String == userExistingPassword! && item["complete"] as! Bool == false){
                            table.update(["id":username!,"password":userNewPassword!]) {
                                (result, error) in
                                if let err = error {
                                    print("ERROR ", err)
                                } else  {
                                    print("update user password")
                                }
                                self.displayAlertMessage(useMessage: "You have succesfully changed your password!")
                            }
                        } else if (item["phoneNumber"] as? String == username! && item["password"] as? String != userExistingPassword! && item["complete"] as! Bool == false){
                            self.displayAlertMessage(useMessage: "Please enter your correct existing password.")
                        }
                    }
                }
            }
        }
        
        
        
        
        
        
    }
    
    //display alert message
    func displayAlertMessage(useMessage:String){
        let alert = UIAlertController(title:"ALERT",message:useMessage,preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // check if password is valid
    func passwordIsValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Z])(?=.*[!@#$&*]+)(?=.*[0-9])(?=.*[a-z]).{8}$")
        return passwordTest.evaluate(with: password)
        
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
