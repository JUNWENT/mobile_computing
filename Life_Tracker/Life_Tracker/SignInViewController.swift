//
//  SignInViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/9/23.
//  Copyright © 2017年 Microsoft. All rights reserved.
//
// This controller is for the Register page. In this page, user will have to
// enter his valid password, unique phone number and a username.

import UIKit
import TextFieldEffects

class SignInViewController: UIViewController,UITextFieldDelegate {
    
    var UserUsernameTextField: MadokaTextField!
    var UserPhoneNumberTextField: MadokaTextField!
    var UserPasswordTextField: MadokaTextField!
    var UserComfirmPasswordTextField: MadokaTextField!
    
    @IBOutlet weak var buttonRegister: UIButton!
    @IBOutlet weak var GiveColor: UITextView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    
    
    override func viewDidLoad() {
        // showing animated text field
        let mainSize = UIScreen.main.bounds.size
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.loading.hidesWhenStopped = true
        UserUsernameTextField = MadokaTextField(frame:CGRect(x: 30, y: 167, width: mainSize.width - 60, height: 50))
        UserPhoneNumberTextField = MadokaTextField(frame:CGRect(x: 30, y: 227, width: mainSize.width - 60, height: 50))
        UserPasswordTextField = MadokaTextField(frame:CGRect(x: 30, y: 287, width: mainSize.width - 60, height: 50))
        UserComfirmPasswordTextField = MadokaTextField(frame:CGRect(x: 30, y: 347, width: mainSize.width - 60, height: 50))
        UserUsernameTextField.placeholder = "username"
        UserPhoneNumberTextField.placeholder = "phone number"
        UserPasswordTextField.placeholder = "password"
        UserComfirmPasswordTextField.placeholder = "confirm your password"
        
        UserPasswordTextField.isSecureTextEntry = true
        UserComfirmPasswordTextField.isSecureTextEntry = true
        
        UserUsernameTextField.borderColor = GiveColor.textColor!
        UserPasswordTextField.borderColor = GiveColor.textColor!
        UserPhoneNumberTextField.borderColor = GiveColor.textColor!
        UserComfirmPasswordTextField.borderColor = GiveColor.textColor!
        
        UserUsernameTextField.placeholderColor =  GiveColor.textColor!
        UserPasswordTextField.placeholderColor = GiveColor.textColor!
        UserPhoneNumberTextField.placeholderColor = GiveColor.textColor!
        UserComfirmPasswordTextField.placeholderColor = GiveColor.textColor!
        
        UserUsernameTextField.placeholderFontScale =  0.7
        UserPasswordTextField.placeholderFontScale = 0.7
        UserPhoneNumberTextField.placeholderFontScale = 0.7
        UserComfirmPasswordTextField.placeholderFontScale = 0.7
        
        self.view.addSubview(UserUsernameTextField)
        self.view.addSubview(UserPhoneNumberTextField)
        self.view.addSubview(UserPasswordTextField)
        self.view.addSubview(UserComfirmPasswordTextField)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    // This function checks if the phone number is unique and valid, if the password
    // is valid. And if all the information is valid, the user`s data will be stored
    // into the database and back to mainPage.
    @IBAction func pressedOnRegisterBotton(_ sender: UIButton) {
        self.loading.startAnimating()
        
        let userName = UserUsernameTextField.text
        let userPhoneNumber = UserPhoneNumberTextField.text
        let userPassword = UserPasswordTextField.text
        let userComfirmPassword = UserComfirmPasswordTextField.text
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserData")
       
        
        // check needed fields empty
        if ((userName?.isEmpty)! || (userPassword?.isEmpty)! || (userPhoneNumber?.isEmpty)! || (userComfirmPassword?.isEmpty)!){
            displayAlertMessage(useMessage: "Not all the required field is entered! Please check")
            self.loading.stopAnimating()
            return
        }
        
        // check if password match
        if (userPassword != userComfirmPassword){
            displayAlertMessage(useMessage: "The passwords do not match")
            self.loading.stopAnimating()
            return
        }
        
        // check password is vaild
        if !(passwordIsValid(userPassword!)){
            displayAlertMessage(useMessage: "The password length must be greater than or equal to 8! The password must at least contain one uppercase character,lowercase character,number and special character.")
            self.loading.stopAnimating()
            return
        }
        
        // check phone number is valid
        if !(phoneNumberisValid(userPhoneNumber!)){
            displayAlertMessage(useMessage: "The phone number is not valid.")
            self.loading.stopAnimating()
            return
        }
        
        
        // check if the unique phone number has been registerred
        table.read { (result, error) in
            if let err = error {
                self.displayAlertMessage(useMessage: "Failure to register. Please check you network and register again.")
                self.loading.stopAnimating()
                return
                    print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    if (item["phoneNumber"] as? String == userPhoneNumber && item["complete"] as! Bool == false){
                        self.displayAlertMessage(useMessage: "The phone number has been registerred.")
                        self.loading.stopAnimating()
                        return
                    }
                }
                // store data to server
                let itemToInsert = ["username": userName!,"phoneNumber":userPhoneNumber!,"password":userPassword!,"id":userPhoneNumber!, "complete": false, "__createdAt": Date()] as [String : Any]
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                table.insert(itemToInsert) {
                    (item, error) in
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    if error != nil {
                        self.displayAlertMessage(useMessage: "Failure to register. Please check you network and register again.")
                        self.loading.stopAnimating()
                        print("Error: " + (error! as NSError).description)
                    }
                }
                // display sucessful reigster message
                let alert = UIAlertController(title:"COMFIRMATION",message:"You have sucessfully register. Please Sign in.",preferredStyle:UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default){
                    action in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
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
    
    // check if phone number is valid
    func phoneNumberisValid(_ phoneNumber: String) -> Bool{
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return phoneTest.evaluate(with: phoneNumber)
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
