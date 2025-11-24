//
//  CartPricePopoverTableViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/13/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit

class CartPricePopoverTableViewController: UITableViewController {

    var data:[(product: Product, quantity: Int)]!
    var array:[(product: Product, quantity: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = .clear
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame
        self.tableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
        self.tableView.backgroundView = blurEffectView
        for index in 0..<userCart.count {
            let item = userCart[index].product
            let quan = userCart[index].quantity
            array.append((item,quan))
        }
        data = array
    }

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartPricePopoverCell", for: indexPath) as! CartPriceTableViewCellController
        let pro = data[indexPath.row]
        cell.funcSetUpTemp(product: pro.product, quan: pro.quantity)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


}
import MarqueeLabel

class CartPriceTableViewCellController: UITableViewCell {
    
    @IBOutlet weak var price: MarqueeLabel!
    @IBOutlet weak var quantity: MarqueeLabel!
    @IBOutlet weak var category: MarqueeLabel!
    @IBOutlet weak var itemName: MarqueeLabel!
    @IBOutlet weak var type: MarqueeLabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
    
    func funcSetUpTemp(product:Product, quan:Int) {
        var itemtype = ""
        let word = product.id.split(separator: "Æ")
        let id = word[0]
        switch id.count {
        case 14:
            itemtype = "BEAT"
        case 13:
            itemtype = "BEAT"
        case 12:
            itemtype = "INSTRUMENTAL"
        case 20:
            itemtype = "SERVICE"
        case 21:
            itemtype = "BUNDLE"
        case 22:
            itemtype = "KIT"
        case 23:
            itemtype = "APPERAL"
        case 24:
            itemtype = "MEMORABILIA"
        default:
            print("null")
        }
        //24 didgits is memorabilia
        //23 didgits is apperal
        //22 didgits is a kit
        //21 didgits is a bundle
        //20 didgits is a service
        //12
        quantity.text = "Qty: \(quan)"
        price.text = (product.price*Double(quan)).dollarString
        category.text = itemtype
        type.text = " · \(product.type)"
        itemName.text = "\(product.name)"
    }
}
