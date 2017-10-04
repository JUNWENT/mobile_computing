//
//  GuardianContactViewController.swift
//  Life_Tracker
//
//  Created by junwenz on 2017/10/3.
//  Copyright © 2017年 Microsoft. All rights reserved.
//

import UIKit

class GuardianContactViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var phone: UILabel!
    
    var listOfDependes = [(String?,String?)]()
    
    @IBAction func UserPressedOnLogout(_ sender: UIButton) {
        UserDefaults.standard.set(nil,forKey:"GuardianUsername")
    }
    
    @IBAction func changePhoto(_ sender: UIButton) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photo.image = image
            let imageData : NSData = UIImagePNGRepresentation(photo.image!)! as NSData
            UserDefaults.standard.set(imageData, forKey: "profile")
            
        }
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = UserDefaults.standard.object(forKey: "profile") {
            photo.image = UIImage(data: data as! Data)
        }
        if let number = UserDefaults.standard.object(forKey: "GuardianUsername") as? String {
            phone.text = number
        }

        self.getDenpendents()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                    if item["guardian"] as? String == self.phone.text {
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
            dependentsView.guardianPhone = self.phone.text!
        }
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
