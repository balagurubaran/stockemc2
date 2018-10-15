//
//  UIWindow+helper.swift
//  stockemc2
//
//  Created by Balagurubaran Kalingarayan on 10/13/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        switch(vc){
        case is UINavigationController:
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
            break;
            
        case is UITabBarController:
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
            break;
            
        default:
            if let presentedViewController = vc.presentedViewController {
                //print(presentedViewController)
                if let presentedViewController2 = presentedViewController.presentedViewController {
                    return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController2)
                }
                else{
                    return vc;
                }
            }
            else{
                return vc;
            }
            break;
        }
        
    }
    
    class func dismissView(){
        guard let visibleViewController = self.visibleViewController() else{
            return
            print("falied")
        }
        visibleViewController.dismiss(animated: true, completion: nil)
    }
    
}
