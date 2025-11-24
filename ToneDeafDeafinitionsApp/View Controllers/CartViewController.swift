//
//  CartViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/12/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import SPFakeBar
import PKYStepper
import SkeletonView
import Alamofire

class CartViewController: UIViewController {
    
    var tableVisible = false
    var isfirstTimeTransform:Bool = true
    var cartcount = 0
    var currentindex = 0
    
    @IBOutlet weak var collectionheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cartTableView:UITableView!
    
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var page: UIPageControl!
    
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var totalButton: UIButton!
    @IBOutlet weak var cartLabel: UILabel!
    
    let fakebar = SPFakeBarView.init(style: .small)

    override func viewDidLoad() {
        super.viewDidLoad()
        itemsCollectionView.delaysContentTouches = false
        itemsCollectionView.canCancelContentTouches = true
        cartTableView.tableFooterView = UIView()
        cartcount = userCart.count
        totalButton.addTarget(self, action: #selector(totalTapped), for: .touchUpInside)
        //page.numberOfPages = userCart.count
        cartTableView.delegate = self
        cartTableView.dataSource = self
        cartLabel.text = "Cart"
        totalButton.setTitle("Total: \(userCart.amount.dollarString)", for: .normal)
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        checkoutButton.layer.cornerRadius = 7
        totalButton.layer.cornerRadius = 7
        fakebar.elementsColor = .black
        fakebar.leftButton.setTitle("Remove", for: .normal)
        fakebar.leftButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        fakebar.leftButton.setTitleColor(Constants.Colors.redApp, for: .normal)
        fakebar.leftButton.isHidden = true
        if userCart.countQuantities != 0 {
            cartLabel.text = "Cart (\(userCart.countQuantities))"
            fakebar.rightButton.isHidden = false
            fakebar.rightButton.setTitle("Edit", for: .normal)
            fakebar.rightButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
            fakebar.rightButton.setTitleColor(Constants.Colors.redApp, for: .normal)
        }
        view.addSubview(fakebar)
        // Do any additional setup after loading the view.
    }
    
    @objc func editTapped() {
        isfirstTimeTransform = true
        switch tableVisible {
        case false:
            tableVisible = true
            cartTableView.isEditing = true
            fakebar.rightButton.setTitle("Cancel", for: .normal)
            UIView.animate(withDuration: 3) { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.fakebar.leftButton.isHidden = false
                strongSelf.tableheightConstraint.constant = 175
                strongSelf.collectionheightConstraint.constant = 0
                strongSelf.view.layoutSubviews()
            }
        default:
            isfirstTimeTransform = true
            tableVisible = false
            cartTableView.isEditing = false
            fakebar.rightButton.setTitle("Edit", for: .normal)
            collectionheightConstraint.constant = 175
            tableheightConstraint.constant = 0
            UIView.animate(withDuration: 3) { [weak self] in
                guard let strongSelf = self else {return}
                strongSelf.view.layoutSubviews()
            }
        }
    }
    
    @objc func deleteTapped() {
        isfirstTimeTransform = true
        guard let indexes = cartTableView.indexPathsForSelectedRows else {return}
        for index in indexes {
            userCart.remove(at: index.row)
        }
        itemsCollectionView.deleteItems(at: indexes)
        //cartTableView.deleteRows(at: indexes, with: .automatic)
        fakebar.leftButton.isHidden = true
        cartLabel.text = "Cart (\(userCart.countQuantities))"
        totalButton.setTitle("Total: \(userCart.amount.dollarString)", for: .normal)
        if userCart.countQuantities == 0 {
            cartLabel.text = "Cart"
            fakebar.rightButton.isHidden = true
        } else {
            itemsCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        tableVisible = false
        cartTableView.isEditing = false
        fakebar.rightButton.setTitle("Edit", for: .normal)
        cartcount = userCart.count
        cartTableView.reloadData()
        itemsCollectionView.reloadData()
        collectionheightConstraint.constant = 175
        tableheightConstraint.constant = 0
        UIView.animate(withDuration: 3) { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.layoutSubviews()
        }
    }
    
    @objc func totalTapped() {
//        let resourseString = "https://api.sandbox.paypal.com/v1/oauth2/token"
//        let parameters = ["Accept": "application/json","Accept-Language": "en_US"]
//        let header = ["AT0WmnhZsb0Pr9jQ_8exYBfmsKe_-KIA4TSs43yf4wnZ_6BAjrk8_FF01dVANDejsJK58aTLx2ayTQvy":"EEJ8btgUcQs2iw2I5ZKxxp-2byXjVrdJDjsa_8I1Qlbllig6YPxHw4ZHMLQXC6ETtIR6lGE866OF90tR","grant_type":"client_credentials"]
//        guard let resourceURL = URL(string: resourseString) else {fatalError()}
//        AF.request(resourceURL, method: .get, parameters: header, encoding: URLEncoding.default, headers: ["Accept": "application/json","Accept-Language": "en_US"]).responseJSON { response in
//            if let status = response.response?.statusCode {
//                switch(status){
//                case 200:
//                    print(response.data)
//                    print("example success")
//                default:
//                    print("error with response status: \(status)")
//                    return
//                }
//            }
//        }
        
        
        let height = cartcount
        let high = height*50
        let vc: CartPricePopoverTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "cartPricePopoverTableViewController") as! CartPricePopoverTableViewController
                // Preferred Size
                vc.preferredContentSize = CGSize(width: 250, height: high)
                vc.modalPresentationStyle = .popover
                let popover: UIPopoverPresentationController = vc.popoverPresentationController!
                popover.delegate = self
                popover.sourceView = self.view
                // RightBarItem
        popover.sourceRect = CGRect(x: totalButton.frame.maxX, y: totalButton.frame.maxY, width: totalButton.frame.width, height: totalButton.frame.height)
                present(vc, animated: true, completion:nil)
    }
    
    @objc func cellmoreTapped() {
        let cell = itemsCollectionView.cellForItem(at: IndexPath(row: currentindex, section: 0)) as! CartCollectionViewCellController
        let height = 3
        let high = height*50
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: CheckoutPopoverTableViewController = storyboard.instantiateViewController(withIdentifier: "checkoutPopoverTableViewController") as! CheckoutPopoverTableViewController
                // Preferred Size
                vc.preferredContentSize = CGSize(width: 250, height: high)
                vc.modalPresentationStyle = .popover
                let popover: UIPopoverPresentationController = vc.popoverPresentationController!
                popover.delegate = self
        popover.sourceView = cell.contentView
        popover.sourceRect = CGRect(x:cell.moreButton.frame.minX ,y: cell.moreButton.frame.minY , width:cell.moreButton.frame.width,height:cell.moreButton.frame.height)
        vc.setUpArr(item: cell.produck)
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func checkoutButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: OpenTheCheckOutNotify, object: nil)
        })
    }
}

