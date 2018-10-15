//
//  SubscriptionViewController.swift
//  stockemc2
//
//  Created by Balagurubaran Kalingarayan on 10/13/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import UIKit

class SubscriptionViewController:UIViewController {
    
    @IBAction func paySubscrption(_ sender: Any) {
        if(!isValidPurchase){
            HandleSubscription.shared.purchase()
        }
    }
    
    @IBAction func closeView(_ sender: Any) {
        UIWindow.dismissView()
    }
    @IBAction func restorePurchase(_ sender: Any) {
        if(!isValidPurchase){
            HandleSubscription.shared.purchase()
        }
    }
}

