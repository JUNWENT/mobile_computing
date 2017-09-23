//
//  SignInViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/9/23.
//  Copyright © 2017年 Microsoft. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var UserUsernameTextField: UITextField!
    @IBOutlet weak var UserEmailTextField: UITextField!
    @IBOutlet weak var UserPhoneNumberTextField: UITextField!
    @IBOutlet weak var UserPasswordTextField: UITextField!
    @IBOutlet weak var UserComfirmPasswordTextField: UITextField!
    @IBOutlet weak var CertifySwitch: UISwitch!
    @IBOutlet weak var UserTypeController: UISegmentedControl!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func pressedOnRegisterBotton(_ sender: Any) {
        
        let userName = UserUsernameTextField.text;
        let userEmail = UserEmailTextField.text;
        let userPhoneNumber = UserPhoneNumberTextField.text;
        let userPassword = UserPasswordTextField.text;
        let userComfirmPassword = UserComfirmPasswordTextField.text;
        let UserTypechoice = UserTypeController;
        var UserType:String!;
        
        // get user type
        switch UserTypechoice!.selectedSegmentIndex
        {
        case 0:
            UserType = "Dependent";
            print ("USER IS DEPENDENT");
        case 1:
            UserType = "Guardian";
            print("USER IS GUARDIAN");
        default:
            break; 
        }
        
        // check needed fields empty
        if ((userName?.isEmpty)! || (userPassword?.isEmpty)! || (userPhoneNumber?.isEmpty)! || (userComfirmPassword?.isEmpty)!){
            displayAlertMessage(useMessage: "Not all the required field is entered! Please check");
            return;
        }
        // check if password match 
        if (userPassword != userComfirmPassword){
            displayAlertMessage(useMessage: "The password length must be greater than or equal to 8! The password must at least contain one uppercase character,lowercase character,number and special character");
            return;
        }
        // check password is vaild
        if !(passwordIsValid(userPassword!)){
            displayAlertMessage(useMessage: "The password is not valid");//
            return;
        }
        // check phone number is valid
        if !(phoneNumberisValid(userPhoneNumber!)){
            displayAlertMessage(useMessage: "The phone number is not valid");
            return;
        }
        // check email is valid
        if !(emailIsValid(userEmail!)){
            displayAlertMessage(useMessage: "The email address is not valid");
            return;
        }
        // check if the user certify the terms
        if !(CertifySwitch.isOn){
            displayAlertMessage(useMessage: "You must agree to the Terms & Conditions.");
            return;
        }

        
        // store data to server
        
        // display sucessful reigster message
        
        let alert = UIAlertController(title:"COMFIRMATION",message:"You have sucessfully register!",preferredStyle:UIAlertControllerStyle.alert);
        
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default){
            action in
            self.dismiss(animated: true, completion: nil);
        };
        alert.addAction(okAction);
        self.present(alert, animated: true, completion: nil);
        
        
        
    }

    //display alert message
    func displayAlertMessage(useMessage:String){
        
        let alert = UIAlertController(title:"ALERT",message:useMessage,preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil);
        alert.addAction(okAction);
        self.present(alert, animated: true, completion: nil);
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
        return phoneTest.evaluate(with: phoneNumber);
    }
    
    // check if email is valid
    func emailIsValid(_ email: String) -> Bool{
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
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