extension CartViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }

        
        func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }
}

extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return cartcount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = userCart[indexPath.item].product
        let quantity = userCart[indexPath.item].quantity
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartCollectionViewCellController", for: indexPath) as! CartCollectionViewCellController
        cell.layer.cornerRadius = 10
        if (indexPath.row == 0 && isfirstTimeTransform) {
            isfirstTimeTransform = false
        }else{
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        cell.stepper.incrementCallback = {[weak self] _, count in
            guard let strongSelf = self else {return}
            cell.stepper.countLabel.text = "\(Int(count))"
            userCart.increment(product)
            cell.contentView.layoutSubviews()
            strongSelf.totalButton.setTitle("Total: \(userCart.amount.dollarString)", for: .normal)
            strongSelf.cartLabel.text = "Cart (\(userCart.countQuantities))"
            strongSelf.view.layoutSubviews()
        }
        cell.stepper.decrementCallback = {[weak self] _, count in
            guard let strongSelf = self else {return}
            cell.stepper.countLabel.text = "\(Int(count))"
            userCart.decrement(product)
            cell.contentView.layoutSubviews()
            strongSelf.totalButton.setTitle("Total: \(userCart.amount.dollarString)", for: .normal)
            strongSelf.cartLabel.text = "Cart (\(userCart.countQuantities))"
            strongSelf.view.layoutSubviews()
        }
        cell.moreButton.addTarget(self, action: #selector(cellmoreTapped), for: .touchUpInside)
        cell.funcSetTemp(product: product, quantity: quantity)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 50, height: 175)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        lightImpactGenerator.impactOccurred()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Simulate "Page" Function
        let pageWidth: Float = Float(view.frame.width - 40)
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0
        if targetOffset > currentOffset {
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        }
        else {
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }
        if newTargetOffset < 0 {
            newTargetOffset = 0
        }
        else if (newTargetOffset > Float(scrollView.contentSize.width)){
            newTargetOffset = Float(Float(scrollView.contentSize.width))
        }

        targetContentOffset.pointee.x = CGFloat(currentOffset)
        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)

        // Make Transition Effects for cells
        let duration = 0.2
        var index = newTargetOffset / pageWidth;
        guard var cell:UICollectionViewCell = itemsCollectionView.cellForItem(at: IndexPath(row: Int(index), section: 0)) else {return}
        if (index == 0) { // If first index
            UIView.animate(withDuration: duration, delay: 0.0, options: [ .curveEaseOut], animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            index += 1
            guard let cee = itemsCollectionView.cellForItem(at: IndexPath(row: Int(index), section: 0)) else {return}
            cell = cee
            UIView.animate(withDuration: duration, delay: 0.0, options: [ .curveEaseOut], animations: {
                cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: nil)
        }else{
            UIView.animate(withDuration: duration, delay: 0.0, options: [ .curveEaseOut], animations: {
                cell.transform = CGAffineTransform.identity;
            }, completion: nil)

            index -= 1 // left
            if let cell = itemsCollectionView.cellForItem(at: IndexPath(row: Int(index), section: 0)) {
                UIView.animate(withDuration: duration, delay: 0.0, options: [ .curveEaseOut], animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
                }, completion: nil)
            }

            index += 1
            index += 1 // right
            if let cell = itemsCollectionView.cellForItem(at: IndexPath(row: Int(index), section: 0)) {
                UIView.animate(withDuration: duration, delay: 0.0, options: [ .curveEaseOut], animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
                }, completion: nil)
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        lightImpactGenerator.impactOccurred()
        //page?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
}
import MarqueeLabel

class CartCollectionViewCellController: UICollectionViewCell {
    
    @IBOutlet weak var stepper: PKYStepper!
    @IBOutlet weak var itemName: MarqueeLabel!
    @IBOutlet weak var involved: MarqueeLabel!
    @IBOutlet weak var category: MarqueeLabel!
    @IBOutlet weak var type: MarqueeLabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    
    var produck:Product!
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        stepper.maximum = 1000
    }
    
    //14 didgits is a beat
    //13 didgits is a paid beat
    //12 digits is an instrumental
    //10 digits is a song
    //9 digits is a video
    //8 digits is an Album
    //6 digits is an artist
    //5 digits is a producer
    
    func funcSetTemp(product: Product, quantity: Int) {
        produck = product
        itemImage.layer.cornerRadius = 7
        stepper.setBorderColor(Constants.Colors.redApp)
        stepper.setLabelTextColor(.white)
        stepper.stepInterval = 1
        stepper.value = Float(quantity)
        stepper.countLabel.text = String(Int(stepper.value))
        stepper.minimum = 1
        stepper.setLabel(UIFont(name: "AvenirNextCondensed-DemiBold", size: 14)!)
        stepper.setButtonTextColor(Constants.Colors.redApp, for: .normal)
        stepper.hidesDecrementWhenMinimum = true
        stepper.hidesIncrementWhenMaximum = true
        var itemtype = ""
        let word = product.id.split(separator: "Æ")
        let id = word[0]
        switch id.count {
        case 13:
            itemtype = "BEAT"
            stepper.maximum = 1
        case 14:
            itemtype = "BEAT"
            stepper.maximum = 1
        case 12:
            itemtype = "INSTRUMENTAL"
            stepper.maximum = 1
        case 20:
            itemtype = "SERVICE"
            stepper.maximum = 1
        case 21:
            itemtype = "BUNDLE"
        case 22:
            itemtype = "KIT"
            stepper.maximum = 1
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
        category.text = " · \(itemtype)"
        itemName.text = "\(product.name)"
        price.text = product.price.dollarString
        var names:[String] = []
        for per in product.involved {
            let word = per.split(separator: "Æ")
            let id = word[1]
            names.append(String(id))
        }
        let imageurl = product.thumbnailURL
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.itemImage.image = cachedImage
                }
            } else {
                itemImage.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        involved.text = names.joined(separator: ", ")
        type.text = product.type
    }
}

