//
//  CheckoutViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/17/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import UIKit
import MarqueeLabel
import Braintree
import BraintreeDropIn
import PassKit
import Alamofire
import WebKit
import PDFKit
import CDAlertView
import NVActivityIndicatorView
import FirebaseDatabase
import SkyFloatingLabelTextField
import SKCountryPicker

var checkoutVC:UIViewController!

let CheckoutPresentBTDropInNotificationKey = "com.gitemsolutions.CheckoutPresentBTDropInjkshdfgjkerhdfbn"
let CheckoutPresentBTDropInNotify = Notification.Name(CheckoutPresentBTDropInNotificationKey)

let CheckoutTappedApplePayNotificationKey = "com.gitemsolutions.CheckoutTappedApplePayjkshdfgjkerhdfbn"
let CheckoutTappedApplePayNotify = Notification.Name(CheckoutTappedApplePayNotificationKey)

let CheckoutPaymentConfirmedNotificationKey = "com.gitemsolutions.CheckoutPaymentConfirmedjkshdfgjkerhdfbn"
let CheckoutPaymentConfirmedNotify = Notification.Name(CheckoutPaymentConfirmedNotificationKey)

let OpenCountryPickerNotificationKey = "com.gitemsolutions.OpenCountryPickerjkshdfgjkerhdfbn"
let OpenCountryPickerConfirmedNotify = Notification.Name(OpenCountryPickerNotificationKey)

var checkoutClientToken:String!

var checkoutDidSelectApplePay: Bool = false
var checkoutSelectedNonce: BTPaymentMethodNonce?

var checkoutCustomerCompany = ""
var checkoutCustomerEmail = "awilliams@gmail.com"
var checkoutCustomerFirstName = ""
var checkoutCustomerLastName = ""
var checkoutCustomerPhone = "404-567-3793"

var checkoutBillingEqualsShipping = true

var checkoutBillingCompany = ""
var checkoutBillingFirstName = ""
var checkoutBillingLastName = ""
var checkoutBillingCountryName = ""
var checkoutBillingState = ""
var checkoutBillingCity = ""
var checkoutBillingPostalCode = ""
var checkoutBillingStreetAddress = ""
var checkoutBillingExtendedAddress = ""

var checkoutShippingCompany = ""
var checkoutShippingFirstName = ""
var checkoutShippingLastName = ""
var checkoutShippingCountryName = ""
var checkoutShippingState = ""
var checkoutShippingCity = ""
var checkoutShippingPostalCode = ""
var checkoutShippingStreetAddress = ""
var checkoutShippingExtendedAddress = ""
var checkoutShippingAmount = "8.75"

class CheckoutViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var checkoutCollectionView: UICollectionView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var loadingSpinner: NVActivityIndicatorView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    
    var currentPAge = 0
    
    var infoLive = false
    var braintreeClient: BTAPIClient?
    var pdfToGo:Data!
    var agreeIndex:Int!
    var agreeIndexArray:[Int] = []
    
    var agreementPDFs:[CheckoutAgreementPair] = []
    var agreedone = false
    var returnAdded = false
    
    var clientTokenSet = false
    var countryPickerType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createObservers()
        checkoutCollectionView.allowsSelection = false
        pageControl.numberOfPages = 5
        agreeIndexArray = []
        agreementPDFs = []
        infoLive = false
        loadingSpinner.stopAnimating()
        nextButton.layer.cornerRadius = 7
        previousButton.layer.cornerRadius = 7
        previousButton.isHidden = true
        nextLabel.text = "Total is \(userCart.amount.dollarString)"
        checkoutCollectionView.delegate = self
        checkoutCollectionView.dataSource = self
        braintreeClient = BTAPIClient(authorization: "sandbox_gpztvcf4_64rmvt3jnstqv2cp")
        BTUIKAppearance.sharedInstance().colorScheme = .dark
        let request =  BTDropInRequest()
        request.vaultManager = true
        let queue = DispatchQueue(label: "myakjbjhbhjbjbjunncheckoutdsfhjhgfdxzvczjvb,hds ZKfhcuewsQueue")
        let group = DispatchGroup()
        let array = [0]
        for i in array {
            group.enter()
            queue.async { [weak self] in
                guard let strongSelf = self else {return}
                switch i {
                case 0:
                    strongSelf.generateAgreements(completion: {
                        print("done \(i)")
                        DispatchQueue.main.async {
                            strongSelf.loadingSpinner.stopAnimating()
                        }
                        strongSelf.agreedone = true
                        group.leave()
                    })
                default:
                    print("err")
                }
            }
        }
        
        group.notify(queue: DispatchQueue.main) { [weak self] in
            guard let strongSelf = self else {return}
            print("done!")
            checkoutVC = self
            strongSelf.checkoutCollectionView.reloadData()
            strongSelf.checkoutCollectionView.layoutSubviews()
            strongSelf.view.layoutSubviews()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pageTitle.text = "Review Cart"
        loadingSpinner.stopAnimating()
        //setPageTitle(page: 0)
        currentAppUser.brainTreeID = nil
        if let btid = currentAppUser.brainTreeID {
            print(btid)
            fetchExistingPaymentMethod(clientToken: btid)
            let parameters = ["customerId":btid]
            AF.request("https://us-central1-tonedeafdeafinitions.cloudfunctions.net/searchCustomer", method: .get, parameters: parameters).responseJSON(completionHandler: {[weak self] response in
                guard let strongSelf = self else {return}
                print(response.result)
                strongSelf.fetchExistingClientToken()
            })
        } else {
            fetchClientToken()
        }
        
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(nextPage), name: NextCheckoutPAgeNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(prevPage), name: PreviousCheckoutPAgeNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentBTDropIn), name: CheckoutPresentBTDropInNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openWebView(notificantion:)), name: OpenWebViewWithURLNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(agreeSuccess(notificantion:)), name: CheckoutSuccessfulAgreeNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tappedApplePay), name: CheckoutTappedApplePayNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(postNonceToServer), name: CheckoutPaymentConfirmedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openCountryPicker), name: OpenCountryPickerConfirmedNotify, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("📗 Checkout controller being deallocated from memory. OS reclaiming")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "checkoutToAgree" {
            if let viewController: AgreementViewController = segue.destination as? AgreementViewController {
                viewController.agreeIndex = agreeIndex
                viewController.pdfGoing = pdfToGo
            }
        }
    }
    
    @objc func openWebView(notificantion:Notification) {
        let dict = (notificantion.object) as! [String:Any]
        let data = dict["pdf"] as! Data
        agreeIndex = (dict["index"] as! Int)
        pdfToGo = data
        performSegue(withIdentifier: "checkoutToAgree", sender: nil)
    }
    
    @objc func agreeSuccess(notificantion:Notification) {
        infoLive = true
        let index = (notificantion.object as! Int)
        agreeIndexArray.append(index)
        checkoutCollectionView.reloadSections(IndexSet(integer: 0))
        let coll = checkoutCollectionView.cellForItem(at: IndexPath(item: 1, section: 0)) as! CheckoutAgreementsCollectionViewCell
        coll.agreementTableView.reloadData()
        setPageTitle(page: 1)
        UIView.animate(withDuration: 0.3) {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.view.layoutSubviews()
        }
    }
    
    @objc func openCountryPicker(notification: Notification) {
        countryPickerType = (notification.object) as! String
    }
    
    func fetchClientToken() {
        AF.request("https://us-central1-tonedeafdeafinitions.cloudfunctions.net/client_token", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseJSON(completionHandler: {[weak self] response in
            guard let strongSelf = self else {return}
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("example success")
                    do {
                        typealias JSONObject = [String:AnyObject]
                        if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                            if let token = jsonResult["clientToken"] as? String {
                                checkoutClientToken = token
                                strongSelf.clientTokenSet = true
                                DispatchQueue.main.async {
                                    strongSelf.checkoutCollectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
                                    strongSelf.loadingSpinner.stopAnimating()
                                }
                                strongSelf.fetchExistingPaymentMethod(clientToken: token)
                            } else {
                                print("handle client token error 3")
                            }
                        }
                    } catch {
                        print("handle client token error 2 \(error)")
                    }
                default:
                    print("handle client token error 1")
                }
            }
        })
    }
    
    func fetchExistingClientToken() {
        let parameters = ["customerIdentification":currentAppUser.brainTreeID]
        AF.request("https://us-central1-tonedeafdeafinitions.cloudfunctions.net/returning_client_token", method: .get, parameters: parameters).responseJSON(completionHandler: {[weak self] response in
            guard let strongSelf = self else {return}
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("example success")
                    do {
                        typealias JSONObject = [String:AnyObject]
                        if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                            if let token = jsonResult["clientToken"] as? String {
                                checkoutClientToken = token
                                strongSelf.clientTokenSet = true
                                DispatchQueue.main.async {
                                    strongSelf.checkoutCollectionView.reloadItems(at: [IndexPath(item: 2, section: 0)])
                                    strongSelf.loadingSpinner.stopAnimating()
                                }
                                strongSelf.fetchExistingPaymentMethod(clientToken: token)
                            } else {
                                print("handle client token error 3")
                            }
                        }
                    } catch {
                        print("handle client token error 2 \(error)")
                    }
                default:
                    print("handle client token error 1")
                }
            }
        })
    }
    
    func generateAgreements(completion: @escaping () -> Void) {
        agreementPDFs = []
        DispatchQueue.global().async {
            var tick = 0
            for index in 0..<userCart.count {
                let item = userCart[index].product
                let word = item.id.split(separator: "Æ")
                let tdid = word[0]
                switch tdid.count {
                case 13...14:
                    switch item.type {
                    case "Mp3":
                        ReturnPolicy.shared.getReturnAgreement(completion: {[weak self] pdf in
                            guard let strongSelf = self else {return}
                            let cap = CheckoutAgreementPair(product: item, agreement: pdf, type: "return")
                            if !strongSelf.returnAdded {
                                strongSelf.agreementPDFs.append(cap)
                            }
                            strongSelf.returnAdded = true
                            MP3Lease.shared.getLeaseAgreement(nameofbeat: item.name, producers: item.involved, completion: {[weak self] pdf in
                                guard let strongSelf = self else {return}
                                let cap = CheckoutAgreementPair(product: item, agreement: pdf, type: "beat")
                                strongSelf.agreementPDFs.append(cap)
                                tick+=1
                                if tick == userCart.count {
                                    completion()
                                }
                            })
                        })
                    case "Wav":
                        ReturnPolicy.shared.getReturnAgreement(completion: {[weak self] pdf in
                            guard let strongSelf = self else {return}
                            let cap = CheckoutAgreementPair(product: item, agreement: pdf, type: "return")
                            if !strongSelf.returnAdded {
                                strongSelf.agreementPDFs.append(cap)
                            }
                            strongSelf.returnAdded = true
                            WavLease.shared.getLeaseAgreement(nameofbeat: item.name, producers: item.involved, completion: {[weak self] pdf in
                                guard let strongSelf = self else {return}
                                let cap = CheckoutAgreementPair(product: item, agreement: pdf, type: "beat")
                                strongSelf.agreementPDFs.append(cap)
                                tick+=1
                                if tick == userCart.count {
                                    completion()
                                }
                            })
                        })
                    default:
                        tick+=1
                        if tick == userCart.count {
                            completion()
                        }
                        print("water")
                    }
                case 20:
                    ReturnPolicy.shared.getReturnAgreement(completion: {[weak self] pdf in
                        guard let strongSelf = self else {return}
                        let cap = CheckoutAgreementPair(product: item, agreement: pdf, type: "return")
                        if !strongSelf.returnAdded {
                            strongSelf.agreementPDFs.append(cap)
                        }
                        strongSelf.returnAdded = true
                        tick+=1
                        if tick == userCart.count {
                            completion()
                        }
                    })
                case 21:
                    ReturnPolicy.shared.getReturnAgreement(completion: {[weak self] pdf in
                        guard let strongSelf = self else {return}
                        let cap = CheckoutAgreementPair(product: item, agreement: pdf, type: "return")
                        if !strongSelf.returnAdded {
                            strongSelf.agreementPDFs.append(cap)
                        }
                        strongSelf.returnAdded = true
                        tick+=1
                        if tick == userCart.count {
                            completion()
                        }
                    })
                case 22:
                    ReturnPolicy.shared.getReturnAgreement(completion: {[weak self] pdf in
                        guard let strongSelf = self else {return}
                        let cap = CheckoutAgreementPair(product: item, agreement: pdf, type: "return")
                        if !strongSelf.returnAdded {
                            strongSelf.agreementPDFs.append(cap)
                        }
                        strongSelf.returnAdded = true
                        tick+=1
                        if tick == userCart.count {
                            completion()
                        }
                    })
                case 23:
                    ReturnPolicy.shared.getReturnAgreement(completion: {[weak self] pdf in
                        guard let strongSelf = self else {return}
                        let cap = CheckoutAgreementPair(product: item, agreement: pdf, type: "return")
                        if !strongSelf.returnAdded {
                            strongSelf.agreementPDFs.append(cap)
                        }
                        strongSelf.returnAdded = true
                        tick+=1
                        if tick == userCart.count {
                            completion()
                        }
                    })
                case 24:
                    ReturnPolicy.shared.getReturnAgreement(completion: {[weak self] pdf in
                        guard let strongSelf = self else {return}
                        let cap = CheckoutAgreementPair(product: item, agreement: pdf, type: "return")
                        if !strongSelf.returnAdded {
                            strongSelf.agreementPDFs.append(cap)
                        }
                        strongSelf.returnAdded = true
                        tick+=1
                        if tick == userCart.count {
                            completion()
                        }
                    })
                default:
                    print("")
                    tick+=1
                    if tick == userCart.count {
                        completion()
                    }
                //24 didgits is memorabilia
                //23 didgits is apperal
                //22 didgits is a kit
                //21 didgits is a bundle
                //20 didgits is a service
                }
                
            }
        }
    }
    
    @objc func presentBTDropIn(notification: Notification) {
        let dropIn = (notification.object) as! BTDropInController
        present(dropIn, animated: true, completion: nil)
    }
    
    func fetchExistingPaymentMethod(clientToken: String) {
        BTDropInResult.fetch(forAuthorization: clientToken, handler: { (result, error) in
            if (error != nil) {
                print("ERROR existing \(error)")
                
            } else if let result = result {
                print("existing fetch good \(result.paymentOptionType)\n\(result.paymentDescription)\n\(result.paymentMethod)")
                let selectedPaymentOptionType = result.paymentOptionType
                let selectedPaymentMethod = result.paymentMethod
                let selectedPaymentMethodIcon = result.paymentIcon
                let selectedPaymentMethodDescription = result.paymentDescription
            }
        })
    }
    
    @objc func postNonceToServer() {
        checkoutCustomerFirstName = checkoutBillingFirstName
        checkoutCustomerLastName = checkoutBillingLastName
        checkoutCustomerCompany = checkoutBillingCompany
        // Update URL with your server
        guard let nonce = checkoutSelectedNonce else {
            print("nonce not present")
            return
        }
        let parameters = ["payment_method_nonce": nonce.nonce,
                          "total": String(userCart.amount),
                          "customerCompany":checkoutCustomerCompany,
                          "customerEmail": checkoutCustomerEmail,
                          "customerFirstName": checkoutCustomerFirstName,
                          "customerLastName": checkoutCustomerLastName,
                          "customerPhone": checkoutCustomerPhone,
                          "billingCompany":checkoutBillingCompany,
                          "billingFirstName": checkoutBillingFirstName,
                          "billingLastName": checkoutBillingLastName,
                          "billingCountryName": checkoutBillingCountryName,
                          "billingExtendedAddress": checkoutBillingExtendedAddress,
                          "billingState": checkoutBillingState,
                          "billingCity": checkoutBillingCity,
                          "billingPostalCode": checkoutBillingPostalCode,
                          "billingStreetAddress": checkoutBillingStreetAddress,
//                          "shippingCompany":checkoutShippingCompany,
//                          "shippingFirstName": checkoutShippingFirstName,
//                          "shippingLastName": checkoutShippingLastName,
//                          "shippingCountryName": checkoutShippingCountryName,
//                          "shippingExtendedAddress": checkoutShippingExtendedAddress,
//                          "shippingState": checkoutShippingState,
//                          "shippingCity": checkoutShippingCity,
//                          "shippingPostalCode": checkoutShippingPostalCode,
//                          "shippingStreetAddress": checkoutShippingStreetAddress,
//                          "shippingAmount": checkoutShippingAmount
        ]

        AF.request("https://us-central1-tonedeafdeafinitions.cloudfunctions.net/checkoutNewCustomer", method: .post, parameters: parameters).responseJSON { response in
            do {
                typealias JSONObject = [String:AnyObject]
                if let jsonResult = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String : AnyObject] {
                    if let transaction = jsonResult["transaction"] as? JSONObject {
                        let customer = transaction["customer"] as! JSONObject
                        let customerID = customer["id"] as! String
                        currentAppUser.brainTreeID = customerID
                        Database.database().reference().child("Users").child(currentAppUser.uid).child("Braintree ID").setValue(customerID)
                        print(response.result)
                    } else {
                        if let errormessage = jsonResult["message"] as? String {
                            
                            print(errormessage)
                        } else {
                            print("unknown proccessing error.")
                        }
                    }
                }
            } catch {
                print("handle client token error 2 \(error)")
            }
            
    
        }
    }
    
    func setupPaymentRequest(completion: @escaping (PKPaymentRequest?, Error?) -> Void) {
        let applePayClient = BTApplePayClient(apiClient: self.braintreeClient!)
        // You can use the following helper method to create a PKPaymentRequest which will set the `countryCode`,
        // `currencyCode`, `merchantIdentifier`, and `supportedNetworks` properties.
        // You can also create the PKPaymentRequest manually. Be aware that you'll need to keep these in
        // sync with the gateway settings if you go this route.
        applePayClient.paymentRequest { (paymentRequest, error) in
            guard let paymentRequest = paymentRequest else {
                completion(nil, error)
                return
            }

            // We recommend collecting billing address information, at minimum
            // billing postal code, and passing that billing postal code with all
            // Apple Pay transactions as a best practice.
            paymentRequest.requiredBillingContactFields = [.postalAddress, .emailAddress, .name]

            // Set other PKPaymentRequest properties here
            paymentRequest.merchantCapabilities = [.capability3DS, .capabilityDebit]
            paymentRequest.paymentSummaryItems =
            [
                PKPaymentSummaryItem(label: "beattttt", amount: NSDecimalNumber(string: "300.00")),
                // Add add'l payment summary items...
                PKPaymentSummaryItem(label: "Tone Deaf Music Group", amount: NSDecimalNumber(string: "300.00")),
            ]
            completion(paymentRequest, nil)
        }
    }
    
    @objc func tappedApplePay() {
        setupPaymentRequest {[weak self] (paymentRequest, error) in
            guard let strongSelf = self else {return}
            guard error == nil else {
               // Handle error
               return
            }

            // Example: Promote PKPaymentAuthorizationViewController to optional so that we can verify
            // that our paymentRequest is valid. Otherwise, an invalid paymentRequest would crash our app.
            if let vc = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest!)
                as PKPaymentAuthorizationViewController?
            {
                vc.delegate = self
                strongSelf.present(vc, animated: true, completion: nil)
            } else {
                print("Error: Payment request is invalid.")
            }
        }
    }
    
    func setPageTitle(page: Int) {
        switch page {
        case 0:
            pageTitle.text = "Review Cart"
            loadingSpinner.stopAnimating()
            previousButton.isHidden = true
            nextButton.isHidden = false
            nextButton.isEnabled = true
            nextButton.backgroundColor = Constants.Colors.redApp
            nextButton.setTitleColor(.white, for: .normal)
            nextLabel.text = "Total is \(userCart.amount.dollarString)"
            nextButton.setTitle("Confirm", for: .normal)
            UIView.animate(withDuration: 0.1) {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.checkoutCollectionView.layoutSubviews()
                strongSelf.view.layoutSubviews()
            }
        case 1:
            pageTitle.text = "Policies & Agreements"
            previousButton.isHidden = false
            nextButton.isHidden = false
            previousButton.isEnabled = true
            previousButton.setTitle("Review Cart", for: .normal)
            if agreementPDFs.count != agreeIndexArray.count {
                nextButton.isEnabled = false
                nextButton.backgroundColor = .gray
                nextButton.setTitleColor(.darkGray, for: .normal)
                nextLabel.text = "Pending Agreements"
            } else {
                nextLabel.text = "Agreed"
                nextButton.setTitle("To Payments", for: .normal)
                nextButton.backgroundColor = Constants.Colors.redApp
                nextButton.setTitleColor(.white, for: .normal)
                nextButton.isEnabled = true
            }
            if agreedone == false {
                loadingSpinner.startAnimating()
                UIView.animate(withDuration: 0.1) {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.checkoutCollectionView.layoutSubviews()
                    strongSelf.view.layoutSubviews()
                }
            } else {
                loadingSpinner.stopAnimating()
                UIView.animate(withDuration: 0.1) {[weak self] in
                    guard let strongSelf = self else {return}
                    strongSelf.checkoutCollectionView.layoutSubviews()
                    strongSelf.view.layoutSubviews()
                }
            }
        case 2:
            pageTitle.text = "Billing"
            if clientTokenSet == false {
                loadingSpinner.startAnimating()
            } else {
                loadingSpinner.stopAnimating()
            }
            nextButton.isEnabled = true
            previousButton.isHidden = false
            nextButton.isHidden = false
            previousButton.isEnabled = true
            previousButton.setTitle("Agreements", for: .normal)
            nextButton.setTitle("To Shipping", for: .normal)
            UIView.animate(withDuration: 0.1) {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.checkoutCollectionView.layoutSubviews()
                strongSelf.view.layoutSubviews()
            }
        case 3:
            
            pageTitle.text = "Shipping"
            loadingSpinner.stopAnimating()
            previousButton.isHidden = false
            nextButton.isHidden = false
            nextButton.isEnabled = true
//            checkoutCollectionView.reloadItems(at: [IndexPath(item: page, section: 0)])
//            let coll = checkoutCollectionView.cellForItem(at: IndexPath(item: page, section: 0)) as! CheckoutShippingCollectionViewCell
//            checkoutCollectionView.reloadData()
//            checkoutCollectionView.reloadItems(at: [IndexPath(item: page, section: 0)])
            UIView.animate(withDuration: 0.1) {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.checkoutCollectionView.layoutSubviews()
                strongSelf.view.layoutSubviews()
            }
        case 4:
            pageTitle.text = "Summary"
            loadingSpinner.stopAnimating()
            previousButton.isHidden = false
            nextButton.isHidden = false
//            checkoutCollectionView.reloadItems(at: [IndexPath(item: page, section: 0)])
//            let coll = checkoutCollectionView.cellForItem(at: IndexPath(item: page, section: 0)) as! CheckoutConfirmCollectionViewCell
//            checkoutCollectionView.reloadData()
//            checkoutCollectionView.reloadItems(at: [IndexPath(item: page, section: 0)])
            UIView.animate(withDuration: 0.1) {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.checkoutCollectionView.layoutSubviews()
                strongSelf.view.layoutSubviews()
            }
        default:
            print("collection error")
        }
    }
    
    @IBAction func nextPage() {
        
        
        switch currentPAge {
        case 2:
            guard checkoutSelectedNonce != nil else {
                print("select a pay method")
                return
            }
            guard checkoutBillingFirstName != "" else {
                print("first name error")
                return
            }
            guard checkoutBillingLastName != "" else {
                print("last name error")
                return
            }
            guard checkoutBillingCountryName != "" else {
                print("country name error")
                return
            }
            guard checkoutBillingStreetAddress != "" else {
                print("address error")
                return
            }
            guard checkoutBillingCity != "" else {
                print("city error")
                return
            }
            guard checkoutBillingState != "" else {
                print("state error")
                return
            }
            guard checkoutBillingPostalCode != "" else {
                print("postal code error")
                return
            }
        default:
            print("good")
        }
        currentPAge+=1
        nextButton.isEnabled = false
        print("page \(currentPAge)")
        switch currentPAge {
        case 4:
            postNonceToServer()
        default:
            checkoutCollectionView.scrollToNextItem()
        }
        checkoutCollectionView.reloadItems(at: [IndexPath(item: currentPAge, section: 0)])
        checkoutCollectionView.layoutSubviews()
    }
    
    @IBAction func prevPage() {
        currentPAge-=1
        previousButton.isEnabled = false
        print("page \(currentPAge)")
        checkoutCollectionView.scrollToPreviousItem()
    }
    
     @IBAction func dismissCheckout(_ sender: Any) {
        if infoLive == false {
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            let alerticon = UIImage(named: "warning")!.withTintColor(.white)
            let actionSheet = CDAlertView(title: "Are you sure you want to exit checkout?", message: "All progress will be lost and any agreements made will be voided.", type: .custom(image: alerticon))
            actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
            actionSheet.circleFillColor = .black
            actionSheet.titleTextColor = .white
            actionSheet.messageTextColor = .white
            let cancel = CDAlertViewAction(title: "Cancel", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil)
            actionSheet.add(action: cancel)
            actionSheet.add(action: CDAlertViewAction(title: "Exit", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: {[weak self]_ in
                guard let strongSelf = self else {return false}
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                return true
            }))
            actionSheet.show()
        }
     }

}

