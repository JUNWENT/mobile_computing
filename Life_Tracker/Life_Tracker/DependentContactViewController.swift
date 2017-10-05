//
//  DependentContactViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/9/28.
//  Copyright © 2017年 Microsoft. All rights reserved.
//

import UIKit

class DependentContactViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var myPhoto: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    var listOfDependes = [(String?,String?)]()
    
    
    @IBAction func changePhoto(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            myPhoto.image = image
            let imageData : NSData = UIImagePNGRepresentation(myPhoto.image!)! as NSData
            UserDefaults.standard.set(imageData, forKey: "profile")

        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userPressedOnLogOut(_ sender: UIButton) {
        UserDefaults.standard.set(nil,forKey:"Username")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = UserDefaults.standard.object(forKey: "profile") {
            myPhoto.image = UIImage(data: data as! Data)
        }
        if let phone = UserDefaults.standard.object(forKey: "Username") as? String {
            phoneNumber.text = phone
        }
        self.getDenpendents()
    }
    
    func getDenpendents() {
        let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
        let table = client.table(withName: "UserRelationship")
        
        table.read { (result, error) in
            if let err = error {
                //                    self.displayAlertMessage(useMessage: "Please check you network and try again.")
                return
                    print("ERROR ", err)
            } else if let items = result?.items {
                for item in items {
                    if item["guardian"] as? String == self.phoneNumber.text {
                        let name = item["dependentUsername"] as? String
                        let number = item["dependent"] as? String
                        self.listOfDependes.append( (name, number))
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDependents" {
            let dependentsView = segue.destination as! ManageDependentsTableViewController
            dependentsView.dependents = self.listOfDependes
            dependentsView.guardianPhone = self.phoneNumber.text!
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