extension CartCollectionViewCellController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }

        
        func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
            return "cartTableCellController"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50//Your custom row height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartcount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = userCart[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartTableCellController", for: indexPath) as! CartTableCellController
        cell.funcSetTemp(product: item.product, quantity: item.quantity)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.indexPathsForSelectedRows == nil || tableView.indexPathsForSelectedRows?.count == 0 {
            fakebar.leftButton.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: false)
        fakebar.leftButton.isHidden = false
        
    }
}

class CartTableCellController: UITableViewCell {
    @IBOutlet weak var quantity: MarqueeLabel!
    @IBOutlet weak var category: MarqueeLabel!
    @IBOutlet weak var itemName: MarqueeLabel!
    @IBOutlet weak var type: MarqueeLabel!
    @IBOutlet weak var itemImage: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
    
    func funcSetTemp(product:Product, quantity: Int) {
        itemImage.layer.cornerRadius = 5
        var itemtype = ""
        let word = product.id.split(separator: "Æ")
        let id = word[0]
        switch id.count {
        case 13:
            itemtype = "BEAT"
        case 14:
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
        type.text = " · \(product.type)"
        itemName.text = "\(product.name)"
        self.quantity.text = "Qty: \(quantity)"
        let imageurl = product.thumbnailURL
        if let url = URL.init(string: imageurl) {
            if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.itemImage.image = cachedImage
                }
            } else {
                itemImage.setImage(from: url, withPlaceholder: UIImage(named: "tonedeaflogo"))
            }
        }
        category.text = itemtype
    }
}

extension CartViewController: CartDelegate {

    func cart<T>(_ cart: Cart<T>, itemsDidChangeWithType type: CartItemChangeType) where T : ProductProtocol {

        switch type {
        case .add(at: let index):
            print("add")
//            let indexPath = IndexPath(row: index, section: 0)
//            tableView.insertRows(at: [indexPath], with: .automatic)

        case .increment(at: let index), .decrement(at: let index):
            print("inc")
//            let indexPath = IndexPath(row: index, section: 0)
//            let cell = tableView.cellForRow(at: indexPath) as! MyTableViewCell
//            cell.quantityLabel.text = String(items[index].quantity)

        case .delete(at: let index):
            print("delete")
//            let indexPath = IndexPath(row: index, section: 0)
//            tableView.deleteRows(at: [indexPath], with: .automatic)

        case .clean:
            print("clean")
//            if let all = tableView.indexPathsForVisibleRows {
//                tableView.deleteRows(at: all, with: .automatic)
//            }
        }
    }
}
