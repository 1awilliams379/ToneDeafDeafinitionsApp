//
//  ProductInfoViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 11/11/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import PKYStepper
import CollectionViewPagingLayout
import BEMCheckBox
import CDAlertView
import SideMenu

class ProductInfoViewController: UIViewController {

    @IBOutlet weak var scrollView1: UIScrollView!
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var imagesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imagePageControl: UIPageControl!
    @IBOutlet weak var smallImageCollectionView: UICollectionView!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var currentAvailableLabel: UILabel!
    @IBOutlet weak var availableCollectionView: UICollectionView!
    @IBOutlet weak var sizesLabel: UILabel!
    @IBOutlet weak var currentSizeLabel: UILabel!
    @IBOutlet weak var sizesView: UIView!
    @IBOutlet weak var sizesCollectionView: UICollectionView!
    @IBOutlet weak var merchName: UILabel!
    @IBOutlet weak var merchPrice: UILabel!
    @IBOutlet weak var merchPriceStack: UIView!
    @IBOutlet weak var merchSale: UILabel!
    @IBOutlet weak var merchSavingsLabel: UILabel!
    @IBOutlet weak var merchSavingsView: UIView!
    @IBOutlet weak var merchSaleStack: UIView!
    @IBOutlet weak var quantityStepper: PKYStepper!
    @IBOutlet weak var lowQuantityLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var productInfoLabel: UILabel!
    @IBOutlet weak var productDescription: UITextView!
    @IBOutlet weak var mightAlsoLikeCollectionView: UICollectionView!
    
    var recievedMerch:Any!
    var merchToGo:Any!
    
    var visualEffectView:UIVisualEffectView!
    var lastContentOffset: CGFloat = 0
    