class CheckoutAgreementPair {
    var product:Product
    var agreement:NSMutableData
    var type:String
    
    init(product:Product, agreement:NSMutableData, type:String) {
        self.product = product
        self.agreement = agreement
        self.type = type
    }
}



extension CheckoutViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Tokenize the Apple Pay payment
        
        let applePayClient = BTApplePayClient(apiClient: self.braintreeClient!)
            applePayClient.tokenizeApplePay(payment) {[weak self] (nonce, error) in
                guard let strongSelf = self else {return}
                if error != nil {
                    // Received an error from Braintree.
                    // Indicate failure via the completion callback.
                    completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                    return
                }
                checkoutSelectedNonce = nonce!
                // TODO: On success, send nonce to your server for processing.
                // If requested, address information is accessible in `payment` and may
                // also be sent to your server.

                // Then indicate success or failure based on the server side result of Transaction.sale
                // via the completion callback.
                // e.g. If the Transaction.sale was successful
                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
            }
    }
}

extension CheckoutViewController: BTViewControllerPresentingDelegate, BTAppSwitchDelegate {
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        
    }
    
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        
    }
}

extension CheckoutViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "checkoutCartCollectionViewCell", for: indexPath) as! CheckoutCartCollectionViewCell
                cell.funcSetUp(currentPage: indexPath.item)
            cell.cartTableView.reloadData()
            cell.layoutSubviews()
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "checkoutAgreementsCollectionViewCell", for: indexPath) as! CheckoutAgreementsCollectionViewCell
                cell.funcSetUp(agreementPairs: agreementPDFs, agrmntarr: agreeIndexArray, agreedone: agreedone)
            cell.agreementTableView.reloadData()
            cell.layoutSubviews()
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "checkoutBillingCollectionViewCell", for: indexPath) as! CheckoutBillingCollectionViewCell
            if clientTokenSet != false {
                cell.funcSetUp()
            }
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "checkoutShippingCollectionViewCell", for: indexPath) as! CheckoutShippingCollectionViewCell
                cell.funcSetUp(currentPage: indexPath.item)
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "checkoutConfirmCollectionViewCell", for: indexPath) as! CheckoutConfirmCollectionViewCell
                cell.funcSetUp(currentPage: indexPath.item)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: checkoutCollectionView.frame.width, height: checkoutCollectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        lightImpactGenerator.impactOccurred()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        lightImpactGenerator.impactOccurred()
        pageControl?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        setPageTitle(page: pageControl.currentPage)
    }
    
}

