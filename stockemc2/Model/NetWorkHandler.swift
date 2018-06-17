//
//  NetWorkHandler.swift
//  StockEMC2
//
//  Created by Balagurubaran Kalingarayan on 3/20/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation

class NetworkHandler{
    
    class func loadTheStockBasicInfo( dispatch:DispatchGroup){
        let service = Service()
        service.getshareBasicDetail { (data) in
            DataHandler.parseTheStockBasicDetail(data: data)
            dispatch.leave()
        }
        
    }
    
    class func loadTheShareDataNormal(dispatch:DispatchGroup,shareName:String){
        let service = Service()
        service.getTheSpecificStockCurrentPriceInfo(shareName: shareName) { (data) in
            DataHandler.parseTheCurrnetPriceInfo(data: data)
            dispatch.leave()
        }
    }
    
    class func loadTheKeyState(dispatch:DispatchGroup,shareName:String){
        let service = Service()
        service.getKeyState(shareName: shareName) { (data) in
            DataHandler.parseKeyState(data: data)
            dispatch.leave()
        }
    }
    
    class func loadTheEPSGraph(dispatch:DispatchGroup,shareName:String){
        let service = Service()
        let url = "https://api.iextrading.com/1.0/stock/\(shareName)/earnings"
        
        service.getTheFinancialData(url: url) { (data) in
            DataHandler.parseTheEPSData(data: data)
            dispatch.leave()
        }
    }
    
    class func load30DaysData(dispatch:DispatchGroup,shareName:String){
        let service = Service()
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "yyyy/MM/dd"
        let date = Date()
        var stringOfDate = dateFormate.string(from: date)

        let dateComponents = Calendar.current.dateComponents([.weekday,.hour], from: date)
        if(dateComponents.weekday! == 1){
            stringOfDate = dateFormate.string(from: date.addDay(n: -2))
        }else if(dateComponents.weekday! == 7 ){
            stringOfDate = dateFormate.string(from: date.addDay(n: -1))
        }
        
        if(dateComponents.hour! >= 0 && dateComponents.hour! < 9){
            stringOfDate = dateFormate.string(from: date.addDay(n: -1))
        }
        stringOfDate = stringOfDate.replacingOccurrences(of: "/", with: "")
        let url = "https://api.iextrading.com/1.0/stock/\(shareName)/chart/date/\(stringOfDate)"
        
        service.getTheFinancialData(url: url) { (data) in
            DataHandler.parseThe30Data(data: data)
            dispatch.leave()
        }
    }
    
    class func loadTheRevenueGraph(dispatch:DispatchGroup,shareName:String){
        let service = Service()
        let url = "https://stockrow.com/api/companies/\(shareName)/financials.json?dimension=MRY&section=Income%20Statement"
        service.getTheFinancialData(url: url) { (data) in
            DataHandler.parseTheRevenueData(data: data)
            dispatch.leave()
        }
    }
}
