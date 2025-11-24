//
//  MerchCategoryTableViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/25/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit

class MerchCategoryTableViewController: UITableViewController {
    
    var categories = ["Sounds","Instrumental Sale","Apparel","Services","Memorabilia","Bundle"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
            categories = ["Loops","Kits"]
            tableView.reloadData()
        case "Apparel":
            performSegue(withIdentifier: "catToApperalUpload", sender: nil)
        case "Instrumental Sale":
            performSegue(withIdentifier: "catToInstrumentalSlaeUpload", sender: nil)
        case "Services":
            performSegue(withIdentifier: "catToServicesUpload", sender: nil)
        case "Memorabilia":
            performSegue(withIdentifier: "catToMemorabiliaUpload", sender: nil)
        case "Loops":
            performSegue(withIdentifier: "catToKitsUpload", sender: nil)
        case "Kits":
            performSegue(withIdentifier: "catToKitsUpload", sender: nil)
        default:
            print("code Error")
        }
    }

}
