//
//  AddGuardianViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/9/28.
//  Copyright © 2017年 Microsoft. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddGuardianViewController: UIViewController,UIGestureRecognizerDelegate {
    
   
    @IBOutlet weak var loading: UIActivityIndicatorView!
  
    var DependentSecretPasswordTextfield: MadokaTextField!
    
    var DependentConfirmSecretPasswordTextField: MadokaTextField!
    
    var username:String?
    
    @IBOutlet weak var GiveColor: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainSize = UIScreen.main.bounds.size
        DependentSecretPasswordTextfield = MadokaTextField(frame:CGRect(x: 30, y: 127, width: mainSize.width - 60, height: 60))
        DependentConfirmSecretPasswordTextField = MadokaTextField(frame:CGRect(x: 30, y: 207, width: mainSize.width - 60, height: 60))
        
        DependentSecretPasswordTextfield.placeholder = "secret password"
        DependentConfirmSecretPasswordTextField.placeholder = "confirm your secret password"
       
        DependentSecretPasswordTextfield.borderColor = GiveColor.backgroundColor!
        DependentConfirmSecretPasswordTextField.borderColor = GiveColor.backgroundColor!
        
        
        DependentSecretPasswordTextfield.placeholderColor = GiveColor.backgroundColor!
        DependentConfirmSecretPasswordTextField.placeholderColor = GiveColor.backgroundColor!
    
        
        DependentConfirmSecretPasswordTextField.placeholderFontScale =  1
        DependentSecretPasswordTextfield.placeholderFontScale = 1
        
        self.view.addSubview(DependentSecretPasswordTextfield)
        self.view.addSubview(DependentConfirmSecretPasswordTextField)
     

        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        self.loading.hidesWhenStopped = true
        let target = self.navigationController?.interactivePopGestureRecognizer!.delegate
        let pan = UIPanGestureRecognizer(target:target,
                                         action:Selector(("handleNavigationTransition:")))
        pan.delegate = self
        self.view.addGestureRecognizer(pan)
        self.navigationController?.interactivePopGestureRecognizer!.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer:
        UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count == 1 {
            return false
        }
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    @IBAction func userPassedOnAdd(_ sender: UIButton) {
        self.loading.startAnimating()
        let guardianSecretPassword = DependentSecretPasswordTextfield.text
        let ConfirmsecretPassword = DependentConfirmSecretPasswordTextField.text
        username = UserDefaults.standard.object(forKey: "Username") as? String
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserData")
        
        if ((guardianSecretPassword?.isEmpty)! || (ConfirmsecretPassword?.isEmpty)!){
            self.displayAlertMessage(useMessage: "Your must enter a password to reset.")
            self.loading.stopAnimating()
        }
        
        if (guardianSecretPassword == ConfirmsecretPassword){
            table.update(["id":username!,"secretPassword":guardianSecretPassword!]) {
                (result, error) in
                if let err = error {
                    print("ERROR ", err)
                } else  {
                    self.displayAlertMessage(useMessage: "You have successfully set a secret password!")
                    self.loading.stopAnimating()
                    print("update user secret password")
                }
            }
        } else {
            self.displayAlertMessage(useMessage: "Your password are different.")
            self.loading.stopAnimating()
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
