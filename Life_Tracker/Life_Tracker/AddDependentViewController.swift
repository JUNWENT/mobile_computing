//
//  AddDependentViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/9/28.
//  Copyright © 2017年 Microsoft. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddDependentViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var DependentPhoneNumberTextField: MadokaTextField!
    var DependentSecretPasswordTextField: MadokaTextField!
    
    @IBOutlet weak var GiveColor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainSize = UIScreen.main.bounds.size
        DependentPhoneNumberTextField = MadokaTextField(frame:CGRect(x: 30, y: 127, width: mainSize.width - 60, height: 60))
        DependentSecretPasswordTextField = MadokaTextField(frame:CGRect(x: 30, y: 207, width: mainSize.width - 60, height: 50))
        
        
        DependentSecretPasswordTextField.placeholder = "verification password"
        DependentPhoneNumberTextField.placeholder = "dependent`s phone number"
        
        DependentPhoneNumberTextField.borderColor = GiveColor.backgroundColor!
        DependentSecretPasswordTextField.borderColor = GiveColor.backgroundColor!
      
        
        
        DependentPhoneNumberTextField.placeholderColor = GiveColor.backgroundColor!
        DependentSecretPasswordTextField.placeholderColor = GiveColor.backgroundColor!
        
        DependentSecretPasswordTextField.isSecureTextEntry = true
 
        DependentPhoneNumberTextField.placeholderFontScale =  1
        DependentSecretPasswordTextField.placeholderFontScale = 1

        
        self.view.addSubview(DependentSecretPasswordTextField)
        self.view.addSubview(DependentPhoneNumberTextField)
    

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
    
    @IBAction func UserPressedOnAdd(_ sender: UIButton) {
        self.loading.startAnimating()
        let dependentPhoneNumber = DependentPhoneNumberTextField.text
        let secretPassword = DependentSecretPasswordTextField.text
        var username:String?
        username = UserDefaults.standard.object(forKey: "Username") as? String
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserData")
        let tableRelationship = client.table(withName: "UserRelationship")
        
        if ((dependentPhoneNumber?.isEmpty)! || (secretPassword?.isEmpty)!){
            self.displayAlertMessage(useMessage: "Your must enter a dependent phone number and his secret password.")
            self.loading.stopAnimating()
        }
        
        table.read { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    if (item["phoneNumber"] as? String == dependentPhoneNumber && item["complete"] as! Bool == false){
                        if (item["secretPassword"] as? String == secretPassword){
                            let dependentusername = item["username"] as? String
                            let id = dependentPhoneNumber!+username!
                            
                            let itemToInsert = ["id":id,"guardian":username!,"dependent":dependentPhoneNumber!,"dependentUsername":dependentusername!,"complete": false, "__createdAt": Date()] as [String : Any]
                            UIApplication.shared.isNetworkActivityIndicatorVisible = true
                            tableRelationship.insert(itemToInsert) {
                                (item, error) in
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                if error != nil {
                                    self.displayAlertMessage(useMessage: "Please check you network and try again.")
                                    self.loading.stopAnimating()
                                    print("Error: " + (error! as NSError).description)
                                }
                            }
                            print("complete checking the user identify and password")
                            self.displayNotificationMessage(useMessage: "You have successfully add a dependent.")
                        }
                    }
                    
                }
                self.displayAlertMessage(useMessage: "You fail to add your dependent. Please check secret password and network and then try again.")
                self.loading.stopAnimating()
                return
                
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
