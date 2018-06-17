//
//  WidgetService.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 12/29/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import SwiftyJSON

class WidgetService{
    
    //var widgetDetail:[WidgetModel]?
    let service = Service()
    var watchList = [Dictionary<String,String>]()
    
    var widgetDetail = [WidgetModel]()
    
    func widgetServiceCall(){
        widgetDetail.removeAll()
        
        self.watchList = service.gettheWatchList()
        
        service.getWatchListValue(watchList: self.watchList) { (data) in
            self.loadTheShareDataNormal(data:data)
        }
    }
    
    func loadTheShareDataNormal(data:Data){
        
        do{
            let json = try JSON(data: data)
            for eachShare in json {
                widgetDetail.append(loadTheShareDetail(eachShare: eachShare.1));
            }
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "refershdata_widget"), object: nil)
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    func loadTheShareDetail(eachShare:JSON)->WidgetModel{
        
        let shareDetail =  WidgetModel()
        
        let localLive = eachShare["live"].dictionaryValue
        
        shareDetail.sharePrice = parseHistory(value: localLive)
        
        shareDetail.ShareActualPrice = eachShare["actualPrice"].floatValue
        shareDetail.StockID = eachShare["stockid"].string
        shareDetail.shareTargetPrice = eachShare["targetprice"].floatValue
        
        return shareDetail
    }
    
    fileprivate func parseHistory(value:[String:JSON])->Float{
        let price = value["price"]?.floatValue
        return price!
    }
}

