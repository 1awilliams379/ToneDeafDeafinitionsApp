//
//  EditMerchCategoryTableViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 11/1/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit

class EditMerchCategoryTableViewController: UITableViewController {

    let categories = ["Sounds","Instrumental Sale","Apparel","Services","Memorabilia","Bundle"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = categories[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = categories[indexPath.row]
        switch content {
        case "Sounds":
            performSegue(withIdentifier: "editCatToKitsUpload", sender: nil)
        case "Apparel":
            performSegue(withIdentifier: "editCatToApperalUpload", sender: nil)
        case "Instrumental Sale":
            performSegue(withIdentifier: "editCatToInstrumentalSlaeUpload", sender: nil)
        case "Services":
            performSegue(withIdentifier: "editCatToServicesUpload", sender: nil)
        case "Memorabilia":
            performSegue(withIdentifier: "editCatToMemorabiliaUpload", sender: nil)
        default:
            print("code Error")
        }
    }


}
