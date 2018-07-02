//
//  Constant.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 12/29/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation


let baseURL = "https://rgbtohex.in/pennystock"
var isFreeSubcription = false
var userDefaults:UserDefaults = UserDefaults.init(suiteName: "group.com.iappscrazy.bricksbreak2048")!
var checkSum = "12346"
var isTargetReachedSegementSelected = false
let FINANCIALHELP = "finacialHelp"

var isSearchFailed = false

var isWatchList = false;

var EPSQLabels = ["Q4",
                  "Q3",
                  "Q2",
                  "Q1",
]

enum Income:String{
    case Revenues = "7109ead1-05ea-4bc5-a398-29bb1691b7e7"
    case Earnings = "6faaa02c-0d6a-464a-b428-451ac7bff962"
}

enum segementIndex:Int{
    case all = 0
    case targetReached = 1
    case profit = 2
    case div_king = 3
}

var isDividend = false
var isValidPurchase: Bool = false{
    didSet{
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateSubscrptionLabel"), object: nil)
    }
}

func isNewHelpIsViewd(){
    if let checkSumuserDefault = userDefaults.object(forKey: "checksum"){
        if((checkSumuserDefault as! String) != checkSum){
            userDefaults.set(false, forKey: "walkthroughPresented")
            userDefaults.set(checkSum, forKey: "checksum")
        }
    }else{
        userDefaults.set(false, forKey: "walkthroughPresented")
        userDefaults.set(checkSum, forKey: "checksum")
    }
}

func print(_ item: @autoclosure () -> Any, separator: String = " ", terminator: String = "\n") {
//    #if DEBUG
//        Swift.print(item(), separator:separator, terminator: terminator)
//    #endif
}
