//
//  AddGuardianViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/9/28.
//  Copyright © 2017年 Microsoft. All rights reserved.
//

import UIKit

class AddGuardianViewController: UIViewController {
    
    @IBOutlet weak var guardianPhoneNumberTextField: UITextField!
    
    @IBOutlet weak var guardianSecretPassword: UITextField!
    
    var username:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func userPassedOnAdd(_ sender: Any) {
        let guardianPhoneNumber = guardianPhoneNumberTextField.text
        let secretPassword = guardianSecretPassword.text
        username = UserDefaults.standard.object(forKey: "DependentUsername") as? String
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserRelationship")

        
        if((guardianPhoneNumber?.isEmpty)! || (secretPassword?.isEmpty)!){
            displayAlertMessage(useMessage: "You must enter an phone number.")
            return
        }
        
        table.read{ (result,error) in
            if let err = error {
                self.displayAlertMessage(useMessage: "Please check you network and try again.")
                return
                    print ("ERROR",err)
            }else if let items = result?.items{
                for item in items {
                    if(item["id"]as? String == guardianPhoneNumber && item["dependent"]as? String == self.username && item["password"]as? String == secretPassword && item["match"]as? Bool == false){
                        table.update(["id": guardianPhoneNumber, "match":true, "complete": false]) { (result, error) in
                            if let err = error {
                                print("ERROR ", err)
                            } else  {
                                print("update match")
                            }
                        }
                        self.displayNotificationMessage(useMessage: "You have successfully connect with your guardian.")
                        print ("match dependent and guardian")
                    } else if ((item["id"]as? String == guardianPhoneNumber && item["dependent"]as? String == self.username && item["match"]as? Bool == true) || (item["id"]as? String == self.username && item["guardian"]as? String == guardianPhoneNumber && item["match"]as? Bool == true)){
                        self.displayAlertMessage(useMessage: "You have already connect with this guardian")
                        return
                    } else if (item["id"]as? String == guardianPhoneNumber && item["dependent"]as? String == self.username && item["password"]as? String != secretPassword && item["match"]as? Bool == false){
                        self.displayAlertMessage(useMessage: "The guardian phone number or password are not correct. Please check and try agian.")
                        return
                    } else if(item["id"]as? String == self.username && item["guardian"]as? String == guardianPhoneNumber && item["match"]as? Bool == false){
                        table.update(["id": self.username, "password":secretPassword, "complete": false]) { (result, error) in
                            if let err = error {
                                print("ERROR ", err)
                                print ("has error")
                            } else  {
                                print("changing password!")
                            }
                        }
                        self.displayNotificationMessage(useMessage: "You have set your secret password. Please wait for your guardian to connect you.")
                    } else {
                        let itemToInsert = ["id": self.username, "dependent": self.username,"guardian":guardianPhoneNumber,"match":false,"password":secretPassword, "complete": false, "__createdAt": Date()] as [String : Any]
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                        table.insert(itemToInsert) {
                            (item, error) in
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            if error != nil {
                                self.displayAlertMessage(useMessage: "Please check you network and try again.")
                                print("Error: " + (error! as NSError).description)
                            }
                        }
                        self.displayNotificationMessage(useMessage: "You have set your secret password. Please wait for your guardian to connect you.!!!!")
    
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
