//
//  Extensions.swift
//  Marvelicious
//
//  Created by Gaurang Lathiya on 15/05/19.
//  Copyright © 2019 Gaurang Lathiya. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIViewController {
    
    func getNavigationBarHeight() -> CGFloat {
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        var navBarHeight: CGFloat = 44.0
        if let navcontroller = self.navigationController {
            navBarHeight = navcontroller.navigationBar.frame.height
        }
        return statusBarHeight + navBarHeight
    }
    
    func topMostViewController() -> UIViewController {
        // Handling Modal views
        if let presentedViewController = self.presentedViewController {
            return presentedViewController.topMostViewController()
        }
            // Handling UIViewController's added as subviews to some other views.
        else {
            for view in self.view.subviews
            {
                // Key property which most of us are unaware of / rarely use.
                if let subViewController = view.next {
                    if subViewController is UIViewController {
                        let viewController = subViewController as! UIViewController
                        return viewController.topMostViewController()
                    }
                }
            }
            return self
        }
    }
    
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let uiAlertController = UIAlertController(
                title: title,
                message: message,
                preferredStyle:.alert)
            
            uiAlertController.addAction(
                UIAlertAction.init(title: Constants.kAlertTypeOK, style: .default, handler: { (UIAlertAction) in
                    uiAlertController.dismiss(animated: true, completion: nil)
                }))
            self.topMostViewController().present(uiAlertController, animated: true, completion: nil)
        }
    }
    
    func setAppThemeNavigationBar() {
        // Common setting for transparent navigation bar
        UINavigationBar.appearance().barTintColor = UIColor.white
        // Set button color
        UINavigationBar.appearance().tintColor = UIColor.black
    }
    
    func setTransparentNavigationBar() {
        // Common setting for transparent navigation bar
        UINavigationBar.appearance().barTintColor = UIColor.clear
        // Set button color
        UINavigationBar.appearance().tintColor = UIColor.white
    }
}

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UIImageView {
    
    public func setImageKingFisher(forImgURL urlImg: URL, placeHolder: UIImage?, imgSize: CGSize = CGSize(width: 250, height: 250)) {
        let resource = ImageResource.init(downloadURL: urlImg)
        let processor = ResizingImageProcessor.init(referenceSize: imgSize, mode: .aspectFill)
        let processorRound = RoundCornerImageProcessor(cornerRadius: 5.0)
        
        self.kf.setImage(with: resource, placeholder: placeHolder, options: [.processor(processor), .processor(processorRound)], progressBlock: nil) { _ in
        }
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        //RESOLVED CRASH HERE
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}
