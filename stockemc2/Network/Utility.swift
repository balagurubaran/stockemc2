//
//  Utility.swift
//  Location Finder
//
//  Created by Balagurubaran Kalingarayan on 3/18/17.
//  Copyright © 2017 iappscrazy. All rights reserved.
//

import Foundation
import SwiftMessages
import KeychainSwift
import RSLoadingView
import Firebase

class Utility{
    
    static let green = UIColor.init(red: 27.0/255.0, green: 178.0/255.0, blue: 47.0/255.0, alpha: 1.0)
    static let red = UIColor.init(red: 255.0/255.0, green: 38.0/255.0, blue: 0.0, alpha: 1.0)
    static let yellow = UIColor.init(red:221/255.0, green:203/255.0, blue:35/255.0, alpha: 1.0)
    static let appColor = UIColor.init(red:86/255.0, green:126/255.0, blue:142/255.0, alpha: 1.0)
    
    var loadingView:RSLoadingView?
    var isDataLoading = false

    class func showMessage(message:String){
        
        let warning = MessageView.viewFromNib(layout: .cardView)
        warning.configureTheme(.success)
        warning.backgroundView.backgroundColor = appColor
        warning.configureDropShadow()
        
        
        let iconText = ["🤔"].sm_random()!
        warning.configureContent(title: "Info", body:message, iconText: iconText)
        warning.button?.isHidden = true
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level(rawValue: UIWindow.Level.statusBar.rawValue))
        DispatchQueue.main.async(execute: {
            //self.shareBasicView.setContentOffset(CGPoint(x: 0, y:0), animated: true)
            SwiftMessages.show(config: infoConfig, view: warning)
        })
    }
    
    class func convertIntToDollar( number: Double) -> String {
        
        var num:Double = 0.0
        let sign = ((number < 0) ? "-" : "" );
        
        num = fabs(number);
        
        if (num < 1000.0){
            return "\(sign)\(num)" ;
        }
        
        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
        
        let units:[String] = ["K","M","B","T","P","E"];
        
        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
        
        return "\(sign)\(roundedNum)\(units[exp-1])" ;
    }
    
    class func checkFreePeriod(){
    
        let keychain = KeychainSwift()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        isFreeSubcription = false
        if(keychain.get("timeperiod") == nil){
        
            isValidPurchase = true
            isFreeSubcription = true
            
            let currentDate = Date().addMonth(n: 1)
            let date = formatter.string(from: currentDate)
    
            keychain.set(String(describing: date), forKey: "timeperiod")
            showMessage(message: "One month free subscription activated")
    
        }else{
            let date =  keychain.get("timeperiod")
            // convert your string to date
            let savedDate = formatter.date(from: date!)
            
            if(Date() < savedDate!){
                isValidPurchase = true
                isFreeSubcription = true
            }else{
                isValidPurchase = false
            }
        }
        
    }
    
    func initloadView(){
        self.loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        self.loadingView?.mainColor = UIColor.init(red: 162.0/255.0, green: 17.0/25.0, blue: 17.0/255.0, alpha: 1)
    }

    func showLoadingView(view:UIView){
        DispatchQueue.main.async(execute: {
            self.loadingView?.show(on: view)
        })
        
    }

    func removeLoading(view:UIView){
        DispatchQueue.main.async(execute: {
            RSLoadingView.hide(from: view)
        })
        
    }
    
    class func logEvent(title:String){
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
        AnalyticsParameterItemID: "\(title)",
        AnalyticsParameterItemName: title,
        AnalyticsParameterContentType: "cont"
        ])
    }
    
//    class func filterShareTargetReached(){
//        mainPageShareDetail?.removeAll()
//        mainPageShareDetail = perManentmainPageShareDetail?.filter { ($0.isTargetReached) }
//    }
//    class func filterShareProfit(){
//        mainPageShareDetail?.removeAll()
//        mainPageShareDetail = perManentmainPageShareDetail?.sorted { (Int($0.targetPrecentage!) > Int($1.targetPrecentage!)) }
//    }
//    
//    class func filterDivKing(){
//        mainPageShareDetail?.removeAll()
//        mainPageShareDetail = perManentmainPageShareDetail?.sorted { ($0.dividendsPrice! > $1.dividendsPrice!) }
//    }
    
    
}

extension Date {
    func addMonth(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: n, to: self)!
    }
    func addDay(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: n, to: self)!
    }
    func addSec(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: n, to: self)!
    }
    
    func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    func getdate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    func getYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getCurrentDate()->String {
        return getYear() + getMonth() + getdate ()
    }
}

