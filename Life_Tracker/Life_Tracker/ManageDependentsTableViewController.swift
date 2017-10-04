//
//  ManageDependentsTableViewController.swift
//  Life_Tracker
//
//  Created by Mingyan Wei on 3/10/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class ManageDependentsTableViewController: UITableViewController {
    var dependents = Array<(String?, String?)>()
    
    @IBOutlet var dependentsTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(dependents.count)
        return dependents.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> DependentTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dependent", for: indexPath) as! DependentTableViewCell

        // Configure the cell...
        cell.name.text = dependents[indexPath.row].0
        cell.phone.text = dependents[indexPath.row].1

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let client = MSClient(applicationURLString: "https://life-tracker.azurewebsites.net")
            let table = client.table(withName: "UserRelationship")
            
            table.read { (result, error) in
                if let err = error {
                    //                    self.displayAlertMessage(useMessage: "Please check you network and try again.")
                    return
                        print("ERROR ", err)
                } else if let items = result?.items {
                    for item in items {
                        print("index ",indexPath.row)
                        if item["dependent"] as? String == self.dependents[indexPath.row].1 {
                            table.delete(item)
                        }
                    }
                }
            }

//            table.delete(newItem as [NSObject: AnyObject]) {
//                (itemID, error) in
//                if let err = error {
//                    print("ERROR ", err)
//                } else {
//                    print("Todo Item ID: ", itemID)
//                }
//            }
            
            dependentsTable.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            dependents.remove(at: indexPath.row)
            dependentsTable.endUpdates()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
