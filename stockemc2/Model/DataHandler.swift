//
//  JSONParser.swift
//  Gradient
//
//  Created by Balagurubaran Kalingarayan on 11/19/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import SwiftyJSON

fileprivate var mainMenuStockDetail:[shareBasicInfo] = [shareBasicInfo]()
fileprivate let shareDetail =  share()
var currentPrice = Float();

var financialData:[Financial] = [Financial]()
var price30Days:[priceHistory30Day] = [priceHistory30Day]()
var tradeVolumes:[TradeVolme] = [TradeVolme]()

var appStatsModel = AppStatsModel()

var EPSData:[EPS] = [EPS]()

var founderInvestment:Float = 0
var foundedProfitORLoss:Float = 0
let keyState = KeyState.init()
var watchList:Array = [String]()

var selectedIndex = 0;
var searchString = ""


struct revenue_earning{
    var amount:String
    var year:String
}

class DataHandler{
    
    // mainMenuStickInfo Start
    class func parseTheStockBasicDetail(data:Data){
        mainMenuStockDetail.removeAll()
        do{
            let allStockBasicInfo = try JSON(data: data)
            for eachStockInfo in allStockBasicInfo {
                let stock = shareBasicInfo()
                stock.shareName = eachStockInfo.1["stockid"].stringValue
                stock.companyName = eachStockInfo.1["stockname"].stringValue
                mainMenuStockDetail.append(stock)
            }
            
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    class func parseTheApplicationStats(data:Data){
        appStatsModel = AppStatsModel.init()
        do{
            let decoder = JSONDecoder()
            appStatsModel = try decoder.decode(AppStatsModel.self, from: data)
            
        }catch let error{
            
            let backToString = String(data: data, encoding: String.Encoding.utf8) as String?
            print(backToString)
            print("appStatsModel Error", error.localizedDescription)
        }
    }
    
    class func getTheMainStockDetail()->[shareBasicInfo] {
        if(SearchBar.isSearchBarLifeTime){
            var filterted = isWatchList ?  DataHandler().frameWatchList() : mainMenuStockDetail
                
            filterted = filterted.filter{ ($0.shareName?.contains(getSearchString()))!}
            if(filterted.count == 0){
                //isSearchFailed = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateTheWatchListStatus"), object: nil, userInfo: nil)
                isWatchList = false
                SearchBar.isSearchBarLifeTime = false
                Utility.showMessage(message: "Stock not listed")
            }
            return filterted.count > 0 ? filterted:mainMenuStockDetail
        }else if isWatchList{
            return DataHandler().frameWatchList()
        }
        return mainMenuStockDetail;
    }
    
    func frameWatchList()->[shareBasicInfo]{
        var StockDetail:[shareBasicInfo] = [shareBasicInfo]()
        if let watchList = userDefaults.array(forKey: "watchlist") as? [Dictionary<String,String>] {
            for eachShare in watchList {
                let share = shareBasicInfo()
                share.shareName = eachShare["shareName"]
                share.companyName = eachShare["companyName"]
                StockDetail.append(share)
            }
        }
        return StockDetail
    }
    
    class func getTheStats()->AppStatsModel{
        return appStatsModel
    }
    class func getTheMainMenuStocksCount()->Int{
        return self.getTheMainStockDetail().count
    }
    
    class func getIndexDataFromTheMenuStock(index:Int)->shareBasicInfo{
        let stockDetail = self.getTheMainStockDetail()
        return stockDetail[index]
    }
    
    class func setSelectedIndex(index:Int){
        selectedIndex = index
    }
    
    class func setSearchString(searchValue:String){
        searchString = searchValue
    }
    
    class func getSearchString()->String{
        return searchString
    }
    
    // mainMenuStickInfo end
    
    //Current Market price view info start
    
    class func getTheSelectedStockInfoForView1()->share{
        return shareDetail
    }
    
    class func parseTheCurrnetPriceInfo(data:Data){
        
        do{
            
            var eachShare = try JSON(data: data)[0]
        
           //let localDay = eachShare["day"].dictionaryValue
            let localLive = eachShare["live"].dictionaryValue
            
           shareDetail.live = parseHistory(value: localLive)
            
            shareDetail.currentPrice = shareDetail.live?.price
            currentPrice = shareDetail.currentPrice!;
            
            
           // shareDetail.day = parseHistory(value: localDay)
            
            shareDetail.actualPrice = eachShare["actualPrice"].floatValue
            
            //shareDetail.shareID = eachShare.1["ID"].int
           // shareDetail.shareName = eachShare["stockid"].string
            
            shareDetail.avgActualEPS = eachShare["avgActualEPS"].floatValue
            shareDetail.avgExpectedEPS = eachShare["avgExpectedEPS"].floatValue
            
            shareDetail.weekslow_52 = eachShare["weeklow_52"].floatValue
            shareDetail.isTargetReached = eachShare["isTargetReached"].boolValue
            shareDetail.lastUpdatedDate =  shareDetail.live?.lastUpdatedDate?.formatDateString()
            
            shareDetail.watchListCount =  eachShare["watchlistCount"].intValue
            
            
            shareDetail.comments = eachShare["comments"].stringValue
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = appDateFormat
            
            if let sector =  eachShare["sector"].string{
                shareDetail.shareSector = sector
            }
            
            shareDetail.addedstockDate = dateFormatter.date(from:(eachShare["addedstockDate"].stringValue).formatDateString())
            
            if(shareDetail.weekslow_52 > 0.0){
                shareDetail.weeklowpercentage_52 = (currentPrice/shareDetail.weekslow_52) * 100
            }
            
            shareDetail.dividendsPrice = 0.0
            
            if ((eachShare["lastDivamount"].floatValue) > 0){
                shareDetail.dividendsPrice = eachShare["lastDivamount"].floatValue
                shareDetail.dividendsDate = (eachShare["lastdivdate"].string)?.formatDateString()
                
                
                let date = dateFormatter.date(from: shareDetail.dividendsDate!)?.addMonth(n: 3)
                
                shareDetail.dividendsDate = dateFormatter.string(from: date!)//String.init(describing: date)
                
            }
            
            shareDetail.currencySympol = "$";//eachShare.1["currnecysymbol"].string
            
            shareDetail.targetPrice = eachShare["targetprice"].floatValue
            shareDetail.targetPrecentage =  ((shareDetail.targetPrice! - shareDetail.currentPrice!)/shareDetail.currentPrice! )*100//eachShare.1["targetprecentage"].floatValue
            
            let QReportDate:EarningCall = EarningCall()
            for (key,value) in eachShare["earningcall"].dictionaryValue {
                if key == "last"{
                    QReportDate.lastCall = value.stringValue
                }else{
                    QReportDate.nextCall = value.stringValue
                }
            }
            shareDetail.earningCall = QReportDate
        }catch let error{
            print(error.localizedDescription)
        }
    }
    
    fileprivate class func parseHistory(value:[String:JSON])->ShareHistory{
        let history:ShareHistory = ShareHistory()
        history.low = value["low"]?.floatValue
        history.high = value["high"]?.floatValue
        history.price = value["price"]?.floatValue
        history.open = value["open"]?.floatValue
        var dateValue = value["lastPriceUpdated"]?.string
        history.lastUpdatedDate = dateValue?.formatDateString()
       // print(history.open!);
        //history.precentage =  ((currentPrice-history.open!) / history.open!) * 100.0
        return history
    }
    
    //Current Market price view info End
    
    
    //Stock's KeyState start
    
    class func getTheSelectedStockInfoForView2()->KeyState{
        return keyState
    }
    
    class func parseKeyState(data:Data){
        
        do{
            let AllKeyState = try JSON(data: data)
            keyState.beta = AllKeyState["beta"].stringValue
            keyState.priceToBook = AllKeyState["priceToBook"].stringValue
            keyState.dividendyield = AllKeyState["dividendyield"].stringValue
            keyState.shortratio = AllKeyState["shortratio"].stringValue
            keyState.ebitda = AllKeyState["ebitda"].stringValue
            keyState.roic = AllKeyState["ROIC"].stringValue
            keyState.roa = AllKeyState["ROA"].stringValue
            keyState.grossprofit = AllKeyState["grossprofit"].stringValue
            keyState.profitmargin = AllKeyState["netprofitmargin"].stringValue
            keyState.marketcap = AllKeyState["marketcap"].stringValue
            
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    //Stock's keystate End
    
    
    //Stock's Financial Data start
    
    class func parseTheEPSData(data:Data){
        EPSData.removeAll()
        do{
            EPSQLabels.removeAll()
            var index = 0
            let json = try JSON(data: data)
            for eachDetail in json {
                let Allearnings = eachDetail.1
                //let Allearnings = eachFinacialData["earnings"].arrayValue
                
                for data in Allearnings{
                    let epsValue = EPS.init()
                    
                    
                    epsValue.year =  data.1["fiscalPeriod"].stringValue
                    if(epsValue.year.count > 0){
                        epsValue.actual =  data.1["actualEPS"].doubleValue
                        epsValue.Q  = String(epsValue.year.dropLast(epsValue.year.count - 2))
                        var dateValue = data.1["fiscalEndDate"].stringValue
                        epsValue.fiscalEndDate =  dateValue.formatDateString()
                        epsValue.index =  index
                        epsValue.estimated =  data.1["estimatedEPS"].doubleValue
                        if(self.checkTheEPSQValide(value: epsValue)){
                            EPSQLabels.append(epsValue.Q)
                            EPSData.append(epsValue)
                        }
                        index = index + 1
                    }
                    
                }
                
            }
        }catch let error{
            print(error.localizedDescription)
        }
        
    }

    class func checkTheEPSQValide(value:EPS)->Bool{
        let split = value.year.split(separator: " ")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = appDateFormat //Your New Date format as per requirement change it own
        let newDate = dateFormatter.date(from: value.fiscalEndDate)
        
        //let date = newDate?.getdate()
        let Year = (newDate?.getYear())!
        let month = Int((newDate?.getMonth())!)!
        
        if(split[1] != Year){
            if(split[0] == "Q4" && (month >= 11 || month <= 2)){
                return true
            }
            return false
        }
        
        return true
    }
    
    class func parseTheRevenueData(data:Data){
        financialData.removeAll()
        var revenue:[revenue_earning] = [revenue_earning]()
        var earning:[revenue_earning] = [revenue_earning]()
        do{
            let json = try JSON(data: data)
            
            
            for eachShare in json {
                
                let eachFinacialData = eachShare.1
                let id = eachFinacialData["id"].string
                switch id {
                case Income.Revenues.rawValue?:
                    for (value,key) in eachFinacialData {
                        if (value != "id") {
                            var localValue = value
                            let eachYear = revenue_earning(amount:key.stringValue , year: localValue.formatDateString())
                            if(self.removeTheSameYearfromdata(data: eachYear)){
                                revenue.append(eachYear)
                            }
                            
                            
                        }
                    }
                    
                case Income.Earnings.rawValue?:
                    for (value,key) in eachFinacialData {
                        if (value != "id") {
                            var localValue = value
                            let eachYear = revenue_earning(amount:key.stringValue , year: localValue.formatDateString())
                            if(self.removeTheSameYearfromdata(data: eachYear)){
                                earning.append(eachYear)
                            }
                            
                        }
                    }
                    
                default:
                    break
                }
            }
        }catch let error{
            print(error.localizedDescription)
        }
        revenue = revenue.sorted{($0.year < $1.year)}
        earning = earning.sorted{($0.year < $1.year)}
        
        if (revenue.count > 5){
            revenue = Array(revenue.dropFirst(revenue.count - 5))
            earning = Array(earning.dropFirst(earning.count - 5))
        }
        
        if(revenue.count > 0){
            
            for eachyear in revenue{
                let eachFinacialData = Financial()
                eachFinacialData.revenue = eachyear.amount
                eachFinacialData.year = eachyear.year
                let filterEarning = earning.filter { ($0.year == eachFinacialData.year)}
                if filterEarning.count > 0 {
                    eachFinacialData.earnings = filterEarning[0].amount
                    financialData.append(eachFinacialData)
                }
                
            }
        }
        
    }
    
    class func removeTheSameYearfromdata(data:revenue_earning)->Bool{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = appDateFormat //Your New Date format as per requirement change it own
        let newDate = dateFormatter.date(from: data.year)
        
        //let date = newDate?.getdate()
        //let month = Int((newDate?.getMonth())!)!
        //let year  = Character((newDate?.getYear())!)
        
        return true//month > 10 ? true:false
    }

    //Stock's Financial Data End
    
    // WatchList Start
   class func getTheSelectedIndex()->Int{
        //return selectedIndex;
    let watchList = self.getThewatchlist()
        if watchList.count > 0{
            return selectedIndex
        }else {
            return 0;
        }
    }
    
    
    class func getThewatchlist()->[Dictionary<String,String>]{
        if let watchList = userDefaults.array(forKey: "watchlist") as? [Dictionary<String,String>] {
            return watchList
        }
        return []
    }
    
    class func isShareExitinWatchList(shareName:String)->Bool {
        let watchList = self.getThewatchlist()
        if watchList.count > 0{
            return watchList.filter{$0["shareName"] == shareName}.count > 0 ? true : false
        }else {
            return false;
        }
    }

    //Watchlist End
    
    //30 day Data Start
    class func parseThe30Data(data:Data){
        price30Days.removeAll()
        
        do{
            let The30DayData = try JSON(data: data)
            var index = 0;
            for eachShare in The30DayData {
                let data = priceHistory30Day()
                let history = eachShare.1
                data.open = history["open"].doubleValue
                data.high = history["high"].doubleValue
                data.low = history["low"].doubleValue
                data.close = history["close"].doubleValue
                data.tradeVolume = history["marketVolume"].intValue
                data.timeStamp = history["minute"].stringValue
                index = index + 1
                data.index = index
                price30Days.append(data)
                //print("History", history["open"].stringValue)
            }
            
        }catch let error{
            print(error.localizedDescription)
        }
        
    }
    
    class func getThe30DayPrice()->[priceHistory30Day]{
        return price30Days.filter({$0.index! % 60 == 0});
    }
    
    class func consolidatedTradeVolume()->[TradeVolme]{
        tradeVolumes.removeAll()
        for i in 0..<price30Days.filter({$0.index! % 60 == 0}).count {
            let array = price30Days.getFirstElements(from: i * 60, upTo: (i * 60) + 60)
            let volume = array.reduce(0,{$0 + $1.tradeVolume!})
            let TV = TradeVolme()
            TV.Index = (i + 9)
            TV.Volume = volume
            tradeVolumes.append(TV)
        }
        return tradeVolumes
    }
    
    class func getTrdeVolmeForDay()->String{
        let tradeVolume = self.consolidatedTradeVolume()
        let volume = tradeVolume.reduce(0,{$0 + $1.Volume!})
        
        return String(describing: volume)
    }
    //30 day data END
}

extension Array {
    
    func getFirstElements(from:Int, upTo position: Int) -> Array<Element> {
        let arraySlice = self[from ..< position]
        return Array(arraySlice)
    }
    
}