fileprivate let NextCheckoutPageNotificationKey = "com.gitemsolutions.NextCheckoutPagejkshdfgjkerhdfbn"
fileprivate let NextCheckoutPAgeNotify = Notification.Name(NextCheckoutPageNotificationKey)
fileprivate let PreviousCheckoutPageNotificationKey = "com.gitemsolutions.PreviousCheckoutPagejkshdfgjkerhdfbn"
fileprivate let PreviousCheckoutPAgeNotify = Notification.Name(PreviousCheckoutPageNotificationKey)


//MARK: - Page 1 Cart
class CheckoutCartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cartTableView: UITableView!
    
    var currentPage = 0
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
//        backButton.isHidden = false
//        nextButton.isHidden = false
//        nextLabel.text = ""
//        nextButton.isEnabled = true
//        nextButton.backgroundColor = Constants.Colors.redApp
//        nextButton.setTitleColor(.white, for: .normal)
    }
    
    func funcSetUp(currentPage: Int) {
        self.currentPage = currentPage
            cartTableView.delegate = self
            cartTableView.dataSource = self
        cartTableView.reloadData()
        self.contentView.layoutSubviews()
    }
    
    @IBAction func NextButtonTapped(_ sender: Any) {
            NotificationCenter.default.post(name: NextCheckoutPAgeNotify, object: nil)
        
    }
    
    @IBAction func PreviousButtonTapped(_ sender: Any) {
            NotificationCenter.default.post(name: PreviousCheckoutPAgeNotify, object: nil)
    }
}

extension CheckoutCartCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            print("cart")
            return 175
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("cart")
            return userCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cartCheckoutTableViewCell", for: indexPath) as! CartCheckoutTableViewCell
        cell.quantityStepper.incrementCallback = {[weak self] _, count in
            guard let strongSelf = self else {return}
            cell.quantityStepper.countLabel.text = "\(Int(count))"
            userCart.increment(userCart[indexPath.row].product)
            cell.itemPrice.text = (userCart[indexPath.row].product.price*Double(userCart[indexPath.row].quantity)).dollarString
            cell.contentView.layoutSubviews()
            //strongSelf.nextLabel.text = "Total is \(userCart.amount.dollarString)"
            strongSelf.contentView.layoutSubviews()
        }
        cell.quantityStepper.decrementCallback = {[weak self] _, count in
            guard let strongSelf = self else {return}
            cell.quantityStepper.countLabel.text = "\(Int(count))"
            userCart.decrement(userCart[indexPath.row].product)
            cell.itemPrice.text = (userCart[indexPath.row].product.price*Double(userCart[indexPath.row].quantity)).dollarString
            cell.contentView.layoutSubviews()
            //strongSelf.nextLabel.text = "Total is \(userCart.amount.dollarString)"
            strongSelf.contentView.layoutSubviews()
        }
            cell.funcSetUp(product: userCart[indexPath.row].product, quantity: userCart[indexPath.row].quantity)
            cell.contentView.layer.cornerRadius = 10
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
            print("cart")
            let cell = tableView.cellForRow(at: indexPath) as! CartCheckoutTableViewCell
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
            popover.sourceRect = CGRect(x: cell.bounds.width - 58, y: cell.bounds.height/2 - 11, width: 22, height: 22)
            vc.setUpArr(item: cell.produck)
            checkoutVC.present(vc, animated: true, completion: nil)
    }
}

extension CheckoutCartCollectionViewCell: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }

        
        func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
            return UIModalPresentationStyle.none
        }
}

import PKYStepper
class CheckoutCartTableView: UITableView {
        override var intrinsicContentSize: CGSize {
            layoutIfNeeded()
            return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
        }
}

class CartCheckoutTableViewCell:UITableViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: MarqueeLabel!
    @IBOutlet weak var itemCategory: MarqueeLabel!
    @IBOutlet weak var invlovedLabel: MarqueeLabel!
    @IBOutlet weak var itemType: MarqueeLabel!
    @IBOutlet weak var quantityStepper: PKYStepper!
    @IBOutlet weak var quantityLAbel: MarqueeLabel!
    @IBOutlet weak var itemPrice: UILabel!
    var produck:Product!
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        produck = nil
    }
    
    func funcSetUp(product: Product, quantity: Int) {
        produck = product
        itemImage.layer.cornerRadius = 7
        quantityStepper.setBorderColor(Constants.Colors.redApp)
        quantityStepper.setLabelTextColor(.white)
        quantityStepper.stepInterval = 1
        quantityStepper.value = Float(quantity)
        quantityStepper.countLabel.text = String(Int(quantityStepper.value))
        quantityStepper.minimum = 1
        quantityStepper.setLabel(UIFont(name: "AvenirNextCondensed-DemiBold", size: 14)!)
        quantityStepper.setButtonTextColor(Constants.Colors.redApp, for: .normal)
        quantityStepper.hidesDecrementWhenMinimum = true
        quantityStepper.hidesIncrementWhenMaximum = true
        var itemtype = ""
        let word = product.id.split(separator: "Æ")
        let id = word[0]
        switch id.count {
        case 13:
            itemtype = "BEAT"
            quantityStepper.maximum = 1
        case 14:
            itemtype = "BEAT"
            quantityStepper.maximum = 1
        default:
            print("null")
        }
        itemCategory.text = " · \(itemtype)"
        itemName.text = "\(product.name)"
        itemPrice.text = (product.price*Double(quantity)).dollarString
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
        invlovedLabel.text = names.joined(separator: ", ")
        itemType.text = product.type
    }
}

