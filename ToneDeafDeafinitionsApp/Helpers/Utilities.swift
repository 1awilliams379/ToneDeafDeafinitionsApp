//
//  Utilities.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 7/26/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//

import Foundation
import UIKit
import NotificationBannerSwift
import TTGSnackbar
import SystemConfiguration
import AVFoundation

class Utilities {
    
    static let shared = Utilities()
    
    //Textfields
    static func styleTextField(_ textfield:UITextField) {
    
        
        //Remove Border
        textfield.borderStyle = .none
        
        textfield.backgroundColor = .none
        
        textfield.textColor = UIColor.white
        
        //textfield.setPadding()
        
        textfield.tintColor = .white
        
    }
    
    //Buttons
    static func styleFilledButton(_ button:UIButton) {
        
        //filled rounded corner style
        button.backgroundColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        button.layer.cornerRadius = 10.0
        button.tintColor = UIColor.white
        
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        //Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1).cgColor
        button.layer.cornerRadius = 10.0
        button.tintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
    }
    
    static func isPasswordValid(_ password : String) -> Bool{
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    
    // Banners
    static func showError(_ title:String, error:String)
    {
        let banner = NotificationBanner(title: title,
                                        subtitle: "Error: " + error,
                                        style: .warning,
                                        colors: nil)
        banner.show(queuePosition: .front, bannerPosition: .bottom, queue: .default, on: nil)
    }
    
    static func showError2(_ error:String, actionText:String) {
        let snackbar = TTGSnackbar(
            message: error,
            duration: .middle,
            actionText: actionText,
            actionBlock: { (snackbar) in
                snackbar.dismiss()
                
            }
        )
        snackbar.leftMargin = 10
        snackbar.rightMargin = 10
        snackbar.bottomMargin = 10
        snackbar.cornerRadius = 5
        snackbar.messageTextColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        snackbar.actionTextColor = .white
        snackbar.animationType = .slideFromRightToLeft
        snackbar.backgroundColor = .black
        snackbar.icon = UIImage(named: "error")
        snackbar.iconTintColor = UIColor.init(red: 182/255, green: 0/255, blue: 3/255, alpha: 1)
        snackbar.show()
    }
    
    static func successBanner(_ message:String) {
        let snackbar = TTGSnackbar(message: message,
                                   duration: .middle)
        snackbar.leftMargin = 10
        snackbar.rightMargin = 10
        snackbar.bottomMargin = 10
        snackbar.cornerRadius = 5
        snackbar.animationType = .slideFromRightToLeft
        snackbar.messageTextColor = .white
        snackbar.backgroundColor = .black
        snackbar.icon = UIImage(named: "ok")
        snackbar.iconTintColor = .systemGreen
        snackbar.show()
    }
    
    static func successBarBanner(_ message:String) {
        let snackbar = TTGSnackbar(message: message,
                                   duration: .middle)
        snackbar.leftMargin = 10
        snackbar.rightMargin = 10
        snackbar.bottomMargin = 50
        snackbar.animationType = .slideFromRightToLeft
        snackbar.cornerRadius = 5
        snackbar.messageTextColor = .white
        snackbar.backgroundColor = .black
        snackbar.icon = UIImage(named: "ok")
        snackbar.iconTintColor = .systemGreen
        snackbar.show()
    }
    
    func setUserinDefaults(user:UserData, completion: @escaping (() -> Void)) {
        do {
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
            UserDefaults.standard.set(encodedData, forKey: "currentUser")
        } catch  {
            fatalError()
        }
    }
    
    func getUserFromDefaults(completion: @escaping ((UserData) -> Void)) {
        let decoded  = UserDefaults.standard.object(forKey: "currentUser") as! Data
        do {
            let decodedTeams = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as! UserData
            completion(decodedTeams)
        }catch {
            fatalError()
        }
    }
    
    func checkBookFileExists(withLink link: String, completion: @escaping ((_ filePath: URL)->Void)){
    let urlString = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    if let url  = URL.init(string: urlString ?? ""){
        let fileManager = FileManager.default
        if let documentDirectory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create: false){

            let filePath = documentDirectory.appendingPathComponent(url.lastPathComponent, isDirectory: false)

            do {
                if try filePath.checkResourceIsReachable() {
                    player = try AVAudioPlayer(data: Data(contentsOf: url))
                    print("file exist")
                    completion(url)

                } else {
                    print("file doesnt exist")
                    downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
                }
            } catch {
                print("file doesnt exist")
                downloadFile(withUrl: url, andFilePath: filePath, completion: completion)
            }
        }else{
             print("file doesnt exist")
        }
    }else{
            print("file doesnt exist")
    }
    }
    
    func downloadFile(withUrl url: URL, andFilePath filePath: URL, completion: @escaping ((_ filePath: URL)->Void)){
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data.init(contentsOf: url)
                player = try AVAudioPlayer(data: Data(contentsOf: url))
                print("saved at \(filePath.absoluteString)")
                DispatchQueue.main.async {
                    completion(url)
                }
            } catch {
                print("an error happened while downloading or saving the file")
            }
        }
    }

}

extension UICollectionView {
    func scrollToNextItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x + self.bounds.size.width))
        guard contentOffset <= self.contentSize.width - self.bounds.size.width else { return }
        self.moveToFrame(contentOffset: contentOffset)
        self.reloadData()
    }

    func scrollToPreviousItem() {
        let contentOffset = CGFloat(floor(self.contentOffset.x - self.bounds.size.width))
        self.moveToFrame(contentOffset: contentOffset)
        self.reloadData()
    }

    func moveToFrame(contentOffset : CGFloat) {
        self.setContentOffset(CGPoint(x: contentOffset, y: self.contentOffset.y), animated: true)
    }
}

