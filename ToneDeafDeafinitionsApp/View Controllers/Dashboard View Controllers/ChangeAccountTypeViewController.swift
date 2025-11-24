//
//  ChangeAccountTypeViewController.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 6/20/22.
//  Copyright © 2022 GITEM Solutions. All rights reserved.
//

import UIKit
import CDAlertView

class ChangeAccountTypeViewController: UIViewController {
    
    @IBOutlet weak var loseGainTableView: UITableView!
    @IBOutlet weak var loseGainLAbel: UILabel!
    @IBOutlet weak var upDownLAbel: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var blurGradient: UIView!
    @IBOutlet weak var submitButton: UIButton!
    var backgroundImageView:UIImageView!
    
    var downarr:[String] = ["Pull", "Up", "Sideways", "On", "Em"]
    var uparr:[String] = ["Put", "You", "Down", "Clown"]
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBack()
        loseGainTableView.delegate = self
        loseGainTableView.dataSource = self
        loseGainTableView.estimatedRowHeight = 60.0
        loseGainTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableViewHeightConstraint.constant = loseGainTableView.contentSize.height
    }
    
    func setBack() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
          self.navigationController?.navigationBar.shadowImage = UIImage()
          self.navigationController?.navigationBar.isTranslucent = true
        blurGradient.backgroundColor = .clear
        background.layer.masksToBounds = true
        background.skeletonCornerRadius = 5
        blurGradient.layer.cornerRadius = 5
        let gradient = CAGradientLayer()
        gradient.frame = blurGradient.frame
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.0, 1.0]
        blurGradient.layer.insertSublayer(gradient, at: 0)
        background.addSubview(blurGradient)
        background.sendSubviewToBack(blurGradient)
        let blur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = blurGradient.frame
        let gradient2 = CAGradientLayer()
        gradient2.frame = blurGradient.frame
        gradient2.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient2.locations = [0, 1]
        blurView.layer.insertSublayer(gradient2, at: 1)
        background.addSubview(blurView)
        background.sendSubviewToBack(blurView)
        submitButton.layer.cornerRadius = 7
        blurredBackground(videoCellView: background)
        
        switch currentAppUser.accountType {
        case CreatorAccount:
            submitButton.setTitle("Downgrade To Listener Account", for: .normal)
            upDownLAbel.text = "Downgrade"
            headerImage.image = UIImage(named: "trending-down")
            loseGainLAbel.text = "What You Will Lose"
            
        default:
            submitButton.setTitle("Request Upgrade To Creator Account", for: .normal)
            upDownLAbel.text = "Upgrade"
            headerImage.image = UIImage(named: "chevrons-up")
            loseGainLAbel.text = "What You Will Gain"
        }
        
    }
    
    func blurredBackground(videoCellView: UIView) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: videoCellView.bounds.width, height: videoCellView.bounds.height))
            videoCellView.addSubview(strongSelf.backgroundImageView)
                strongSelf.backgroundImageView.image = UIImage(named: "tonedeaflogo")
            strongSelf.backgroundImageView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
            videoCellView.roundCorners(corners: [.topLeft,.topRight], radius: 10)
            videoCellView.addSubview(strongSelf.backgroundImageView)
            videoCellView.sendSubviewToBack(strongSelf.backgroundImageView)
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        switch currentAppUser.accountType {
        case CreatorAccount:
            let alerticon = UIImage(named: "trending-down")!.copy(newSize: CGSize(width: 40, height: 40))
            let actionSheet = CDAlertView(title: "Downgrade Account",
                                          message: "Are you sure you want to Downgrade to a Listener Account?", type: .custom(image: alerticon!.withTintColor(.white)))
            actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
            actionSheet.circleFillColor = .black
            actionSheet.titleTextColor = .white
            actionSheet.messageTextColor = .white
            actionSheet.add(action: CDAlertViewAction(title: "No", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
            actionSheet.add(action: CDAlertViewAction(title: "Downgrade", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                DatabaseManager.shared.downgradeAccountToListener(completion: {[weak self] result in
                    //guard let strongSelf = self else {return}
                    ViewController.shared.transitionToDashboard()
                })
                return true
            }))
            NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
        default:
            let alerticon = UIImage(named: "chevrons-up")!.copy(newSize: CGSize(width: 40, height: 40))
            let actionSheet = CDAlertView(title: "Upgrade Account",
                                          message: "Are you sure you want to Upgrade to a Creator Account?", type: .custom(image: alerticon!.withTintColor(.white)))
            actionSheet.alertBackgroundColor = Constants.Colors.mediumApp
            actionSheet.circleFillColor = .black
            actionSheet.titleTextColor = .white
            actionSheet.messageTextColor = .white
            actionSheet.add(action: CDAlertViewAction(title: "No", font: UIFont.systemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: nil))
            actionSheet.add(action: CDAlertViewAction(title: "Upgrade", font: UIFont.boldSystemFont(ofSize: 16), textColor: Constants.Colors.redApp, backgroundColor: Constants.Colors.mediumApp, handler: { _ in
                DatabaseManager.shared.upgradeAccountToCreator(completion: {[weak self] result in
                    //guard let strongSelf = self else {return}
                    ViewController.shared.transitionToDashboard()
                })
                return true
            }))
            NotificationCenter.default.post(name: OpenTheAlertNotify, object: actionSheet)
        }
    }
    
}

extension ChangeAccountTypeViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentAppUser.accountType {
        case CreatorAccount:
            return downarr.count
        default:
            return uparr.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = loseGainTableView.dequeueReusableCell(withIdentifier: "changeAccLoseGainTableViewCellController", for: indexPath) as! ChangeAccLoseGainTableViewCellController
        switch currentAppUser.accountType {
        case CreatorAccount:
            cell.setTemp(what: downarr[indexPath.row])
        default:
            cell.setTemp(what: uparr[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
    
}

class ChangeAccLoseGainTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

class ChangeAccLoseGainTableViewCellController: UITableViewCell {
    

    @IBOutlet weak var textLabelCell: UILabel!
    @IBOutlet weak var blip: UIImageView!
    
    override func prepareForReuse() {
        
    }
    
    func setTemp(what: String) {
        textLabelCell.lineBreakMode = .byWordWrapping
        textLabelCell.numberOfLines = 0
        blip.tintColor = Constants.Colors.redApp
        switch what {
        case "Pull":
            textLabelCell.text = "I trusted my niggas, they never betrayed me Met all these niggas, they sweeter than Sadie"
        case "Up":
            textLabelCell.text = "I trusted my niggas, they never betray"
        case "Sideways":
            textLabelCell.text = "I trusted my niggas, tsdavfhjshey never betrayed me Me"
        case "On":
            textLabelCell.text = "I trusted my niggas, they never betrayed me Met all these niggas, they sweeter than Sadie t all these niggas, they sweeter than Sadie"
        case "Em":
            textLabelCell.text = "I trusted my niggas, they never betrayed me Me"
        default:
            print("hajdsfgvbjsvh")
        }
        
    }
    
}
