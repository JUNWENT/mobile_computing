//
//  DependentLoginViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/9/23.
//  Copyright © 2017年 Microsoft. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class DependentLoginViewController: UIViewController,NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var UserIdentificationTextField: UITextField!
    @IBOutlet weak var UserPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func UserPressedOnSignIn(_ sender: Any) {
        let userIdentify = UserIdentificationTextField.text
        let userPassword = UserPasswordTextField.text
        let userType = "Dependent"
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserData")
        let tableUser = client.table(withName: "UserTable")
        let nextController = DependentHomePageViewController();
        
        //check userIdentify is empty
        if ((userIdentify?.isEmpty)! || (userPassword?.isEmpty)!){
            self.displayAlertMessage(useMessage: "Your login failed. Please check your username and password, and try again.")
            return;
        }
        table.read { (result, error) in
            if let err = error {
                print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    if(item["type"] as? String == userType){
                        if (item["phoneNumber"] as? String == userIdentify && item["complete"] as! Bool == false){
                            if (item["password"] as? String == userPassword){
                                // create a item in userTable to store the track information of user
                                let itemToInsert = ["id":userIdentify ?? "unknown user", "complete": false, "__createdAt": Date()] as [String : Any]
                                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                                tableUser.insert(itemToInsert) {
                                    (item, error) in
                                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                    if error != nil {
                                        self.displayAlertMessage(useMessage: "Failure to register. Please check you network and register again.")
                                        print("Error: " + (error! as NSError).description)
                                    }
                                }
                                nextController.username = userIdentify!
                                self.present(nextController,animated: true, completion: nil)
                                print("complete checking the user identify and password")
                            }
                        }
                    }
                }
                self.displayAlertMessage(useMessage: "Your login failed. Please check your username and password, and try again.");
                return;
                
            }
        }
        
        
        
    }
    
    
    //display alert message has depulicate
    func displayAlertMessage(useMessage:String){
        
        let alert = UIAlertController(title:"ALERT",message:useMessage,preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil);
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
