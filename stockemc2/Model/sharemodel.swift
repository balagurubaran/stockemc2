//
//  sharemodel.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 11/26/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import UIKit

let red = UIColor.init(red: 255.0/255.0, green: 38.0/255.0, blue: 0.0, alpha: 1.0)

class ShareHistory{
    var category:String?
    var low:Float?
    var high:Float?
    var precentage:Float?
    var price:Float?
    var open:Float?
    var lastUpdatedDate:String?
    
}

class Financial{
    var revenue:String?
    var earnings:String?
    var year:String = String()
}

class KeyState{
    var marketcap:String?
    var dividendyield = ""
    var beta = ""
    var shortratio = ""
    var priceToBook = ""
    var ebitda = ""
    var roic = ""
    var roa = ""
    var grossprofit = ""
    var profitmargin = ""
}

class dividends{
    var date:String?
    var price:Float?
}

class shareBasicInfo {
    var shareName:String?
    var companyName:String?
}

class share{
    var shareSector:String = ""
    var currentPrice:Float?
    var targetPrice:Float?
    var targetPrecentage:Float?
    var dividendsDate:String?
    var dividendsPrice:Float?
    var actualPrice:Float?
    var watchListCount:Int?
    
    var avgExpectedEPS:Float?
    var avgActualEPS:Float?
    
    var weekslow_52:Float = Float()
    var weeklowpercentage_52:Float = Float()
    var comments = "Comments not added"
    
    var isTargetReached : Bool = false
    var addedstockDate:Date?
    
    var isNew:Bool? {
        get {
            return (addedstockDate!.addDay(n: 2) >= Date() ) ? true:false
        }
    }
    
    var week:ShareHistory?
    var day:ShareHistory?
    var live:ShareHistory?
    var month:ShareHistory?
    
    var earningCall:EarningCall?
    var dividend:dividends?
    
    var currencySympol:String = "$"
    
    var color : UIColor {
        get {
            if(isTargetReached ){
                return UIColor.init(red: 1/255.0, green: 1/255.0, blue: 1/255.0, alpha: 0.5)
            }else if (Float(targetPrecentage!) < 0.0 ){
                return UIColor.init(red: 255.0/255.0, green: 38.0/255.0, blue: 0.0, alpha: 1.0)
            }else if Float(targetPrecentage!) < 20.0 {
                return  UIColor.init(red:200/255.0, green:189/255.0, blue:105/255.0, alpha: 1.0)
            }else{
                return UIColor.init(red: 27.0/255.0, green: 178.0/255.0, blue: 47.0/255.0, alpha: 1.0)
            }
            
            
        }
    }
    
    var lastUpdatedDate:String?
}

class EarningCall{
    var lastCall:String?
    var nextCall:String?
}

class EPS {
    var year: String = ""
    var actual: Double = 0.0
    var estimated: Double = 0.0
    var Q:String = "Q1"
    var index = 0
    var fiscalEndDate:String = ""
}

struct Sale {
    //var month: String
    var year: Double
    var revenue: Double
    var earnings: Double
}

class priceHistory30Day{
    var index:Int?
    var open:Double?
    var high:Double?
    var low:Double?
    var close:Double?
    var tradeVolume:Int?
    var timeStamp:String?
}

class TradeVolme{
    var Index:Int?
    var Volume:Int?
}