//MARK: - Page 2 Agreements
class CheckoutAgreementsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var agreementTableView: UITableView!
    
    var agreementPDFs:[CheckoutAgreementPair]!
    var agreementArr:[Int]!
    var currentPage = 0
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
    }
    
    func funcSetUp(agreementPairs: [CheckoutAgreementPair], agrmntarr:[Int], agreedone: Bool) {
        agreementArr = agrmntarr
        agreementPDFs = agreementPairs
        print("Agreements")
        agreementTableView.delegate = self
        agreementTableView.dataSource = self
    }
    
    @IBAction func NextButtonTapped(_ sender: Any) {
            NotificationCenter.default.post(name: NextCheckoutPAgeNotify, object: nil)
        
    }
    
    @IBAction func PreviousButtonTapped(_ sender: Any) {
            NotificationCenter.default.post(name: PreviousCheckoutPAgeNotify, object: nil)
    }
}

extension CheckoutAgreementsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            print("Agreements")
        
            return 135
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("Agreements", agreementPDFs.count)
            return agreementPDFs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("Agreements")
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "agreementsCheckoutTableViewCell", for: indexPath) as! AgreementCheckoutTableViewCell
            if !agreementPDFs.isEmpty {
                cell.funcSetUp(product: agreementPDFs[indexPath.row].product, agreetype: agreementPDFs[indexPath.row].type)
                for index in agreementArr {
                    if index == indexPath.row {
                        cell.checkbox.on = true
                    }
                }
            }
            cell.contentView.layer.cornerRadius = 10
            return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("Agreements")
            let pdfData = agreementPDFs[indexPath.row].agreement
            let myDict = ["pdf":Data(pdfData), "index": indexPath.row] as [String : Any]
            NotificationCenter.default.post(name: OpenWebViewWithURLNotify, object: myDict)
            tableView.deselectRow(at: indexPath, animated: false)
    }
}

import BEMCheckBox
class CheckoutAgreementsTableView: UITableView {
        override var intrinsicContentSize: CGSize {
            layoutIfNeeded()
            return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
        }
}

class AgreementCheckoutTableViewCell:UITableViewCell {
    
    
    @IBOutlet weak var agreementName: MarqueeLabel!
    @IBOutlet weak var agreementMessage: UILabel!
    @IBOutlet weak var iAgreeLabel: UILabel!
    @IBOutlet weak var checkbox: BEMCheckBox!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        checkbox.isSelected = false
    }
    
    func funcSetUp(product: Product, agreetype: String) {
        checkbox.isUserInteractionEnabled = false
        switch agreetype {
        case "beat":
            agreementMessage.text = "To proceed with the purchase of this item you must view and agree to these terms. Upon purchase a copy of this document will be saved and viewable to you at any time via the documents section of your profile tab."
            switch product.type {
            case "Mp3":
                agreementName.text = "\(product.name) MP3 Lease Agreement"
            case "Wav":
                agreementName.text = "\(product.name) Wav Lease Agreement"
            case "Exclusive":
                agreementName.text = "\(product.name) Exclusive License Agreement"
            default:
                print("hdavbjs")
            }
        case "return":
            agreementName.text = "Return Policy"
            agreementMessage.text = "To proceed with the purchase of the items in this cart you must view and agree to these terms. This document is viewable to you at any time via the documents section of your profile tab."
        default:
            print("")
        //24 didgits is memorabilia
        //23 didgits is apperal
        //22 didgits is a kit
        //21 didgits is a bundle
        //20 didgits is a service
        }
    }
}

//MARK: - Page 3 Billing
class CheckoutBillingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var billingTableView: UITableView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func funcSetUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        dismissKeyboardOnTap()
        print("PAyment Methods")
        billingTableView.delegate = self
        billingTableView.dataSource = self
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

        // if keyboard size is not available for some reason, dont do anything
        return
      }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        billingTableView.contentInset = contentInsets
        billingTableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        
        // reset back the content inset to zero after keyboard is gone
        billingTableView.contentInset = contentInsets
        billingTableView.scrollIndicatorInsets = contentInsets
        contentView.frame.origin.y = 0
    }
    
    
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: contentView, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tap)
        billingTableView.keyboardDismissMode = .onDrag
    }
    
    @IBAction func NextButtonTapped(_ sender: Any) {
            NotificationCenter.default.post(name: NextCheckoutPAgeNotify, object: nil)
        
    }
    
    @IBAction func PreviousButtonTapped(_ sender: Any) {
            NotificationCenter.default.post(name: PreviousCheckoutPAgeNotify, object: nil)
    }
}

extension CheckoutBillingCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            print("PAyment Methods")
            return 800
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            print("PAyment Methods")
            return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            print("PAyment Methods")
            let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCheckoutTableViewCell", for: indexPath) as! PaymentCheckoutTableViewCell
            cell.funcSetUp()
            cell.contentView.layer.cornerRadius = 10
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

class CheckoutBillingTableView: UITableView {
        override var intrinsicContentSize: CGSize {
            layoutIfNeeded()
            return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
        }
}

class PaymentCheckoutTableViewCell:UITableViewCell {
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var payMethodImageView: UIImageView!
    @IBOutlet weak var payMethodContainerView: UIView!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var paymentMethodAccountLabel: MarqueeLabel!
    
    @IBOutlet weak var textFieldsView: UIView!
    @IBOutlet weak var companyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var extAddressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var stateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var postalCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var streetAddressTextField: SkyFloatingLabelTextField!
    
