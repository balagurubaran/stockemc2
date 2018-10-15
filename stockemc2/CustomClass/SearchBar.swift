//
//  SampleXib.swift
//  sampleDelegate
//
//  Created by Balagurubaran Kalingarayan on 1/13/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import UIKit


@objc protocol SearchBarDelegate: class {
    func searchBardEndEditing(searchString:String)
    func searchBarClosed()
}

class SearchBar: UIView,UISearchBarDelegate {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var buttonActionDelegate: SearchBarDelegate?
    var windowSize:CGSize = CGSize.zero
    static var isVisible = false;
    static var isSearchBarLifeTime = false;
    @IBOutlet weak var searchBarObj: UISearchBar!
    // other outlets
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
    }
    

    func resize(view:UIView){
        let size = CGSize.init(width: windowSize.width * 0.95, height: view.frame.size.height)
        view.frame = CGRect.init(origin: CGPoint.init(x: (windowSize.width - size.width)/2, y: -windowSize.height * 0.3), size: size)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    static func showSearchBar(){
        SearchBar.isSearchBarLifeTime = true
        let currentCOntroller = UIWindow.visibleViewController()
        let xibView = self.loadFromXib(fileName: "SearchBar") as! SearchBar
    
        xibView.buttonActionDelegate = currentCOntroller as? SearchBarDelegate
        
        xibView.windowSize = UIScreen.main.bounds.size
        xibView.resize(view: xibView)
        isVisible = true
        xibView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        xibView.searchBarObj.delegate = xibView
        xibView.searchBarObj.becomeFirstResponder()

        currentCOntroller?.view.addSubview(xibView)
        
        UIView.animate(withDuration: 1) {
            xibView.frame.origin.y = xibView.frame.size.height - xibView.frame.size.height + 20
            xibView.layoutIfNeeded()
        }
//
//        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {() -> Void in
//            //primaryConstraint.constant = 0
//            xibView.frame.origin.y = xibView.frame.size.height
//            xibView.layoutIfNeeded()
//        }) { _ in }
        
        xibView.searchBarObj.delegate = xibView
        xibView.dropShadow()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        buttonActionDelegate?.searchBardEndEditing(searchString: searchBar.text!)
        SearchBar.isSearchBarLifeTime = true
        SearchBar.isVisible = false

        self.removeFromSuperview()
        //searchBarCancelButtonClicked(searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        SearchBar.isVisible = false
         buttonActionDelegate?.searchBarClosed()
        self.removeFromSuperview()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    @objc func willEnterForeground() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            SearchBar.isVisible = false
            self.buttonActionDelegate?.searchBarClosed()
            self.removeFromSuperview()
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchBar.text = searchText.uppercased()
//        if(searchText.count > 0){
//            buttonActionDelegate?.searchBardEndEditing(searchString: searchBar.text!)
//        }
    }
    
}

public extension UIView
{
    static func loadFromXib<T>(fileName:String, withOwner: Any? = nil, options: [AnyHashable : Any]? = nil) -> T where T: UIView
    {
        let bundle = Bundle.main
        let nib = bundle.loadNibNamed(fileName, owner: withOwner, options: options as? [UINib.OptionsKey : Any])//UINib(nibName: fileName, bundle: bundle)
        
        guard let view = nib?.first as? T else {
            fatalError("Could not load view from nib file.")
        }
        return view
    }
    
    static func loadNib(fileName:String) -> UIView {
        let bundle = Bundle.main
        //let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: fileName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

extension UIWindow {
    
    
    class func visibleViewController() -> UIViewController? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let rootViewController: UIViewController  = (appDelegate.window?.rootViewController)! {
            return UIWindow.getVisibleViewControllerFrom(controller: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(controller:UIViewController) -> UIViewController {
        
        if let navigationController = controller as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(controller: navigationController.visibleViewController!)
            
        } else if let tabController = controller as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(controller:tabController.selectedViewController!)
            
        } else if let presented = controller.presentedViewController {
            return UIWindow.getVisibleViewControllerFrom(controller:presented)
            
        } else {
            
            return controller;
        }
    }
}