    var productImages:[UIImage] = []
    var imagesCollectionView: UICollectionView!
    var colors:[UIColor]!
    var mightAlsoLikeArr:[MerchData] = []
    var selectedSize = ""
    var selectedColor:UIColor = .amethyst
    var availableSizes:[[String]] = [[],[],[],[],[],[],[],[],[]]
    var priceToPay:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPageDetails()
        setMightAlsoLike()
        setNavBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        if scrollView1.contentOffset.y <= 0 {
            if visualEffectView != nil {
                visualEffectView.removeFromSuperview()
            }
            visualEffectView = nil
        } else {
            if visualEffectView != nil {
                visualEffectView.removeFromSuperview()
                visualEffectView = nil
            }
            if visualEffectView == nil {
                visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
                visualEffectView.frame =  (navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -10).offsetBy(dx: 0, dy: -10))!
                navigationController?.navigationBar.addSubview(visualEffectView)
                navigationController?.navigationBar.sendSubviewToBack(visualEffectView)
                visualEffectView.layer.zPosition = -1;
                visualEffectView.isUserInteractionEnabled = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setNavBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setPageDetails() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        sizesView.isHidden = true
        scrollView1.delaysContentTouches = false
        imagesViewHeight.constant = view.frame.width
        addToCartButton.layer.cornerRadius = 7
        merchPriceStack.backgroundColor = .white
        merchSaleStack.isHidden = true
        merchSavingsView.isHidden = true
        quantityStepper.setBorderColor(Constants.Colors.redApp)
        quantityStepper.setLabelTextColor(.white)
        quantityStepper.stepInterval = 1
        quantityStepper.minimum = 1
        quantityStepper.setLabel(UIFont(name: "AvenirNextCondensed-DemiBold", size: 14)!)
        quantityStepper.setButtonTextColor(Constants.Colors.redApp, for: .normal)
        quantityStepper.hidesDecrementWhenMinimum = true
        quantityStepper.hidesIncrementWhenMaximum = true
        quantityStepper.value = 1
        quantityStepper.countLabel.text = String(1)
        quantityStepper.valueChangedCallback = {[weak self] _, count in
            guard let strongSelf = self else {return}
            strongSelf.quantityStepper.countLabel.text = "\(Int(count))"
          }
        productDescription.isScrollEnabled = false
        switch recievedMerch {
        case is MerchKitData:
            let kit = recievedMerch as! MerchKitData
            merchName.text = kit.name
            merchPrice.text = kit.retailPrice.dollarString
            priceToPay = kit.retailPrice*Double(quantityStepper.countLabel.text!)!
            availableLabel.text = "Available Files"
            availableCollectionView.delegate = self
            availableCollectionView.dataSource = self
            if let sp = kit.salePrice {
                merchSavingsView.isHidden = false
                merchSaleStack.isHidden = false
                merchSale.text = (kit.retailPrice-(kit.retailPrice*sp)).dollarString
                priceToPay = (kit.retailPrice-(kit.retailPrice*sp))*Double(quantityStepper.countLabel.text!)!
                merchPrice.alpha = 0.7
                let attributedString = NSMutableAttributedString(string: kit.retailPrice.dollarString)
                attributedString.addAttribute(NSAttributedString.Key.baselineOffset, value: 0, range: NSMakeRange(0, attributedString.length))
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.thick.rawValue), range: NSMakeRange(0, attributedString.length))
                attributedString.addAttribute(NSAttributedString.Key.strikethroughColor, value: Constants.Colors.redApp, range: NSMakeRange(0, attributedString.length))
                merchPrice.attributedText = attributedString
                merchPriceStack.backgroundColor = .gray
                merchSavingsLabel.text = "You save \((kit.retailPrice*sp).dollarString) (\((sp*100).rounded())%)"
            }
            if let quan = kit.quantity {
                quantityStepper.maximum = Float(quan)
            } else {
                quantityStepper.maximum = 1
            }
            productDescription.text = kit.description
            var tick = 0
            for img in kit.imageURLs {
                URL(string: img)!.getImage(completion: {[weak self] image in
                    guard let strongSelf = self else {return}
                        strongSelf.productImages.append(image)
                    tick+=1
                    if tick == kit.imageURLs.count {
                        strongSelf.setupImagesCollectionView()
                        strongSelf.imagePageControl.numberOfPages = strongSelf.productImages.count
                    }
                })
            }
        case is MerchApperalData:
            let apperal = recievedMerch as! MerchApperalData
            merchName.text = apperal.name
            let lp = GlobalFunctions.shared.getLowestPrice(apperal: apperal)
            merchPrice.text = "From \(lp.dollarString)"
            priceToPay = lp*Double(quantityStepper.countLabel.text!)!
            setColors(apperal: apperal)
            sizesCollectionView.delaysContentTouches = false
            sizesCollectionView.delegate = self
            sizesCollectionView.dataSource = self
            sizesCollectionView.reloadData()
            sizesView.isHidden = false
            var tick = 0
            for img in apperal.imageURLs {
                URL(string: img)!.getImage(completion: {[weak self] image in
                    guard let strongSelf = self else {return}
                        strongSelf.productImages.append(image)
                    tick+=1
                    if tick == apperal.imageURLs.count {
                        strongSelf.setupImagesCollectionView()
                        strongSelf.imagePageControl.numberOfPages = strongSelf.productImages.count
                    }
                })
            }
        case is MerchServiceData:
            let service = recievedMerch as! MerchServiceData
            merchName.text = service.name
            if let vprice = service.retailPrice {
                merchPrice.text = vprice.dollarString
            } else {
                priceToPay = 0.0*Double(quantityStepper.countLabel.text!)!
            }
            quantityStepper.maximum = 1
            productDescription.text = service.description
            let image = UIImage(named: "lego")!
            productImages.append(image)
            setupImagesCollectionView()
            imagePageControl.numberOfPages = 1
        case is MerchMemorabiliaData:
            let memorabilia = recievedMerch as! MerchMemorabiliaData
            merchName.text = memorabilia.name
            let lp = GlobalFunctions.shared.getLowestPrice(memorabilia: memorabilia)
            merchPrice.text = "From \(lp.dollarString)"
            priceToPay = lp*Double(quantityStepper.countLabel.text!)!
            setColors(memorabilia: memorabilia)
            colors = GlobalFunctions.shared.getAvailableColors(memorabilia: memorabilia)
            var tick = 0
            for img in memorabilia.imageURLs {
                URL(string: img)!.getImage(completion: {[weak self] image in
                    guard let strongSelf = self else {return}
                        strongSelf.productImages.append(image)
                    tick+=1
                    if tick == memorabilia.imageURLs.count {
                        strongSelf.setupImagesCollectionView()
                        strongSelf.imagePageControl.numberOfPages = strongSelf.productImages.count
                    }
                })
            }
        case is MerchInstrumentalData:
            let instr = recievedMerch as! MerchInstrumentalData
            merchPrice.text = instr.retailPrice?.dollarString
            priceToPay = instr.retailPrice!*Double(quantityStepper.countLabel.text!)!
            if let quan = instr.quantity {
                quantityStepper.maximum = Float(quan)
            } else {
                quantityStepper.maximum = 1
            }
            availableLabel.text = "Available Files"
            availableCollectionView.delegate = self
            availableCollectionView.dataSource = self
            let word = instr.instrumentaldbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let instrumental):
                    strongSelf.merchName.text = instrumental.instrumentalName
                    URL(string: "")!.getImage(completion: {[weak self] image in
                        guard let strongSelf = self else {return}
                        strongSelf.productImages.append(image)
                        strongSelf.setupImagesCollectionView()
                        strongSelf.imagePageControl.numberOfPages = strongSelf.productImages.count
                    })
                    strongSelf.productDescription.text = instrumental.instrumentalName
                case.failure(let err):
                    print("kjhfdgxfgchjk bi \(err)")
                }
            })
        default:
            print("whoops")
        }
    }
    
    func setColors(apperal: MerchApperalData) {
        colors = GlobalFunctions.shared.getAvailableColors(apperal: apperal)
        availableLabel.text = "Available Colors"
        var daColor:String!
        var data:(Double,Double?,Int,String)!
        if let sizes = apperal.osfaSize {
            var arr:[String] = []
            for sz in sizes {
                if sz.quantity != 0 {
                    arr.append(sz.color)
                    if selectedSize == "" {
                        selectedSize = sz.size
                        if selectedColor == UIColor.amethyst {
                            selectedColor = colorForString(string: sz.color)
                            data = apperalSizeDetails(size: selectedSize, color: sz.color)
                            daColor = sz.color
                        }
                    }
                }
            }
            availableSizes[0] = arr
        }
        if let sizes = apperal.xxsmallSize {
            var arr:[String] = []
            for sz in sizes {
                if sz.quantity != 0 {
                    arr.append(sz.color)
                    if selectedSize == "" {
                        selectedSize = sz.size
                        if selectedColor == UIColor.amethyst {
                            selectedColor = colorForString(string: sz.color)
                            data = apperalSizeDetails(size: selectedSize, color: sz.color)
                            daColor = sz.color
                        }
                    }
                }
            }
            availableSizes[1] = arr
        }
        if let sizes = apperal.xsmallSize {
            var arr:[String] = []
            for sz in sizes {
                if sz.quantity != 0 {
                    arr.append(sz.color)
                    if selectedSize == "" {
                        selectedSize = sz.size
                        if selectedColor == UIColor.amethyst {
                            selectedColor = colorForString(string: sz.color)
                            data = apperalSizeDetails(size: selectedSize, color: sz.color)
                            daColor = sz.color
                        }
                    }
                }
            }
            availableSizes[2] = arr
        }
        if let sizes = apperal.smallSize {
            var arr:[String] = []
            for sz in sizes {
                if sz.quantity != 0 {
                    arr.append(sz.color)
                    if selectedSize == "" {
                        selectedSize = sz.size
                        if selectedColor == UIColor.amethyst {
                            selectedColor = colorForString(string: sz.color)
                            data = apperalSizeDetails(size: selectedSize, color: sz.color)
                            daColor = sz.color
                        }
                    }
                }
            }
            availableSizes[3] = arr
        }
        if let sizes = apperal.mediumSize {
            var arr:[String] = []
            for sz in sizes {
                if sz.quantity != 0 {
                    arr.append(sz.color)
                    if selectedSize == "" {
                        selectedSize = sz.size
                        if selectedColor == UIColor.amethyst {
                            selectedColor = colorForString(string: sz.color)
                            data = apperalSizeDetails(size: selectedSize, color: sz.color)
                            daColor = sz.color
                        }
                    }
                }
            }
            availableSizes[4] = arr
        }
        if let sizes = apperal.largeSize {
            var arr:[String] = []
            for sz in sizes {
                if sz.quantity != 0 {
                    arr.append(sz.color)
                    if selectedSize == "" {
                        selectedSize = sz.size
                        if selectedColor == UIColor.amethyst {
                            selectedColor = colorForString(string: sz.color)
                            data = apperalSizeDetails(size: selectedSize, color: sz.color)
                            daColor = sz.color
                        }
                    }
                }
            }
            availableSizes[5] = arr
        }
        if let sizes = apperal.xlargeSize {
            var arr:[String] = []
            for sz in sizes {
                if sz.quantity != 0 {
                    arr.append(sz.color)
                    if selectedSize == "" {
                        selectedSize = sz.size
                        if selectedColor == UIColor.amethyst {
                            selectedColor = colorForString(string: sz.color)
                            data = apperalSizeDetails(size: selectedSize, color: sz.color)
                            daColor = sz.color
                        }
                    }
                }
            }
            availableSizes[6] = arr
        }
        if let sizes = apperal.xxlargeSize {
            var arr:[String] = []
            for sz in sizes {
                if sz.quantity != 0 {
                    arr.append(sz.color)
                    if selectedSize == "" {
                        selectedSize = sz.size
                        if selectedColor == UIColor.amethyst {
                            selectedColor = colorForString(string: sz.color)
                            data = apperalSizeDetails(size: selectedSize, color: sz.color)
                            daColor = sz.color
                        }
                    }
                }
            }
            availableSizes[7] = arr
        }
        if let sizes = apperal.xxxlargeSize {
            var arr:[String] = []
            for sz in sizes {
                if sz.quantity != 0 {
                    arr.append(sz.color)
                    if selectedSize == "" {
                        selectedSize = sz.size
                        if selectedColor == UIColor.amethyst {
                            selectedColor = colorForString(string: sz.color)
                            data = apperalSizeDetails(size: selectedSize, color: sz.color)
                            daColor = sz.color
                        }
                    }
                }
            }
            availableSizes[8] = arr
        }
        merchPrice.text = data.0.dollarString
        if let sale = data.1 {
            merchSale.text = sale.dollarString
        }
        if data.2 < 5 {
            lowQuantityLabel.text = "Only \(data.2) left"
            lowQuantityLabel.tintColor = Constants.Colors.redApp
            quantityStepper.maximum = Float(data.2)
            quantityStepper.countLabel.text = String(1)
        } else {
            lowQuantityLabel.text = "In Stock"
            lowQuantityLabel.tintColor = .green
            quantityStepper.maximum = Float(data.2)
            quantityStepper.countLabel.text = String(1)
        }
        productDescription.text = data.3
        currentSizeLabel.text = "Size: \(selectedSize)"
        currentAvailableLabel.text = "Color: \(daColor!)"
        availableCollectionView.delegate = self
        availableCollectionView.dataSource = self
        availableCollectionView.reloadData()
        view.layoutSubviews()
    }
    
    func setColors(memorabilia: MerchMemorabiliaData) {
        colors = GlobalFunctions.shared.getAvailableColors(memorabilia: memorabilia)
        availableLabel.text = "Available Colors"
        var daColor:String!
        var data:(Double,Double?,Int,String)!
        if let colors = memorabilia.colors {
            var arr:[String] = []
            for co in colors {
                if co.quantity != 0 {
                    arr.append(co.color)
                    if selectedColor == UIColor.amethyst {
                        selectedColor = colorForString(string: co.color)
                        data = (co.retailPrice, co.salePrice, co.quantity, co.description)
                        daColor = co.color
                    }
                }
            }
        }
        
        merchPrice.text = data.0.dollarString
        if let sale = data.1 {
            merchSale.text = sale.dollarString
        }
        if data.2 < 5 {
            lowQuantityLabel.text = "Only \(data.2) left"
            lowQuantityLabel.tintColor = Constants.Colors.redApp
            quantityStepper.maximum = Float(data.2)
            quantityStepper.countLabel.text = String(1)
        } else {
            lowQuantityLabel.text = "In Stock"
            lowQuantityLabel.tintColor = .green
            quantityStepper.maximum = Float(data.2)
            quantityStepper.countLabel.text = String(1)
        }
        productDescription.text = data.3
        currentAvailableLabel.text = "Color: \(daColor!)"
        availableCollectionView.delegate = self
        availableCollectionView.dataSource = self
        availableCollectionView.reloadData()
        view.layoutSubviews()
    }
    
    private func setupImagesCollectionView() {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.smallImageCollectionView.delaysContentTouches = false
            strongSelf.smallImageCollectionView.delegate = self
            strongSelf.smallImageCollectionView.dataSource = self
            strongSelf.smallImageCollectionView.reloadData()
            strongSelf.imagesCollectionView = UICollectionView(
                frame: strongSelf.imagesView.frame,
                collectionViewLayout: CollectionViewPagingLayout()
            )
            let layout = CollectionViewPagingLayout()
            strongSelf.imagesCollectionView.collectionViewLayout = layout
            layout.delegate = self
            strongSelf.imagesCollectionView.showsHorizontalScrollIndicator = false
            strongSelf.imagesCollectionView.isPagingEnabled = true
            strongSelf.imagesCollectionView.backgroundColor = .clear
            strongSelf.imagesCollectionView.register(ProductImageCollectionViewCell.self, forCellWithReuseIdentifier: "productImageCollectionViewCell")
            strongSelf.imagesCollectionView.dataSource = self
            strongSelf.imagesView.addSubview(strongSelf.imagesCollectionView)
            strongSelf.imagesCollectionView.delaysContentTouches = false
            strongSelf.imagesCollectionView.reloadSections(IndexSet(integer: 0))
            strongSelf.view.layoutSubviews()
        }
    }
    
    func setMightAlsoLike() {
        DatabaseManager.shared.fetchAllMerch(completion: {[weak self] merch in
            guard let strongSelf = self else {return}
            var shuff = merch
            shuff.shuffle()
            for i in 0..<shuff.count-1 {
                switch strongSelf.recievedMerch {
                case is MerchKitData:
                    if shuff[i].kit == (strongSelf.recievedMerch as! MerchKitData) {
                        shuff.remove(at: i)
                        break
                    }
                case is MerchApperalData:
                    if shuff[i].apperal == (strongSelf.recievedMerch as! MerchApperalData) {
                        shuff.remove(at: i)
                        break
                    }
                case is MerchServiceData:
                    if shuff[i].service == (strongSelf.recievedMerch as! MerchServiceData) {
                        shuff.remove(at: i)
                        break
                    }
                case is MerchMemorabiliaData:
                    if shuff[i].memorabilia == (strongSelf.recievedMerch as! MerchMemorabiliaData) {
                        shuff.remove(at: i)
                        break
                    }
                case is MerchInstrumentalData:
                    if shuff[i].instrumentalSale == (strongSelf.recievedMerch as! MerchInstrumentalData) {
                        shuff.remove(at: i)
                        break
                    }
                default:
                    print("hgfd")
                }
            }
            strongSelf.mightAlsoLikeArr = shuff
            strongSelf.mightAlsoLikeCollectionView.delaysContentTouches = false
            strongSelf.mightAlsoLikeCollectionView.delegate = self
            strongSelf.mightAlsoLikeCollectionView.dataSource = self
            strongSelf.mightAlsoLikeCollectionView.reloadData()
            strongSelf.view.layoutSubviews()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "productToProduct" {
            if let viewController: ProductInfoViewController = segue.destination as? ProductInfoViewController {
                viewController.recievedMerch = merchToGo
            }
        }
    }
    
    func stringForColor(color: UIColor) -> String {
        var daColor:String!
        switch color {
        case .alizarin:
            daColor = "Multi-Color"
        case .black:
            daColor = "Black"
        case .white:
            daColor = "White"
        case Constants.Colors.mediumApp:
            daColor = "Charcoal"
        case .darkGray:
            daColor = "Dark Gray"
        case .lightGray:
            daColor = "Light Gray"
        case .blue:
            daColor = "Blue"
        case .midnightBlue:
            daColor = "Navy"
        case .cyan:
            daColor = "Light Blue"
        case .red:
            daColor = "Red"
        case UIColor(red: 191/255, green: 0/255, blue: 0/255, alpha: 1.0):
            daColor = "Maroon"
        case .yellow:
            daColor = "Yellow"
        case .orange:
            daColor = "Orange"
        case .green:
            daColor = "Green"
        case UIColor(red: 71/255, green: 104/255, blue: 0/255, alpha: 1.0):
            daColor = "Olive"
        case .systemPink:
            daColor = "Pink"
        case .brown:
            daColor = "Brown"
        case UIColor(red: 175/255, green: 139/255, blue: 61/255, alpha: 1.0):
            daColor = "Tan"
        case UIColor(red: 201/255, green: 184/255, blue: 145/255, alpha: 1.0):
            daColor = "Cream"
        default:
            daColor = ""
            print("err")
        }
        return daColor
    }
    
    func colorForString(string: String) -> UIColor {
        var daColor:UIColor = .amethyst
        switch string {
        case "Multi-Color":
            daColor = .alizarin
        case "Black":
            daColor = .black
        case "White":
            daColor = .white
        case "Charcoal":
            daColor = Constants.Colors.mediumApp
        case "Dark Gray":
            daColor = .darkGray
        case "Light Gray":
            daColor = .lightGray
        case "Blue":
            daColor = .blue
        case "Navy":
            daColor = .midnightBlue
        case "Light Blue":
            daColor = .cyan
        case "Red":
            daColor = .red
        case "Maroon":
            daColor = UIColor(red: 191/255, green: 0/255, blue: 0/255, alpha: 1.0)
        case "Yellow":
            daColor = .yellow
        case "Orange":
            daColor = .orange
        case "Green":
            daColor = .green
        case "Olive":
            daColor = UIColor(red: 71/255, green: 104/255, blue: 0/255, alpha: 1.0)
        case "Pink":
            daColor = .systemPink
        case "Brown":
            daColor = .brown
        case "Tan":
            daColor = UIColor(red: 175/255, green: 139/255, blue: 61/255, alpha: 1.0)
        case "Cream":
            daColor = UIColor(red: 201/255, green: 184/255, blue: 145/255, alpha: 1.0)
        default:
            print("err")
        }
        return daColor
    }
    
    func apperalSizeDetails(size: String, color:String) -> (Double,Double?,Int,String) {
        let apperal = recievedMerch as! MerchApperalData
        var price:Double!
        var sale:Double!
        var quantity:Int!
        var description:String!
        switch size {
        case "OSFA":
            if let sz = apperal.osfaSize {
                for col in sz {
                    if col.color == color {
                        price = col.retailPrice
                        sale = col.salePrice
                        quantity = col.quantity
                        description = col.description
                    }
                }
            } else {
                print("handle Error")
            }
        case "XXS":
            if let sz = apperal.xxsmallSize {
                for col in sz {
                    if col.color == color {
                        price = col.retailPrice
                        sale = col.salePrice
                        quantity = col.quantity
                        description = col.description
                    }
                }
            } else {
                print("handle Error")
            }
        case "XS":
            if let sz = apperal.xsmallSize {
                for col in sz {
                    if col.color == color {
                        price = col.retailPrice
                        sale = col.salePrice
                        quantity = col.quantity
                        description = col.description
                    }
                }
            } else {
                print("handle Error")
            }
        case "S":
            if let sz = apperal.smallSize {
                for col in sz {
                    if col.color == color {
                        price = col.retailPrice
                        sale = col.salePrice
                        quantity = col.quantity
                        description = col.description
                    }
                }
            } else {
                print("handle Error")
            }
        case "M":
            if let sz = apperal.mediumSize {
                for col in sz {
                    if col.color == color {
                        price = col.retailPrice
                        sale = col.salePrice
                        quantity = col.quantity
                        description = col.description
                    }
                }
            } else {
                print("handle Error")
            }
        case "L":
            if let sz = apperal.largeSize {
                for col in sz {
                    if col.color == color {
                        price = col.retailPrice
                        sale = col.salePrice
                        quantity = col.quantity
                        description = col.description
                    }
                }
            } else {
                print("handle Error")
            }
        case "XL":
            if let sz = apperal.xlargeSize {
                for col in sz {
                    if col.color == color {
                        price = col.retailPrice
                        sale = col.salePrice
                        quantity = col.quantity
                        description = col.description
                    }
                }
            } else {
                print("handle Error")
            }
        case "XXL":
            if let sz = apperal.xxlargeSize {
                for col in sz {
                    if col.color == color {
                        price = col.retailPrice
                        sale = col.salePrice
                        quantity = col.quantity
                        description = col.description
                    }
                }
            } else {
                print("handle Error")
            }
        case "XXXL":
            if let sz = apperal.xxxlargeSize {
                for col in sz {
                    if col.color == color {
                        price = col.retailPrice
                        quantity = col.quantity
                        description = col.description
                    }
                }
            } else {
                print("handle Error")
            }
        default:
            print("you trippin tone")
        }
        return (price,sale,quantity,description)
    }
    
    @IBAction func addToCartTapped(_ sender: Any) {
        let product = Product(id: "", dbid: "", name: merchName.text!, price: priceToPay, thumbnailURL: "", type: "", involved: [])
        var alerticon:UIImage!
        var involed:[String] = []
        switch recievedMerch {
        case is MerchKitData:
            let merch = recievedMerch as! MerchKitData
            alerticon = UIImage(named: "zip-file")!.withTintColor(.white)
            product.id = "\(merch.tDAppId)Æ\(merch.name)Ækit"
            product.dbid = "\(merch.tDAppId)Æ\(merch.name)"
            product.thumbnailURL = merch.imageURLs[0]
            product.type = merch.subcategory
            if let arr = merch.artists {
                involed.append(contentsOf: arr)
            }
            if let arr = merch.producers {
                involed.append(contentsOf: arr)
            }
        case is MerchApperalData:
            let merch = recievedMerch as! MerchApperalData
            alerticon = UIImage(named: "shirt")!.withTintColor(.white)
            product.id = "\(merch.tDAppId)Æ\(merch.name)Æapperal"
            product.dbid = "\(merch.tDAppId)Æ\(merch.name)"
            product.thumbnailURL = merch.imageURLs[0]
            product.type = "\(merch.subcategory) • \(selectedSize) • \(stringForColor(color: selectedColor))"
            if let arr = merch.artists {
                involed.append(contentsOf: arr)
            }
            if let arr = merch.producers {
                involed.append(contentsOf: arr)
            }
        case is MerchServiceData:
            let merch = recievedMerch as! MerchServiceData
            alerticon = UIImage(named: "clipboard-list")!.withTintColor(.white)
            product.id = "\(merch.tDAppId)Æ\(merch.name)Ækit"
            product.dbid = "\(merch.tDAppId)Æ\(merch.name)"
            product.type = "Service"
            if let arr = merch.producers {
                involed.append(contentsOf: arr)
            }
        case is MerchMemorabiliaData:
            let merch = recievedMerch as! MerchMemorabiliaData
            alerticon = UIImage(named: "award")!.withTintColor(.white)
            product.id = "\(merch.tDAppId)Æ\(merch.name)Ækit"
            product.dbid = "\(merch.tDAppId)Æ\(merch.name)"
            product.thumbnailURL = merch.imageURLs[0]
            product.type = "\(merch.subcategory) • \(stringForColor(color: selectedColor))"
            if let arr = merch.artists {
                involed.append(contentsOf: arr)
            }
            if let arr = merch.producers {
                involed.append(contentsOf: arr)
            }
        case is MerchInstrumentalData:
            let merch = recievedMerch as! MerchInstrumentalData
            alerticon = UIImage(named: "mp3-file")!.withTintColor(.white)
            product.dbid = "\(merch.instrumentaldbid)"
            let word = merch.instrumentaldbid.split(separator: "Æ")
            let id = String(word[0])
            DatabaseManager.shared.findInstrumentalById(instrumentalId: id, completion: {[weak self] result in
                guard let strongSelf = self else {return}
                switch result {
                case.success(let instrumental):
                    product.id = "\(instrumental.toneDeafAppId)Æ\(instrumental.instrumentalName)Æinstrumental"
                    product.thumbnailURL = "instrumental.imageURL"
                    product.type = "Instrumental Lease"
                    involed.append(contentsOf: instrumental.artist!)
                    involed.append(contentsOf: instrumental.producers)
                    product.involved = involed
                case.failure(let err):
                    print("kjhfdgxfgchjk bi \(err)")
                }
            })
        default:
            print("nuller")
        }
        product.involved = involed
        let actionSheet = CDAlertView(title: "Add \"\(merchName.text!)\" to Cart?", message: "Quantity: \(quantityStepper.countLabel.text!)", type: .custom(image: alerticon))
        actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
        actionSheet.circleFillColor = .black
        actionSheet.titleTextColor = .white
        actionSheet.messageTextColor = .white
        let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
        actionSheet.add(action: cancel)
        actionSheet.add(action: CDAlertViewAction(title: "Add", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {[weak self]_ in
            guard let strongSelf = self else {return false}
            userCart.add(product, quantity: Int(strongSelf.quantityStepper.countLabel.text!)!)
            return true
        }))
        NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
    }
    
    @IBAction func profileTapped(_ sender: Any) {
        SideMenuManager.default.rightMenuNavigationController = profileSideMenu
        profileSideMenu.presentationStyle = .viewSlideOutMenuIn
        //profileSideMenu.setNavigationBarHidden(true, animated: false)
        present(profileSideMenu, animated: true, completion: nil)
    }
    
    @IBAction func cartTapped(_ sender: Any) {
        NotificationCenter.default.post(name: OpenTheCartNotify, object: nil)
    }
}

extension ProductInfoViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                //Scrolled to bottom
                if !(scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= -50) {
                    
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        guard let strongSelf = self else {return}
                        if strongSelf.visualEffectView == nil {
                            strongSelf.visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
                            strongSelf.visualEffectView.frame =  (strongSelf.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -10).offsetBy(dx: 0, dy: -10))!
                            strongSelf.navigationController?.navigationBar.addSubview(strongSelf.visualEffectView)
                            strongSelf.navigationController?.navigationBar.sendSubviewToBack(strongSelf.visualEffectView)
                            strongSelf.visualEffectView.layer.zPosition = -1;
                            strongSelf.visualEffectView.isUserInteractionEnabled = false
                        }
                        strongSelf.view.layoutIfNeeded()
                    }
                }
            }
            else if (scrollView.contentOffset.y < self.lastContentOffset || scrollView.contentOffset.y <= -50)// && (self.heightConstraint.constant != self.maxHeaderHeight)
            {
                //Scrolling up, scrolled to top
                //print(scrollView.contentOffset.y)
                
                UIView.animate(withDuration: 0.2) { [weak self] in
                    guard let strongSelf = self else {return}
                    //print(strongSelf.lastContentOffset)
                    if scrollView.contentOffset.y <= -50 {
                        if strongSelf.visualEffectView != nil {
                            strongSelf.visualEffectView.removeFromSuperview()
                            strongSelf.visualEffectView = nil
                            strongSelf.view.layoutIfNeeded()
                        }
                    }
                }
            }
            else if (scrollView.contentOffset.y > lastContentOffset)// && heightConstraint.constant != 0
            {
                //Scrolling down
                if !(scrollView.contentOffset.y < lastContentOffset || scrollView.contentOffset.y <= -50) {
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        guard let strongSelf = self else {return}
                        //print(strongSelf.lastContentOffset)
                        if strongSelf.visualEffectView == nil {
                            strongSelf.visualEffectView   = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
                            strongSelf.visualEffectView.frame =  (strongSelf.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -10).offsetBy(dx: 0, dy: -10))!
                            strongSelf.navigationController?.navigationBar.addSubview(strongSelf.visualEffectView)
                            strongSelf.navigationController?.navigationBar.sendSubviewToBack(strongSelf.visualEffectView)
                            strongSelf.visualEffectView.layer.zPosition = -1;
                            strongSelf.visualEffectView.isUserInteractionEnabled = false
                        }
                        strongSelf.view.layoutIfNeeded()
                    }
                }
            }
            self.lastContentOffset = scrollView.contentOffset.y
        
    }
}