    let states = ["Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado", "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"]
    let canadaProvidences = ["Alberta", "British Columbia", "Manitoba", "New Brunswick", "Newfoundland and Labrador", "Northwest Territories", "Nova Scotia", "Nunavut", "Ontario", "Prince Edward Island", "Quebec", "Saskatchewan", "Yukon Territory"]
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
    
    
    func funcSetUp() {
        
        payMethodContainerView.layer.cornerRadius = 10
        textFieldsView.layer.cornerRadius = 10
        payMethodImageView.layer.cornerRadius = 7
        changeButton.addTarget(self, action: #selector(changePayMethod), for: .touchUpInside)
        setTextFields()
    }
    
    func setTextFields() {
        firstNameTextField.errorMessage = "Required"
        lastNameTextField.errorMessage = "Required"
        countryTextField.errorMessage = "Required"
        streetAddressTextField.errorMessage = "Required"
        stateTextField.errorMessage = "Required"
        cityTextField.errorMessage = "Required"
        postalCodeTextField.errorMessage = "Required"
        
        
        
        companyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        countryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        streetAddressTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        extAddressTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        stateTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cityTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        postalCodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func changePayMethod() {
        let request =  BTDropInRequest()
        request.vaultManager = true
        request.vaultCard = true
        request.shouldMaskSecurityCode = true
        request.allowVaultCardOverride = true
        let dropIn = BTDropInController(authorization: checkoutClientToken, request: request)
            {[weak self] (controller, result, error) in
            guard let strongSelf = self else {return}
                if (error != nil) {
                    print("ERROR")
                } else if (result?.isCancelled == true) {
                    print("CANCELLED")
                } else if let result = result {
                    let view = result.paymentIcon as? BTUIKVectorArtView
                    strongSelf.payMethodImageView.image = view?.image(of: CGSize(width: CGFloat(90), height: CGFloat(60)))
                    strongSelf.paymentMethodAccountLabel.text = result.paymentDescription
                    if result.paymentOptionType == .applePay {
                        checkoutDidSelectApplePay = true
                        strongSelf.payMethodImageView.backgroundColor = Constants.Colors.lightApp
                        strongSelf.paymentMethodLabel.text = "Apple Pay"
                        NotificationCenter.default.post(name: CheckoutTappedApplePayNotify, object: nil)
                    } else {
                        strongSelf.paymentMethodLabel.text = result.paymentMethod?.type
                        checkoutDidSelectApplePay = false
                        strongSelf.payMethodImageView.backgroundColor = .white
                        checkoutSelectedNonce = result.paymentMethod
                    }
                }
                controller.dismiss(animated: true, completion: nil)
            //NotificationCenter.default.post(name: CheckoutPaymentConfirmedNotify, object: nil)
            }
        NotificationCenter.default.post(name: CheckoutPresentBTDropInNotify, object: dropIn)
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        switch textfield {
        case companyTextField:
            if let text = textfield.text {
                if text.count > 255 {
                    companyTextField.errorMessage = "Company Character Limit is 255"
                    checkoutBillingCompany = ""
                }
                else {
                    companyTextField.errorMessage = ""
                    checkoutBillingCompany = text
                    if checkoutBillingEqualsShipping {
                        checkoutShippingCompany = text
                    }
                }
            }
        case firstNameTextField:
            if let text = textfield.text {
                if text.count < 2 {
                    firstNameTextField.errorMessage = "Invalid First Name"
                    checkoutBillingFirstName = ""
                } else if text.count > 255 {
                    firstNameTextField.errorMessage = "Last Name Character Limit is 255"
                    checkoutBillingFirstName = ""
                } else if text == "" {
                    firstNameTextField.errorMessage = "Required"
                    checkoutBillingFirstName = ""
                }
                else {
                    firstNameTextField.errorMessage = ""
                    checkoutBillingFirstName = text
                    if checkoutBillingEqualsShipping {
                        checkoutShippingFirstName = text
                    }
                }
            }
        case lastNameTextField:
            if let text = textfield.text {
                if text.count < 2 {
                    lastNameTextField.errorMessage = "Invalid Last Name"
                    checkoutBillingLastName = ""
                } else if text.count > 255 {
                    lastNameTextField.errorMessage = "Last Name Character Limit is 255"
                    checkoutBillingLastName = ""
                } else if text == "" {
                    lastNameTextField.errorMessage = "Required"
                    checkoutBillingLastName = ""
                }
                else {
                    lastNameTextField.errorMessage = ""
                    checkoutBillingLastName = text
                    if checkoutBillingEqualsShipping {
                        checkoutShippingLastName = text
                    }
                }
            }
        case countryTextField:
            if let text = textfield.text {
                if text == "" {
                    countryTextField.errorMessage = "Required"
                    checkoutBillingCountryName = ""
                }
                else {
                    countryTextField.errorMessage = ""
                    checkoutBillingCountryName = text
                    if checkoutBillingEqualsShipping {
                        checkoutShippingCountryName = text
                    }
                }
            }
        case streetAddressTextField:
            if let text = textfield.text {
                if text == "" {
                    streetAddressTextField.errorMessage = "Required"
                    checkoutBillingStreetAddress = ""
                } else if text.count > 255 {
                    streetAddressTextField.errorMessage = "Address Character Limit is 255"
                    checkoutBillingStreetAddress = ""
                }
                else {
                    streetAddressTextField.errorMessage = ""
                    checkoutBillingStreetAddress = text
                    if checkoutBillingEqualsShipping {
                        checkoutShippingStreetAddress = text
                    }
                }
            }
        case extAddressTextField:
            if let text = textfield.text {
                if text.count > 255 {
                    extAddressTextField.errorMessage = "Extended Address Character Limit is 255"
                    checkoutBillingExtendedAddress = ""
                }
                else {
                    extAddressTextField.errorMessage = ""
                    checkoutBillingExtendedAddress = text
                    if checkoutBillingEqualsShipping {
                        checkoutShippingExtendedAddress = text
                    }
                }
            }
        case cityTextField:
            if let text = textfield.text {
                if text == "" {
                    cityTextField.errorMessage = "Required"
                    checkoutBillingCity = ""
                }
                else if text.count > 255 {
                    cityTextField.errorMessage = "City Character Limit is 255"
                    checkoutBillingCity = ""
                }
                else {
                    cityTextField.errorMessage = ""
                    checkoutBillingCity = text
                    if checkoutBillingEqualsShipping {
                        checkoutShippingCity = text
                    }
                }
            }
        case stateTextField:
            if let text = textfield.text {
                if text == "" {
                    stateTextField.errorMessage = "Required"
                    checkoutBillingState = ""
                }
                else if text.count > 255 {
                    stateTextField.errorMessage = "State Character Limit is 255"
                    checkoutBillingState = ""
                }
                else {
                    stateTextField.errorMessage = ""
                    checkoutBillingState = text
                    if checkoutBillingEqualsShipping {
                        checkoutShippingState = text
                    }
                }
            }
        case postalCodeTextField:
            if let text = textfield.text {
                if text == "" {
                    postalCodeTextField.errorMessage = "Required"
                    checkoutBillingPostalCode = ""
                }
                else if text.count > 9 {
                    postalCodeTextField.errorMessage = "Postal Code Character Limit is 9"
                    checkoutBillingPostalCode = ""
                }
                else if text.count < 4 {
                    postalCodeTextField.errorMessage = "Invalid Postal Code"
                    checkoutBillingPostalCode = ""
                }
                else {
                    postalCodeTextField.errorMessage = ""
                    checkoutBillingPostalCode = text
                    if checkoutBillingEqualsShipping {
                        checkoutShippingPostalCode = text
                    }
                }
            }
        default:
            print("null")
        }
    }
}

extension PaymentCheckoutTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case countryTextField:
            print("it")
            //NotificationCenter.default.post(name: OpenCountryPickerConfirmedNotify, object: "billing")
        default:
            print("textfieldnil")
        }
        return true
    }
}

extension PaymentCheckoutTableViewCell : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch countryTextField.text {
        case "Canada":
            return canadaProvidences.count
        default:
            return states.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch countryTextField.text {
        case "Canada":
            return canadaProvidences[row]
        default:
            return states[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch countryTextField.text {
        case "Canada":
            stateTextField.text = canadaProvidences[row]
        default:
            stateTextField.text = states[row]
        }
    }
    
    func pickerViewToolbar(textField:UITextField, pickerView:UIPickerView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        toolBar.sizeToFit()
//        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
//        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        //let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(dismissKeyboard))
//
//        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        textField.inputView = pickerView
        textField.inputAccessoryView = toolBar
    }
}

//MARK: - Page 4 Shipping
class CheckoutShippingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var shippingTableView: UITableView!
    
    var currentPage = 0
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {

      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {

        // if keyboard size is not available for some reason, dont do anything
        return
      }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        shippingTableView.contentInset = contentInsets
        shippingTableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // move back the root view origin to zero
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        
        // reset back the content inset to zero after keyboard is gone
        shippingTableView.contentInset = contentInsets
        shippingTableView.scrollIndicatorInsets = contentInsets
        contentView.frame.origin.y = 0
    }
    
    override func prepareForReuse() {
        
    }
    
    func funcSetUp(currentPage: Int) {
        shippingTableView.allowsSelection = false
        self.currentPage = currentPage
        dismissKeyboardOnTap()
            print("Shipping")
            shippingTableView.delegate = self
            shippingTableView.dataSource = self
    }
    
    func dismissKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: contentView, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tap)
        shippingTableView.keyboardDismissMode = .onDrag
    }
}

extension CheckoutShippingCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 800
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shippingCheckoutTableViewCell", for: indexPath) as! ShippingCheckoutTableViewCell
        cell.funcSetUp()
        cell.contentView.layer.cornerRadius = 10
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class CheckoutShippingTableView: UITableView {
        override var intrinsicContentSize: CGSize {
            layoutIfNeeded()
            return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
        }
}

class ShippingCheckoutTableViewCell:UITableViewCell {
    
    @IBOutlet weak var textFieldsView: UIView!
    @IBOutlet weak var requiredTextFieldsView: UIView!
    @IBOutlet weak var sameAsBillingCheckBox:BEMCheckBox!
    @IBOutlet weak var companyTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var extAddressTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var stateTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var cityTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var postalCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var streetAddressTextField: SkyFloatingLabelTextField!
    
