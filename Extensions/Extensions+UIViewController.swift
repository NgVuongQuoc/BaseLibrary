//
//  Extensions+UIViewController.swift
//  InternalSports
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//


import Foundation
//import Lightbox
import ProgressHUD

public extension UIViewController {
    @available(iOS 13.0, *)
    public func getStatusBarHeight() -> CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    public func addLeftButton(image: UIImage, style: UIBarButtonItem.Style, action: Selector?) {
        let btn = UIBarButtonItem(image: image, style: style, target: self, action: action)
        navigationItem.leftBarButtonItem = btn
    }
    
    public func addLeftButton(text: String, style: UIBarButtonItem.Style, action: Selector?) {
        let leftButton = UIBarButtonItem(title: text, style: style, target: self, action: action)
        navigationItem.leftBarButtonItem = leftButton
    }
    
    public func addRightButton(image: UIImage, style: UIBarButtonItem.Style, action: Selector?) {
        let rightButton = UIBarButtonItem(image: image, style: style, target: self, action: action)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    public func addRightButton(text: String, style: UIBarButtonItem.Style, action: Selector?) {
        let rightButton = UIBarButtonItem(title: text, style: style, target: self, action: action)
        navigationItem.rightBarButtonItem = rightButton
    }
    
    public class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
//    public func goToIntroVC(images: [LightboxImage]) {
//        let controller = LightboxController(images: images)
//        controller.dynamicBackground = true
//
//        present(controller, animated: true, completion: nil)
//    }
    
    public func addDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
        
    @objc public func dismissKeyboardTouchOutside() {
        view.endEditing(true)
    }
    
    public func showAlert(title: String?, content: String?, callback: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: content, preferredStyle: UIAlertController.Style.alert)
        
        if let callBack = callback {
            let defaultAction = UIAlertAction.init(title: "Ok", style: .default, handler: { (action) in
                callBack()
            })
            alert.addAction(defaultAction)
        } else {
            let defaultAction = UIAlertAction.init(title: "Ok", style: .default, handler: nil)
            alert.addAction(defaultAction)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showAlert(title: String?, message: String?,
                   btnLeft: String?, actionLeft: (() -> ())?,
                   btnRight: String?, actionRight: (() -> ())? ) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if let titleLeft = btnLeft {
            let leftAction = UIAlertAction(title: titleLeft, style: titleLeft == "Cancel" ? .cancel : .default) { (_) in
                // Check action left is availabel
                if actionLeft != nil {
                    actionLeft!()
                }
                
            }
            alert.addAction(leftAction)
        }

        if let titleRight = btnRight {
            let rightAction = UIAlertAction(title: titleRight, style: titleRight == "Delete" ? .destructive : .default) { (_) in
                // Check action right is availabel
                if actionRight != nil {
                    actionRight!()
                }
            }
            alert.addAction(rightAction)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func showAlertTF(title: String?, message: String?, placeholderText: String, completion: @escaping((String) -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addTextField { tf in
            tf.placeholder = placeholderText
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { _ in
            if let tf = alert.textFields?.first {
                completion(tf.text ?? "")
            } else {
                completion("")
            }
        }))
        present(alert, animated: true)
    }
    
    public func showToastSuccess(message: String?) {
        ProgressHUD.colorStatus = UIColor(hex: "#CDA993")
        ProgressHUD.fontStatus = .mediumWith(16)
        ProgressHUD.showSucceed(message)
    }
    
    public func showToastError(message: String?) {
        ProgressHUD.colorStatus = UIColor(hex: "#F03738")
        ProgressHUD.fontStatus = .mediumWith(16)
        ProgressHUD.showFailed(message)
    }
    
    public func showRedWarning(errMessage: String) {
        ProgressHUD.showError(errMessage)
    }
    
    public func showGreenWarning(successMes: String?) {
        ProgressHUD.showSuccess(successMes)
    }
    
    public func showLoading(){
        ProgressHUD.animationType = .circleStrokeSpin
//        ProgressHUD.colorHUD = UIColor(hex: "#CDA993")
        ProgressHUD.colorAnimation = UIColor(hex: "#CDA993")
        ProgressHUD.show(nil, interaction: false)
    }
    
    public func hideLoading(){
        ProgressHUD.dismiss()
    }
    
    public func showLoading(percent: CGFloat) {
        ProgressHUD.showProgress(percent)
    }
    
    public func goToURL(urlString: String) {
        guard let url = URL(string: urlString) else {
          return
        }

        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            showToastError(message: "Cannot open this url!!!")
        }
    }
    
    public func popupShareView(text: Any?, images: [UIImage]?) {
        if let text = text,
           let image = images {
            DispatchQueue.main.async {
                let activityVC = UIActivityViewController(activityItems: [text, image] , applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                activityVC.popoverPresentationController?.permittedArrowDirections = []
                self.present(activityVC, animated: true, completion: nil)
            }
        } else if let text = text {
            DispatchQueue.main.async {
                let activityVC = UIActivityViewController(activityItems: [text] , applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                activityVC.popoverPresentationController?.permittedArrowDirections = []
                self.present(activityVC, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                if let image = images {
                    let activityVC: UIActivityViewController = UIActivityViewController(activityItems: image, applicationActivities: nil)
                    activityVC.popoverPresentationController?.sourceView = self.view
                    activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    activityVC.popoverPresentationController?.permittedArrowDirections = []
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    public func popupShareView(text: Any?, image: UIImage?){
        if let text = text,
           let image = image {
            DispatchQueue.main.async {
                let activityVC = UIActivityViewController(activityItems: [image, text] , applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                activityVC.popoverPresentationController?.permittedArrowDirections = []
                self.present(activityVC, animated: true, completion: nil)
            }
        } else if let text = text {
            DispatchQueue.main.async {
                let activityVC = UIActivityViewController(activityItems: [text] , applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                activityVC.popoverPresentationController?.permittedArrowDirections = []
                self.present(activityVC, animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.async {
                if let image = image {
                    let activityVC: UIActivityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                    activityVC.popoverPresentationController?.sourceView = self.view
                    activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    activityVC.popoverPresentationController?.permittedArrowDirections = []
                    self.present(activityVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    public func popupShareView(_ items: Any) {
        DispatchQueue.main.async {
            let activityVC: UIActivityViewController = UIActivityViewController(activityItems: [items], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            activityVC.popoverPresentationController?.permittedArrowDirections = []
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    public func actionSharePopup(viewController: UIViewController, items: [Any], completion: (() -> Void)? = nil) {
        let activityViewController = UIActivityViewController(activityItems: items,
                                                              applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (_, _, _, _) in
            completion?()
        }
        if IS_IPAD,
            let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX,
                                                  y: viewController.view.bounds.midY,
                                                  width: 0,
                                                  height: 0)
            popoverController.permittedArrowDirections = []
        }
        viewController.present(activityViewController, animated: true, completion: nil)
    }

}