extension ProductInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource, CollectionViewPagingLayoutDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mightAlsoLikeCollectionView:
            if mightAlsoLikeArr.count>14 {
                return 15
            } else {
                return mightAlsoLikeArr.count
            }
        case sizesCollectionView:
            return sizelist.count
        case availableCollectionView:
            switch recievedMerch {
            case is MerchKitData:
                return 1
            case is MerchApperalData:
                return colors.count
            case is MerchServiceData:
                return 1
            case is MerchMemorabiliaData:
                return colors.count
            case is MerchInstrumentalData:
                return 1
            default:
                return 0
            }
        default:
            return productImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case mightAlsoLikeCollectionView:
            let merch = mightAlsoLikeArr[indexPath.item]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentCollectionCell", for: indexPath) as! MerchContentCollectionCell
            cell.funcSetUp(latestMerch: merch)
            return cell
        case sizesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productSizeSelectCollectionViewCell", for: indexPath) as! ProductSizeSelectCollectionViewCell
            cell.size.text = sizelist[indexPath.item]
            cell.box.isUserInteractionEnabled = false
            var daColor:String!
            switch selectedColor {
            case .alizarin:
                daColor = "Multi-Color"
            case .black:
                daColor = "Black"
            case .white:
                daColor = "White"
            case Constants.Colors.mediumApp:
                daColor = "Charcoal"
            case .darkGray:
                daColor = "Dark Gray"
            case .lightGray:
                daColor = "Light Gray"
            case .blue:
                daColor = "Blue"
            case .midnightBlue:
                daColor = "Navy"
            case .cyan:
                daColor = "Light Blue"
            case .red:
                daColor = "Red"
            case UIColor(red: 191/255, green: 0/255, blue: 0/255, alpha: 1.0):
                daColor = "Maroon"
            case .yellow:
                daColor = "Yellow"
            case .orange:
                daColor = "Orange"
            case .green:
                daColor = "Green"
            case UIColor(red: 71/255, green: 104/255, blue: 0/255, alpha: 1.0):
                daColor = "Olive"
            case .systemPink:
                daColor = "Pink"
            case .brown:
                daColor = "Brown"
            case UIColor(red: 175/255, green: 139/255, blue: 61/255, alpha: 1.0):
                daColor = "Tan"
            case UIColor(red: 201/255, green: 184/255, blue: 145/255, alpha: 1.0):
                daColor = "Cream"
            default:
                daColor = ""
                print("err")
            }
            if availableSizes[indexPath.item].isEmpty || !availableSizes[indexPath.item].contains(daColor) {
                cell.isUserInteractionEnabled = false
                cell.box.tintColor = .darkGray
                cell.size.alpha = 0.6
            }
            else {
                cell.isUserInteractionEnabled = true
                cell.box.tintColor = .white
                cell.size.alpha = 1
                if sizelist[indexPath.item] == selectedSize {
                    cell.box.on = true
                } else {
                    cell.box.on = false
                }
            }
            return cell
        case smallImageCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallImageCollectionViewCell", for: indexPath) as! SmallImageCollectionViewCell
            let imgv = UIImageView(frame: cell.contentView.frame)
            imgv.image = productImages[indexPath.row]
            imgv.layer.cornerRadius = 7
            cell.contentView.addSubview(imgv)
            return cell
        case imagesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImageCollectionViewCell", for: indexPath) as! ProductImageCollectionViewCell
            if !productImages.isEmpty {
                let image = productImages[indexPath.row]
                cell.card.image = image
                cell.card.layer.cornerRadius = 7
            }
            return cell
        case availableCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "merchContentAccessoryCollectionCell", for: indexPath) as! MerchContentAccessoryCollectionCell
            cell.img.layer.cornerRadius = 12.5
            cell.img.layer.borderWidth = 1
            cell.img.tintColor = .white
            cell.img.contentMode = .scaleAspectFit
            cell.img.layer.borderColor = UIColor.white.cgColor
            switch recievedMerch {
            case is MerchKitData:
                cell.img.layer.cornerRadius = 0
                cell.img.layer.borderWidth = 0
                cell.img.backgroundColor = .clear
                cell.img.image = UIImage(named: "zip-file")!.withTintColor(.white)
            case is MerchApperalData:
                cell.img.backgroundColor = colors[indexPath.item]
                if colors[indexPath.item] == selectedColor {
                    cell.img.layer.borderColor = Constants.Colors.redApp.cgColor
                } else {
                    cell.img.layer.borderColor = UIColor.white.cgColor
                }
            case is MerchServiceData:
                cell.img.layer.cornerRadius = 0
                cell.img.layer.borderWidth = 0
                cell.img.backgroundColor = .clear
                cell.img.image = UIImage(systemName: "31.circle.fill")!
            case is MerchMemorabiliaData:
                cell.img.backgroundColor = colors[indexPath.item]
                if colors[indexPath.item] == selectedColor {
                    cell.img.layer.borderColor = Constants.Colors.redApp.cgColor
                } else {
                    cell.img.layer.borderColor = UIColor.white.cgColor
                }
            case is MerchInstrumentalData:
                cell.img.layer.cornerRadius = 0
                cell.img.layer.borderWidth = 0
                cell.img.backgroundColor = .clear
                cell.img.image = UIImage(named: "mp3-file")!.withTintColor(.white)
            default:
                print("njbnj")
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionViewPagingLayout(_ layout: CollectionViewPagingLayout, didSelectItemAt indexPath: IndexPath) {
        layout.collectionView!.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case availableCollectionView:
            switch recievedMerch {
//            case is MerchKitData
            case is MerchApperalData:
                selectedColor = colors[indexPath.item]
                var daColor:String!
                switch selectedColor {
                case .alizarin:
                    daColor = "Multi-Color"
                case .black:
                    daColor = "Black"
                case .white:
                    daColor = "White"
                case Constants.Colors.mediumApp:
                    daColor = "Charcoal"
                case .darkGray:
                    daColor = "Dark Gray"
                case .lightGray:
                    daColor = "Light Gray"
                case .blue:
                    daColor = "Blue"
                case .midnightBlue:
                    daColor = "Navy"
                case .cyan:
                    daColor = "Light Blue"
                case .red:
                    daColor = "Red"
                case UIColor(red: 191/255, green: 0/255, blue: 0/255, alpha: 1.0):
                    daColor = "Maroon"
                case .yellow:
                    daColor = "Yellow"
                case .orange:
                    daColor = "Orange"
                case .green:
                    daColor = "Green"
                case UIColor(red: 71/255, green: 104/255, blue: 0/255, alpha: 1.0):
                    daColor = "Olive"
                case .systemPink:
                    daColor = "Pink"
                case .brown:
                    daColor = "Brown"
                case UIColor(red: 175/255, green: 139/255, blue: 61/255, alpha: 1.0):
                    daColor = "Tan"
                case UIColor(red: 201/255, green: 184/255, blue: 145/255, alpha: 1.0):
                    daColor = "Cream"
                default:
                    print("err")
                }
                selectedSize = ""
                for i in 0..<availableSizes.count {
                    if availableSizes[i].contains(daColor) {
                        if selectedSize == "" {
                            selectedSize = sizelist[i]
                            break
                        }
                    }
                }
                let data = apperalSizeDetails(size: selectedSize, color: daColor)
                merchPrice.text = data.0.dollarString
                priceToPay = data.0*Double(quantityStepper.countLabel.text!)!
                if let sale = data.1 {
                    merchSale.text = sale.dollarString
                    priceToPay = sale*Double(quantityStepper.countLabel.text!)!
                }
                if data.2 < 5 {
                    lowQuantityLabel.text = "Only \(data.2) left"
                    lowQuantityLabel.tintColor = Constants.Colors.redApp
                    quantityStepper.maximum = Float(data.2)
                } else {
                    lowQuantityLabel.text = "In Stock"
                    lowQuantityLabel.tintColor = .green
                    quantityStepper.maximum = Float(data.2)
                }
                productDescription.text = data.3
                currentSizeLabel.text = "Size: \(selectedSize)"
                currentAvailableLabel.text = "Color: \(daColor!)"
                availableCollectionView.reloadData()
                sizesCollectionView.reloadData()
                view.layoutSubviews()
//            case is MerchServiceData:
//
            case is MerchMemorabiliaData:
                selectedColor = colors[indexPath.item]
                var daColor:String!
                switch selectedColor {
                case .alizarin:
                    daColor = "Multi-Color"
                case .black:
                    daColor = "Black"
                case .white:
                    daColor = "White"
                case Constants.Colors.mediumApp:
                    daColor = "Charcoal"
                case .darkGray:
                    daColor = "Dark Gray"
                case .lightGray:
                    daColor = "Light Gray"
                case .blue:
                    daColor = "Blue"
                case .midnightBlue:
                    daColor = "Navy"
                case .cyan:
                    daColor = "Light Blue"
                case .red:
                    daColor = "Red"
                case UIColor(red: 191/255, green: 0/255, blue: 0/255, alpha: 1.0):
                    daColor = "Maroon"
                case .yellow:
                    daColor = "Yellow"
                case .orange:
                    daColor = "Orange"
                case .green:
                    daColor = "Green"
                case UIColor(red: 71/255, green: 104/255, blue: 0/255, alpha: 1.0):
                    daColor = "Olive"
                case .systemPink:
                    daColor = "Pink"
                case .brown:
                    daColor = "Brown"
                case UIColor(red: 175/255, green: 139/255, blue: 61/255, alpha: 1.0):
                    daColor = "Tan"
                case UIColor(red: 201/255, green: 184/255, blue: 145/255, alpha: 1.0):
                    daColor = "Cream"
                default:
                    print("err")
                }
                var data:(Double,Double?,Int,String)!
                let memorabilia = recievedMerch as! MerchMemorabiliaData
                if let colors = memorabilia.colors {
                    for co in colors {
                        if co.color == daColor {
                            data = (co.retailPrice, co.salePrice, co.quantity, co.description)
                        }
                    }
                }
                merchPrice.text = data.0.dollarString
                priceToPay = data.0*Double(quantityStepper.countLabel.text!)!
                if let sale = data.1 {
                    merchSale.text = sale.dollarString
                    priceToPay = sale*Double(quantityStepper.countLabel.text!)!
                }
                if data.2 < 5 {
                    lowQuantityLabel.text = "Only \(data.2) left"
                    lowQuantityLabel.tintColor = Constants.Colors.redApp
                    quantityStepper.maximum = Float(data.2)
                } else {
                    lowQuantityLabel.text = "In Stock"
                    lowQuantityLabel.tintColor = .green
                    quantityStepper.maximum = Float(data.2)
                }
                productDescription.text = data.3
                currentSizeLabel.text = "Size: \(selectedSize)"
                currentAvailableLabel.text = "Color: \(daColor!)"
                availableCollectionView.reloadData()
                sizesCollectionView.reloadData()
                view.layoutSubviews()
//            case is MerchInstrumentalData:
//
            default:
                print("njbnj")
            }
        case sizesCollectionView:
            selectedSize = sizelist[indexPath.item]
            currentSizeLabel.text = "Size: \(selectedSize)"
            sizesCollectionView.reloadData()
            view.layoutSubviews()
        case mightAlsoLikeCollectionView:
            if let merch = mightAlsoLikeArr[indexPath.item].kit {
                merchToGo = merch
            } else if let merch = mightAlsoLikeArr[indexPath.item].apperal{
                merchToGo = merch
            } else if let merch = mightAlsoLikeArr[indexPath.item].service{
                merchToGo = merch
            } else if let merch = mightAlsoLikeArr[indexPath.item].memorabilia{
                merchToGo = merch
            } else if let merch = mightAlsoLikeArr[indexPath.item].instrumentalSale{
                merchToGo = merch
            }
            performSegue(withIdentifier: "productToProduct", sender: nil)
        default:
            print("iuygtfd")
        }
    }
}

class SmallImageCollectionViewCell: UICollectionViewCell {
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
}

class ProductSizeSelectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var box:BEMCheckBox!
    @IBOutlet weak var size:UILabel!
    
    override func prepareForReuse() {
        box.on = false
        size.alpha = 1
        box.tintColor = .white
    }
    
    override var isHighlighted: Bool {
        didSet{
            tapScale(cell: self, down: isHighlighted)
        }
    }
}
