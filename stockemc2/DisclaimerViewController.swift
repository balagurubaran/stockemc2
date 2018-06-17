//
//  DisclaimerViewController.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 12/24/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import UIKit

class DisclaimerViewController: UIViewController {
    
    
    @IBAction func declineDisclamier(_ sender: Any) {
        let alert = UIAlertController(title: "Information", message: "Are you want decline", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            // perhaps use action.title here
            exit(0)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) { action in
            // perhaps use action.title here
        })
        
        self.present(alert, animated: true)
    }
    @IBAction func closeDisclamier(_ sender: Any) {
        UIView.transition(with: self.view, duration: 1.0, options: .transitionCrossDissolve, animations: {
            userDefaults.set(true, forKey: "walkthroughPresented")
            userDefaults.synchronize()
            self.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
            //self.showWalkthrough()
        }, completion: nil)
    }
    
}