    let states = ["Alaska", "Alabama", "Arkansas", "American Samoa", "Arizona", "California", "Colorado", "Connecticut", "District of Columbia", "Delaware", "Florida", "Georgia", "Guam", "Hawaii", "Iowa", "Idaho", "Illinois", "Indiana", "Kansas", "Kentucky", "Louisiana", "Massachusetts", "Maryland", "Maine", "Michigan", "Minnesota", "Missouri", "Mississippi", "Montana", "North Carolina", "North Dakota", "Nebraska", "New Hampshire", "New Jersey", "New Mexico", "Nevada", "New York", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Puerto Rico", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Virginia", "Virgin Islands", "Vermont", "Washington", "Wisconsin", "West Virginia", "Wyoming"]
    let canadaProvidences = ["Alberta", "British Columbia", "Manitoba", "New Brunswick", "Newfoundland and Labrador", "Northwest Territories", "Nova Scotia", "Nunavut", "Ontario", "Prince Edward Island", "Quebec", "Saskatchewan", "Yukon Territory"]
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        
    }
    
    
    func funcSetUp() {
        sameAsBillingCheckBox.isEnabled = true
        sameAsBillingCheckBox.isUserInteractionEnabled = true
        textFieldsView.layer.cornerRadius = 10
        requiredTextFieldsView.layer.cornerRadius = 10
        setTextFields()
        if checkoutBillingEqualsShipping {
            sameAsBillingCheckBox.on = true
            setCheckBox()
        }
    }
    
    func setCheckBox() {
        companyTextField.lineColor = .lightGray
        companyTextField.titleColor = .lightGray
        companyTextField.textColor = .lightGray
        if checkoutShippingCompany == "" {
            companyTextField.placeholder = "Company(Optional)"
        } else {
            companyTextField.text = checkoutShippingCompany
        }
        companyTextField.isEnabled = false
        extAddressTextField.lineColor = .lightGray
        extAddressTextField.titleColor = .lightGray
        extAddressTextField.textColor = .lightGray
        if checkoutShippingExtendedAddress == "" {
            extAddressTextField.placeholder = "Apt, Suite, Unit, Building(Optional)"
        } else {
            extAddressTextField.text = checkoutShippingExtendedAddress
        }
        extAddressTextField.isEnabled = false
        firstNameTextField.lineColor = .lightGray
        firstNameTextField.titleColor = .lightGray
        firstNameTextField.textColor = .lightGray
        firstNameTextField.text = checkoutShippingFirstName
        firstNameTextField.isEnabled = false
        lastNameTextField.lineColor = .lightGray
        lastNameTextField.titleColor = .lightGray
        lastNameTextField.textColor = .lightGray
        lastNameTextField.text = checkoutShippingLastName
        lastNameTextField.isEnabled = false
        countryTextField.lineColor = .lightGray
        countryTextField.titleColor = .lightGray
        countryTextField.textColor = .lightGray
        countryTextField.text = checkoutShippingCountryName
        countryTextField.isEnabled = false
        streetAddressTextField.lineColor = .lightGray
        streetAddressTextField.titleColor = .lightGray
        streetAddressTextField.textColor = .lightGray
        streetAddressTextField.isEnabled = false
        streetAddressTextField.text = checkoutShippingStreetAddress
        stateTextField.lineColor = .lightGray
        stateTextField.titleColor = .lightGray
        stateTextField.textColor = .lightGray
        stateTextField.isEnabled = false
        stateTextField.text = checkoutShippingState
        cityTextField.lineColor = .lightGray
        cityTextField.titleColor = .lightGray
        cityTextField.textColor = .lightGray
        cityTextField.isEnabled = false
        cityTextField.text = checkoutShippingCity
        postalCodeTextField.lineColor = .lightGray
        postalCodeTextField.titleColor = .lightGray
        postalCodeTextField.textColor = .lightGray
        postalCodeTextField.isEnabled = false
        postalCodeTextField.text = checkoutShippingPostalCode
    }
    
    @IBAction func checkBoxTapped() {
        
        if sameAsBillingCheckBox.on {
            //sameAsBillingCheckBox.on = false
            checkoutBillingEqualsShipping = true
            companyTextField.lineColor = .lightGray
            companyTextField.titleColor = .lightGray
            companyTextField.textColor = .lightGray
            if checkoutShippingCompany == "" {
                companyTextField.placeholder = "Company(Optional)"
            } else {
                companyTextField.text = checkoutShippingCompany
            }
            companyTextField.isEnabled = false
            extAddressTextField.lineColor = .lightGray
            extAddressTextField.titleColor = .lightGray
            extAddressTextField.textColor = .lightGray
            if checkoutShippingExtendedAddress == "" {
                extAddressTextField.placeholder = "Apt, Suite, Unit, Building(Optional)"
            } else {
                extAddressTextField.text = checkoutShippingExtendedAddress
            }
            extAddressTextField.isEnabled = false
            firstNameTextField.lineColor = .lightGray
            firstNameTextField.titleColor = .lightGray
            firstNameTextField.textColor = .lightGray
            firstNameTextField.text = checkoutShippingFirstName
            firstNameTextField.isEnabled = false
            lastNameTextField.lineColor = .lightGray
            lastNameTextField.titleColor = .lightGray
            lastNameTextField.textColor = .lightGray
            lastNameTextField.text = checkoutShippingLastName
            lastNameTextField.isEnabled = false
            countryTextField.lineColor = .lightGray
            countryTextField.titleColor = .lightGray
            countryTextField.textColor = .lightGray
            countryTextField.text = checkoutShippingCountryName
            countryTextField.isEnabled = false
            streetAddressTextField.lineColor = .lightGray
            streetAddressTextField.titleColor = .lightGray
            streetAddressTextField.textColor = .lightGray
            streetAddressTextField.isEnabled = false
            streetAddressTextField.text = checkoutShippingStreetAddress
            stateTextField.lineColor = .lightGray
            stateTextField.titleColor = .lightGray
            stateTextField.textColor = .lightGray
            stateTextField.isEnabled = false
            stateTextField.text = checkoutShippingState
            cityTextField.lineColor = .lightGray
            cityTextField.titleColor = .lightGray
            cityTextField.textColor = .lightGray
            cityTextField.isEnabled = false
            cityTextField.text = checkoutShippingCity
            postalCodeTextField.lineColor = .lightGray
            postalCodeTextField.titleColor = .lightGray
            postalCodeTextField.textColor = .lightGray
            postalCodeTextField.isEnabled = false
            postalCodeTextField.text = checkoutShippingPostalCode
        } else {
            //sameAsBillingCheckBox.on = true
            checkoutBillingEqualsShipping = false
            companyTextField.lineColor = .white
            companyTextField.titleColor = .white
            companyTextField.textColor = .white
            if checkoutShippingCompany == "" {
                companyTextField.placeholder = "Company(Optional)"
            } else {
                companyTextField.text = checkoutShippingCompany
            }
            companyTextField.isEnabled = true
            extAddressTextField.lineColor = .white
            extAddressTextField.titleColor = .white
            extAddressTextField.textColor = .white
            if checkoutShippingExtendedAddress == "" {
                extAddressTextField.placeholder = "Apt, Suite, Unit, Building(Optional)"
            } else {
                extAddressTextField.text = checkoutShippingExtendedAddress
            }
            extAddressTextField.isEnabled = true
            firstNameTextField.lineColor = .white
            firstNameTextField.titleColor = .white
            firstNameTextField.textColor = .white
            firstNameTextField.text = checkoutShippingFirstName
            firstNameTextField.isEnabled = true
            lastNameTextField.lineColor = .white
            lastNameTextField.titleColor = .white
            lastNameTextField.textColor = .white
            lastNameTextField.text = checkoutShippingLastName
            lastNameTextField.isEnabled = true
            countryTextField.lineColor = .white
            countryTextField.titleColor = .white
            countryTextField.textColor = .white
            countryTextField.text = checkoutShippingCountryName
            countryTextField.isEnabled = true
            streetAddressTextField.lineColor = .white
            streetAddressTextField.titleColor = .white
            streetAddressTextField.textColor = .white
            streetAddressTextField.isEnabled = true
            streetAddressTextField.text = checkoutShippingStreetAddress
            stateTextField.lineColor = .white
            stateTextField.titleColor = .white
            stateTextField.textColor = .white
            stateTextField.isEnabled = true
            stateTextField.text = checkoutShippingState
            cityTextField.lineColor = .white
            cityTextField.titleColor = .white
            cityTextField.textColor = .white
            cityTextField.isEnabled = true
            cityTextField.text = checkoutShippingCity
            postalCodeTextField.lineColor = .white
            postalCodeTextField.titleColor = .white
            postalCodeTextField.textColor = .white
            postalCodeTextField.isEnabled = true
            postalCodeTextField.text = checkoutShippingPostalCode
        }
    }
    
    func setTextFields() {
        emailTextField.errorMessage = "Required"
        phoneTextField.errorMessage = "Required"
        firstNameTextField.errorMessage = "Required"
        lastNameTextField.errorMessage = "Required"
        countryTextField.errorMessage = "Required"
        streetAddressTextField.errorMessage = "Required"
        stateTextField.errorMessage = "Required"
        cityTextField.errorMessage = "Required"
        postalCodeTextField.errorMessage = "Required"
        
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        companyTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        countryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        streetAddressTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        extAddressTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        stateTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cityTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        postalCodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textfield: UITextField) {
        switch textfield {
        case emailTextField:
            if let text = textfield.text {
                if text.count < 3 {
                    emailTextField.errorMessage = "Invalid Email"
                    checkoutCustomerEmail = ""
                } else if text.count > 255 {
                    emailTextField.errorMessage = "Email Character Limit is 255"
                    checkoutCustomerEmail = ""
                } else if text == "" {
                    emailTextField.errorMessage = "Required"
                    checkoutCustomerEmail = ""
                } else if !text.contains("@") {
                    emailTextField.errorMessage = "Invalid Email"
                    checkoutCustomerEmail = ""
                } else if !text.contains(".") {
                    emailTextField.errorMessage = "Invalid Email"
                    checkoutCustomerEmail = ""
                }
                else {
                    emailTextField.errorMessage = ""
                    checkoutCustomerEmail = text
                }
            }
        case phoneTextField:
            if let text = textfield.text {
                if text == "" {
                    phoneTextField.errorMessage = "Required"
                    checkoutCustomerPhone = ""
                }
                else if text.count > 14 {
                    phoneTextField.errorMessage = "Phone Number Character Limit is 14"
                    checkoutCustomerPhone = ""
                }
                else if text.count < 10 {
                    phoneTextField.errorMessage = "Invalid Phone Number"
                    checkoutCustomerPhone = ""
                }
                else {
                    phoneTextField.errorMessage = ""
                    checkoutCustomerPhone = text
                }
            }
        case companyTextField:
            if let text = textfield.text {
                if text.count > 255 {
                    companyTextField.errorMessage = "Company Character Limit is 255"
                    checkoutBillingCompany = ""
                }
                else {
                    companyTextField.errorMessage = ""
                    checkoutBillingCompany = text
                }
            }
        case firstNameTextField:
            if let text = textfield.text {
                if text.count < 2 {
                    firstNameTextField.errorMessage = "Invalid First Name"
                    checkoutBillingFirstName = ""
                } else if text.count > 255 {
                    firstNameTextField.errorMessage = "Last Name Character Limit is 255"
                    checkoutBillingFirstName = ""
                } else if text == "" {
                    firstNameTextField.errorMessage = "Required"
                    checkoutBillingFirstName = ""
                }
                else {
                    firstNameTextField.errorMessage = ""
                    checkoutBillingFirstName = text
                }
            }
        case lastNameTextField:
            if let text = textfield.text {
                if text.count < 2 {
                    lastNameTextField.errorMessage = "Invalid Last Name"
                    checkoutBillingLastName = ""
                } else if text.count > 255 {
                    lastNameTextField.errorMessage = "Last Name Character Limit is 255"
                    checkoutBillingLastName = ""
                } else if text == "" {
                    lastNameTextField.errorMessage = "Required"
                    checkoutBillingLastName = ""
                }
                else {
                    lastNameTextField.errorMessage = ""
                    checkoutBillingLastName = text
                }
            }
        case countryTextField:
            if let text = textfield.text {
                if text == "" {
                    countryTextField.errorMessage = "Required"
                    checkoutBillingCountryName = ""
                }
                else {
                    countryTextField.errorMessage = ""
                    checkoutBillingCountryName = text
                }
            }
        case streetAddressTextField:
            if let text = textfield.text {
                if text == "" {
                    streetAddressTextField.errorMessage = "Required"
                    checkoutBillingStreetAddress = ""
                } else if text.count > 255 {
                    streetAddressTextField.errorMessage = "Address Character Limit is 255"
                    checkoutBillingStreetAddress = ""
                }
                else {
                    streetAddressTextField.errorMessage = ""
                    checkoutBillingStreetAddress = text
                }
            }
        case extAddressTextField:
            if let text = textfield.text {
                if text.count > 255 {
                    extAddressTextField.errorMessage = "Extended Address Character Limit is 255"
                    checkoutBillingExtendedAddress = ""
                }
                else {
                    extAddressTextField.errorMessage = ""
                    checkoutBillingExtendedAddress = text
                }
            }
        case cityTextField:
            if let text = textfield.text {
                if text == "" {
                    cityTextField.errorMessage = "Required"
                    checkoutBillingCity = ""
                }
                else if text.count > 255 {
                    cityTextField.errorMessage = "City Character Limit is 255"
                    checkoutBillingCity = ""
                }
                else {
                    cityTextField.errorMessage = ""
                    checkoutBillingCity = text
                }
            }
        case stateTextField:
            if let text = textfield.text {
                if text == "" {
                    stateTextField.errorMessage = "Required"
                    checkoutBillingState = ""
                }
                else if text.count > 255 {
                    stateTextField.errorMessage = "State Character Limit is 255"
                    checkoutBillingState = ""
                }
                else {
                    stateTextField.errorMessage = ""
                    checkoutBillingState = text
                }
            }
        case postalCodeTextField:
            if let text = textfield.text {
                if text == "" {
                    postalCodeTextField.errorMessage = "Required"
                    checkoutBillingPostalCode = ""
                }
                else if text.count > 9 {
                    postalCodeTextField.errorMessage = "Postal Code Character Limit is 9"
                    checkoutBillingPostalCode = ""
                }
                else if text.count < 4 {
                    postalCodeTextField.errorMessage = "Invalid Postal Code"
                    checkoutBillingPostalCode = ""
                }
                else {
                    postalCodeTextField.errorMessage = ""
                    checkoutBillingPostalCode = text
                }
            }
        default:
            print("null")
        }
    }
}