extension UIImageView {
    func setImage(from url: URL, withPlaceholder placeholder: UIImage? = nil) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
            self.image = cachedImage
            }
        } else {
            DispatchQueue.main.async {
            self.image = placeholder
            }
            URLSession.shared.dataTask(with: url) {(data, _, _) in
                if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }.resume()
        }
    }
}

extension UIScrollView {

    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }

    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }

    var isBouncing: Bool {
        return isBouncingTop || isBouncingBottom
    }
    
    var isBouncingTop: Bool {
        return contentOffset.y < topInsetForBouncing - contentInset.top
    }
    
    var isBouncingBottom: Bool {
        let threshold: CGFloat
        if contentSize.height > frame.size.height {
            threshold = (contentSize.height - frame.size.height + contentInset.bottom + bottomInsetForBouncing)
        } else {
            threshold = topInsetForBouncing
        }
        return contentOffset.y > threshold
    }
    
    private var topInsetForBouncing: CGFloat {
        return safeAreaInsets.top != 0.0 ? -safeAreaInsets.top : 0.0
    }
    
    private var bottomInsetForBouncing: CGFloat {
        return safeAreaInsets.bottom
    }
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
    // Bonus: Scroll to bottom
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
        }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}



public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPhone12,8":                              return "iPhone SE (2nd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}

extension UITextField{
    func setPadding(){
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = .always
    }

}

extension Notification.Name {
    static let didLogInNotification = Notification.Name("didLogInNotification")
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}

func tapScale(xview: UIView) {
    UIView.animate(withDuration: 0.05,
        animations: {
            xview.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.05) {
                xview.transform = CGAffineTransform.identity
            }
        })
}

func tapScale(cell: UICollectionViewCell, down: Bool) {
    UIView.animate(withDuration: 0.05,delay: 0.0, options: .allowUserInteraction, animations: {
        if down {
            cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
        else {
            cell.transform = .identity
        }
    }, completion: nil)
}

func tapScale(button: UIButton) {
    UIView.animate(withDuration: 0.05,
        animations: {
            button.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.05) {
                button.transform = CGAffineTransform.identity
            }
        })
}

extension UIButton {
    func startAnimatingPressActions() {
        addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
    }
    
    @objc private func animateDown(sender: UIButton) {
        animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.95, y: 0.95))
    }
    
    @objc private func animateUp(sender: UIButton) {
        animate(sender, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
                       }, completion: nil)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension String {
    
    func trimTrailingWhiteSpace() -> String {
        guard self.last == " " else { return self }
        
        var tmp = self
        repeat {
            tmp = String(tmp.dropLast())
        } while tmp.last == " "
        
        return tmp
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
    
    func getImage(completion: @escaping ((UIImage) -> Void)) {
        if let cachedImage = imageCache.object(forKey: self.absoluteString as NSString) {
            completion(cachedImage)
            return
        } else {
            URLSession.shared.dataTask(with: self) {(data, res, err) in
                if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: self.absoluteString as NSString)
                    completion(image)
                    return
                } else {
                    if let error = err {
                        DispatchQueue.main.async {
                            Utilities.showError2("Failed to get image for url: \(self.absoluteString). WITH ERROR: \(error)", actionText: "OK")
                        }
                        return
                    } else {
                        DispatchQueue.main.async {
                            Utilities.showError2("Failed to get image for url: \(self.absoluteString). WITH Respone: \(res.debugDescription)", actionText: "OK")
                        }
                        return
                    }
                }
            }.resume()
        }
    }
}

func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

    let scale = newWidth / image.size.width
    let newHeight = image.size.height * scale
    UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
    image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}

extension UIViewController {
    var previousViewController: UIViewController? {
        guard let navigationController = navigationController else { return nil }
        let count = navigationController.viewControllers.count
        return count < 2 ? nil : navigationController.viewControllers[count - 2]
    }
}

class CopyableLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }
    
    func sharedInit() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.showMenu)))
    }
    
    @objc func showMenu(sender: AnyObject?) {
        self.becomeFirstResponder()
        
        let menu = UIMenuController.shared
        
        if !menu.isMenuVisible {
            menu.setTargetRect(bounds, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        
        board.string = text
        
        let menu = UIMenuController.shared
        
        menu.setMenuVisible(false, animated: true)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
}

class DeepCopier {
    //Used to expose generic
    static func Copy<T:Codable>(of object:T) -> T?{
       do{
           let json = try JSONEncoder().encode(object)
           return try JSONDecoder().decode(T.self, from: json)
       }
       catch let error{
           print(error)
           return nil
       }
    }
}

extension Bool {
    var intValue: Int {
        return self ? 1 : 0
    }
}

extension Int {
    var boolValue: Bool {
        return self != 0
    }
}

extension Dictionary where Key == String {
    func removeNullsFromDictionary() -> Self {
        var destination = Self()
        for key in self.keys {
            guard !(self[key] is NSNull) else { destination[key] = nil; continue }
            guard !(self[key] is Self) else { destination[key] = (self[key] as! Self).removeNullsFromDictionary() as? Value; continue }
            guard self[key] is [Value] else { destination[key] = self[key]; continue }

            let orgArray = self[key] as! [Value]
            var destArray: [Value] = []
            for item in orgArray {
                guard let this = item as? Self else { destArray.append(item); continue }
                destArray.append(this.removeNullsFromDictionary() as! Value)
            }
            destination[key] = destArray as? Value
        }
        return destination
    }
    
    
    
    
}

extension Dictionary {
  func contains(key: Key) -> Bool {
    self.index(forKey: key) != nil
  }
}
