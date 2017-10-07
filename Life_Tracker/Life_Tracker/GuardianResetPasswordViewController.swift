//
//  GuardianResetPasswordViewController.swift
//  Life_Tracker
//
//  Created by 张子一 on 03/10/2017.
//  Copyright © 2017 Microsoft. All rights reserved.
//

// this controller set the function for user to reset their password. The password has to be valid
// to be stored in the database. If the password is not valid. There will be an alert.

import UIKit
import TextFieldEffects

class GuardianResetPasswordViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var ExistingPasswordTextField: MadokaTextField!
    var NewPasswordTextField: MadokaTextField!
    var ConfirmNewPasswordTextField: MadokaTextField!
    
    @IBOutlet weak var GiveColor: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // set the background and show the textfield to the screen
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        let mainSize = UIScreen.main.bounds.size
        ExistingPasswordTextField = MadokaTextField(frame:CGRect(x: 30, y: 147, width: mainSize.width - 60, height: 50))
        NewPasswordTextField = MadokaTextField(frame:CGRect(x: 30, y: 217, width: mainSize.width - 60, height: 50))
        ConfirmNewPasswordTextField = MadokaTextField(frame:CGRect(x: 30, y: 287, width: mainSize.width - 60, height: 50))
        
        ExistingPasswordTextField.placeholder = "original password"
        NewPasswordTextField.placeholder = "new password"
        ConfirmNewPasswordTextField.placeholder = "confirm your new password"
        
        ExistingPasswordTextField.borderColor = GiveColor.backgroundColor!
        NewPasswordTextField.borderColor = GiveColor.backgroundColor!
        ConfirmNewPasswordTextField.borderColor = GiveColor.backgroundColor!
        
        
        ExistingPasswordTextField.placeholderColor = GiveColor.backgroundColor!
        NewPasswordTextField.placeholderColor = GiveColor.backgroundColor!
        ConfirmNewPasswordTextField.placeholderColor = GiveColor.backgroundColor!
        
        ExistingPasswordTextField.isSecureTextEntry = true
        NewPasswordTextField.isSecureTextEntry = true
        ConfirmNewPasswordTextField.isSecureTextEntry = true
        
        ExistingPasswordTextField.placeholderFontScale =  1
        NewPasswordTextField.placeholderFontScale = 1
        ConfirmNewPasswordTextField.placeholderFontScale = 1
        
        
        self.view.addSubview(ExistingPasswordTextField)
        self.view.addSubview(NewPasswordTextField)
        self.view.addSubview(ConfirmNewPasswordTextField)

        
        self.loading.hidesWhenStopped = true
        // set the gesture setting
        let target = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let pan = UIPanGestureRecognizer(target:target,
                                         action:Selector(("handleNavigationTransition:")))
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    // gesture function
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer:
        UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count == 1 {
            return false
        }
        return true
    }
    
    // hide the keyboard when touch on the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This function check the origin password and if the new password is valid will be stored in the database
    // This function will start working when user click on the reset button
    @IBAction func UserPressOnResetButton(_ sender: UIButton) {
        self.loading.startAnimating()
        let userExistingPassword = ExistingPasswordTextField.text
        let userNewPassword = NewPasswordTextField.text
        let userConfirmNewPassword = ConfirmNewPasswordTextField.text
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserData")
        
        
        var username : String?
        username = UserDefaults.standard.object(forKey: "Username")as?String
        
        
        // check needed fields empty
        if ( (userExistingPassword?.isEmpty)! || (userNewPassword?.isEmpty)! || (userConfirmNewPassword?.isEmpty)!){
            displayAlertMessage(useMessage: "Not all the required field is entered! Please check")
            self.loading.stopAnimating()
            return
        }
        
        // check if password match
        if (userNewPassword != userConfirmNewPassword){
            displayAlertMessage(useMessage: "The passwords do not match")
            self.loading.stopAnimating()
            return
        }
        
        // check password is vaild
        if !(passwordIsValid(userNewPassword!)){
            displayAlertMessage(useMessage: "The password length must be greater than or equal to 8! The password must at least contain one uppercase character,lowercase character,number and special character.")
            self.loading.stopAnimating()
            return
        }
        
        table.read { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    if (item["phoneNumber"] as? String == username! && item["password"] as? String == userExistingPassword! && item["complete"] as! Bool == false){
                        table.update(["id":username!,"password":userNewPassword!]) {
                            (result, error) in
                            if let err = error {
                                print("ERROR ", err)
                            } else  {
                                print("update user password")
                            }
                            self.displayAlertMessage(useMessage: "You have succesfully changed your password!")
                            self.loading.stopAnimating()
                        }
                    } else if (item["phoneNumber"] as? String == username! && item["password"] as? String != userExistingPassword! && item["complete"] as! Bool == false){
                        self.displayAlertMessage(useMessage: "Please enter your correct existing password.")
                        self.loading.stopAnimating()
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