//MARK: - Page 5 Confirm
class CheckoutConfirmCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var confirmTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextLabel: UILabel!
    
    var currentPage = 0
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        backButton.isHidden = false
        nextButton.isHidden = false
        nextLabel.text = ""
        nextButton.isEnabled = true
        nextButton.backgroundColor = Constants.Colors.redApp
        nextButton.setTitleColor(.white, for: .normal)
    }
    
    func funcSetUp(currentPage: Int) {
        
        self.currentPage = currentPage
        nextButton.layer.cornerRadius = 7
        backButton.layer.cornerRadius = 7
        
            confirmTableView.delegate = self
            confirmTableView.dataSource = self
            print("confirm purchase")
            nextButton.isHidden = true
            backButton.isHidden = false
    }
    
    @IBAction func NextButtonTapped(_ sender: Any) {
            NotificationCenter.default.post(name: NextCheckoutPAgeNotify, object: nil)
        
    }
    
    @IBAction func PreviousButtonTapped(_ sender: Any) {
            NotificationCenter.default.post(name: PreviousCheckoutPAgeNotify, object: nil)
    }
}

extension CheckoutConfirmCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 175
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCheckoutTableViewCell", for: indexPath) as! PaymentCheckoutTableViewCell
//        cell.funcSetUp()
//        cell.contentView.layer.cornerRadius = 10
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class CheckoutConfirmTableView: UITableView {
        override var intrinsicContentSize: CGSize {
            layoutIfNeeded()
            return CGSize(width: UIView.noIntrinsicMetric, height: self.contentSize.height)
        }
}














