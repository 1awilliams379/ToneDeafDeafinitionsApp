//
//  AdminDashboardNavigationController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/13/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AdminDashboardNavigationController: UINavigationController {
    var spinnerDim:UIView!
    var spinner:NVActivityIndicatorView! 

    override func viewDidLoad() {
        super.viewDidLoad()
//        let screenSize: CGRect = UIScreen.main.bounds
//        spinnerDim = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
//        spinnerDim.backgroundColor = .black
//        spinnerDim.alpha = 0.85
//        spinnerDim.isHidden = true
//        self.view.addSubview(spinnerDim)
        
//        spinner = NVActivityIndicatorView(frame: CGRect(x: spinnerDim.center.x-25, y: spinnerDim.center.y-25, width: 50, height: 50), type: .circleStrokeSpin, color: Constants.Colors.redApp, padding: 0)
//        spinnerDim.addSubview(spinner)
        
        createObservers()
//        NotificationCenter.default.post(name: adminDashboardStartSpinnerNotify, object: nil)
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showSpinner(notificantion:)), name: adminDashboardStartSpinnerNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideSpinner(notificantion:)), name: adminDashboardStopSpinnerNotify, object: nil)
    }
    

    @objc func showSpinner(notificantion:Notification) {
        let screenSize: CGRect = UIScreen.main.bounds
        spinnerDim = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        spinnerDim.backgroundColor = .black
        spinnerDim.alpha = 0.85
//        spinnerDim.isHidden = true
        self.view.addSubview(spinnerDim)
        
        spinner = NVActivityIndicatorView(frame: CGRect(x: spinnerDim.center.x-25, y: spinnerDim.center.y-25, width: 50, height: 50), type: .circleStrokeSpin, color: Constants.Colors.redApp, padding: 0)
        spinnerDim.addSubview(spinner)
        spinnerDim.isHidden = false
        
        spinner.startAnimating()
        
        spinnerDim.isHidden = false
        
        spinner.startAnimating()
    }
    
    @objc func hideSpinner(notificantion:Notification) {
        if spinnerDim != nil {
            spinnerDim.removeFromSuperview()
            spinnerDim.isHidden = true
            spinner.stopAnimating()
        }
    }

}
