//
//  CheckoutPopoverTableViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/18/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit

class CheckoutPopoverTableViewController: UITableViewController {

    var data:[String] = []
    var currItem:Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = .clear
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
        self.tableView.backgroundView = blurEffectView
    }
    
    func setUpArr(item: Product) {
        data = ["share","included","goto"]
        currItem = item
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkoutPopoverTableViewCellController", for: indexPath) as! CheckoutPopoverTableViewCellController
        let pro = data[indexPath.row]
        cell.funcSetUpTemp(str: pro)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

}

import MarqueeLabel

class CheckoutPopoverTableViewCellController: UITableViewCell {
    
    @IBOutlet weak var title: MarqueeLabel!
    @IBOutlet weak var titleImage: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
    
    func funcSetUpTemp(str:String) {
        switch str {
        case "share":
            title.text = "Share"
            titleImage.image = UIImage(systemName: "square.and.arrow.up")
        case "included":
            title.text = "What's Included"
            titleImage.image = UIImage(systemName: "info.circle")
        default:
            title.text = "Go To Item"
            titleImage.image = UIImage(systemName: "arrowshape.turn.up.right")
        }
    }
}

