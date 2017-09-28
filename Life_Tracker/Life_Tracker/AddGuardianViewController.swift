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
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserRelationship")
        let tableUser = client.table(withName: "userData")
        
        if(guardianPhoneNumber?.isEmpty)!{
            displayAlertMessage(useMessage: "You must enter an phone number.")
            return
        }
        // store data to server
        username = UserDefaults.standard.object(forKey: "DependentUsername") as! String
        let itemToInsert = ["guardian": guardianPhoneNumber, "dependent": username, "read":false,"accept":false,"complete": false, "__createdAt": Date()] as [String : Any]
        
        tableUser.read{ (result, error) in
            if let err = error {
                self.displayAlertMessage(useMessage: "Failure to register. Please check you network and register again.")
                return
                    print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    if (item["phoneNumber"] as? String == guardianPhoneNumber && item["complete"] as! Bool == false){
                        // store data to server
                        UIApplication.shared.isNetworkActivityIndicatorVisible = true
                        table.insert(itemToInsert) {
                            (item, error) in
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                            if error != nil {
                                self.displayAlertMessage(useMessage: "Failure to register. Please check you network and register again.")
                                print("Error: " + (error! as NSError).description)
                            }
                        }
                        // display sucessful reigster message
                        let alert = UIAlertController(title:"COMFIRMATION",message:"You have sent your request to the guardian. Please wait for him to accept.",preferredStyle:UIAlertControllerStyle.alert)
                        
                        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default){
                            action in
                            self.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
                self.displayAlertMessage(useMessage: "This guardian does not exist.")
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
