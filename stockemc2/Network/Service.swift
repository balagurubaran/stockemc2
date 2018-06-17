//
//  Service.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 12/29/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation

class Service{
    
    func gettheWatchList()->[Dictionary<String,String>] {
        //var watchList_temp = [Dictionary<String,String>] ()
        userDefaults = UserDefaults.init(suiteName: "group.com.iappscrazy.bricksbreak2048")!
        
        guard let watchList_temp = userDefaults.array(forKey: "watchlist") as? [Dictionary<String,String>] else{
            return [Dictionary<String,String>]()
        }
       
        return watchList_temp;
    }
    
    func getTheFinancialData(url:String,completion:@escaping (_ Data:Data) -> Void){
        Network.init().getData(url) { (data) in
            completion(data)
        }
    }
    
    func getKeyState(shareName:String, completion:@escaping (_ Data:Data) -> Void){
        Network.init().getData( baseURL + "/getKeyState.php?stockid=\(shareName)") { (data) in
            completion(data)
        }
    }

    func getWatchListValue(watchList:[Dictionary<String,String>] , completion:@escaping (_ Data:Data) -> Void){
       
        for shareName in watchList{
            Network.init().getData( baseURL + "/getStockDetail.php?allStockEntryAlone=false" + "&stockid=" + shareName["shareName"]! + "&iswatchList=true") { (data) in
               completion(data)
            }
        }
    }
    
    func getTheSpecificStockCurrentPriceInfo(shareName:String ,completion:@escaping (_ Data:Data) -> Void){
        Network.init().getData( baseURL + "/getStockDetail.php?allStockEntryAlone=false" + "&stockid=" + shareName + "&iswatchList=false") { (data) in
            completion(data)
        }
    }
    
    func getshareDetail(completion:@escaping (_ Data:Data) -> Void){
        let issub = isValidPurchase ? "true":"false"
        Network.init().getData( baseURL + "/getStockDetail.php?allStockEntryAlone=false&issub=" + issub) { (data) in
            completion(data)
        }
    }
    
    func getshareBasicDetail(completion:@escaping (_ Data:Data) -> Void){
        let issub = isValidPurchase ? "true":"false"
        Network.init().getData( baseURL + "/getStockDetail.php?allStockEntryAlone=t&issub=" + issub) { (data) in
            completion(data)
        }
    }

}
