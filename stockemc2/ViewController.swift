//
//  ViewController.swift
//  StockEMC2
//
//  Created by Balagurubaran Kalingarayan on 3/17/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate,UITabBarDelegate {

    //@IBOutlet weak var watchListStockAction: UIImageView!
    // @IBOutlet weak var FilterStockAction: UIImageView!
    @IBOutlet weak var stockLogoTableView: UITableView!
    @IBOutlet weak var watchListON_OffBt: UIButton!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var mainView: UIScrollView!
    @IBOutlet weak var mainDataView: UIView!
    @IBOutlet weak var finaceDataView: UIView!
    //@IBOutlet weak var RevenueGraph: UIView!
    //@IBOutlet weak var EPSGraph: UIView!
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var companyShortName_header: UIImageView!
    //View 1
    @IBOutlet weak var margetPrice: UILabel!
    @IBOutlet weak var priceChangeToday: UILabel!
    @IBOutlet weak var basePrice: UILabel!
    @IBOutlet weak var targetPrice: UILabel!
    @IBOutlet weak var volumeTrade: UILabel!
    @IBOutlet weak var subscrptionButton: UIButton!
    @IBOutlet weak var dividerBetween: UILabel!
    @IBOutlet weak var lastUpdatedDate: UILabel!
    @IBOutlet weak var watchListCountDisplay: UILabel!
    
    //View2 - KeyState
    @IBOutlet weak var marketCap: UILabel!
    @IBOutlet weak var divYield: UILabel!
    @IBOutlet weak var beta: UILabel!
    @IBOutlet weak var shortRatio: UILabel!
    @IBOutlet weak var priceToBook: UILabel!
    @IBOutlet weak var nextDivDate: UILabel!
    @IBOutlet weak var expectedDivAmount: UILabel!
    @IBOutlet weak var EBITDA: UILabel!
    @IBOutlet weak var ROIC: UILabel!
    @IBOutlet weak var ROA: UILabel!
    @IBOutlet weak var grossProfit: UILabel!
    
    //FinancialDataView
    @IBOutlet weak var menLeftConstraint: NSLayoutConstraint!
    
    var contentHeight:CGFloat = 0.0
    var isAnimated = false
    var utility:Utility = Utility()
    
    var FinanciadetailVIew:FinancialDataView?
     var isProfitList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        utility.initloadView()
    
        NotificationCenter.default.addObserver(self, selector: #selector(refreshApplication), name: NSNotification.Name(rawValue: "refreshApplication"), object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(refreshApplication), name: .UIApplicationWillEnterForeground, object: nil)
       
        NotificationCenter.default.addObserver(self, selector: #selector(updateSubscrptionLabel), name: NSNotification.Name(rawValue: "updateSubscrptionLabel"), object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshApplication),
                                               name: .appTimeout,
                                               object: nil)
        tabBar.delegate = self
        tabBar.selectedItem = tabBar.items?[0]
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        targetPrice.isHidden = true
        basePrice.isHidden = true
        dividerBetween.isHidden = true
        subscrptionButton.isHidden = true
        
        //DataHandler.setTheInAppPurchaseStatus()
        
        //Utility.checkFreePeriod()
        
        self.utility.showLoadingView(view: self.view)
        
        if !userDefaults.bool(forKey: "walkthroughPresented") {
            loadDisclamirPage()
            return
        }
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        NetworkHandler.loadTheStockBasicInfo(dispatch: dispatchGroup)
        
        dispatchGroup.enter()
        HandleSubscription.shared.loadReceipt(completion: { (status) in
            isValidPurchase = status
            dispatchGroup.leave()
        }) 
    
        dispatchGroup.notify(queue: .main) {
            //print("Both functions complete 👍")
            self.reloadTableView()
            if(DataHandler.getTheMainMenuStocksCount() > 0){
                self.updateTheSelectedStockAsMenuIcon(index:0);
                DataHandler.setSelectedIndex(index: 0)
            }
            
        }
        self.dropShadow()
    }
    
    func loadDisclamirPage(){
        let Main = UIStoryboard(name: "Main", bundle: nil)
        let Disclamier = Main.instantiateViewController(withIdentifier: "disclamier")
        self.present(Disclamier, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    func dropShadow(){
        companyName.dropShadow()
        tabBar.dropShadow()
        
        tabBar.layer.shadowRadius = 4
        companyName.layer.shadowRadius = 4
        
        //mainView.dropShadow()
    }
    
    func updateTheSelectedStockAsMenuIcon(index:Int){
        
        let shareName = DataHandler.getIndexDataFromTheMenuStock(index: index)
        companyName.text = shareName.companyName
        companyShortName_header.setImage(string: shareName.shareName?.uppercased(), color: UIColor.colorHash(name:shareName.shareName!), circular: true, textAttributes: nil,fontSize: 12.0)

        
       // companyName.backgroundColor = .white
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        NetworkHandler.loadTheShareDataNormal(dispatch: dispatchGroup, shareName:(shareName.shareName?.uppercased())! )
        
        dispatchGroup.enter()
        NetworkHandler.loadTheKeyState(dispatch: dispatchGroup, shareName:(shareName.shareName?.uppercased())! )
        
        dispatchGroup.enter()
        NetworkHandler.loadTheEPSGraph(dispatch: dispatchGroup, shareName:(shareName.shareName?.uppercased())! )
        
        dispatchGroup.enter()
        NetworkHandler.loadTheRevenueGraph(dispatch: dispatchGroup, shareName:(shareName.shareName?.uppercased())! )
        
        dispatchGroup.enter()
        NetworkHandler.load30DaysData(dispatch: dispatchGroup, shareName: (shareName.shareName?.uppercased())!)
        
        
        
        dispatchGroup.notify(queue: .main) {

            self.updateTheView1()
            self.updateTheView2()
            self.loadTheGraph()
            
            if(self.contentHeight == 0){
                for view in self.mainView.subviews {
                    self.contentHeight = view.frame.size.height + self.contentHeight
                }
                
                self.mainView.contentSize = CGSize.init(width: self.mainView.frame.size.width, height: self.contentHeight + 80)
            }
              self.utility.removeLoading(view: self.view)
            
        }
        
    }
    
    @objc func updateSubscrptionLabel(){
        DispatchQueue.main.async {
            
            self.targetPrice.isHidden = true
            self.basePrice.isHidden = true
            self.dividerBetween.isHidden = true
            self.watchListON_OffBt.isHidden = true
            self.watchListCountDisplay.isHidden = true
            self.subscrptionButton.isHidden = true
            
            if(isValidPurchase){
                self.targetPrice.isHidden = false
                self.basePrice.isHidden = false
                self.dividerBetween.isHidden = false
                self.watchListON_OffBt.isHidden = false
                self.watchListCountDisplay.isHidden = false
            }else{
               Utility.showMessage(message: "Need subscription to see the Target price for the stock")
                self.watchListON_OffBt.isHidden = true
                self.subscrptionButton.isHidden = false
                self.watchListCountDisplay.isHidden = true
            }
        }
    }
    
    func updateTheView1(){
        
        UIView.transition(with: mainView, duration: 1.0, options: .transitionCrossDissolve, animations: {
            DispatchQueue.main.async(execute: {
               self.mainView.contentOffset = CGPoint(x: 0.0, y: 0.0)
            })
        }, completion: nil)
        
        
        
        let share = DataHandler.getTheSelectedStockInfoForView1()
        margetPrice.text = "$" + String(describing:share.currentPrice!)
        basePrice.text   = "$" + String(describing:share.actualPrice!)
        targetPrice.text   = "$" + String(describing:share.targetPrice!)
        volumeTrade.text = DataHandler.getTrdeVolmeForDay()
        lastUpdatedDate.text = share.lastUpdatedDate
        
        
        
        if let currentPrice = share.live?.price, let openPrice = share.live?.open!{
            
            let myString = (openPrice-currentPrice >= 0 ? "-" :"") + "$" + String(describing: abs(openPrice - currentPrice)) + " Today"
            let myAttribute = [ NSAttributedStringKey.foregroundColor: (openPrice-currentPrice >= 0 ? Utility.red :Utility.green) ]
            let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
            
            // set attributed text on a UILabel
            priceChangeToday.attributedText = myAttrString
        }
        
        if let date = share.dividendsDate, (Float(share.dividendsPrice!) != 0.0) {
            nextDivDate.text   = date
            expectedDivAmount.text   = "$" + String(describing:share.dividendsPrice!)
        }else{
            nextDivDate.text   = "--"
            expectedDivAmount.text   = "--"
        }
        
        if( (DataHandler.getTheSelectedIndex() >= 0) ){
            watchListON_OffBt.isHidden = false
            let shareDetail = DataHandler.getIndexDataFromTheMenuStock(index: DataHandler.getTheSelectedIndex())
            if(DataHandler.isShareExitinWatchList(shareName: shareDetail.shareName!)){
                watchListON_OffBt.setImage(UIImage(named: "favorite.png"), for: .normal)
            }else{
                watchListON_OffBt.setImage(UIImage(named: "favorite_no.png"), for: .normal)
            }
            
            if(share.watchListCount! > 0){
                watchListCountDisplay.text = "\(share.watchListCount!)"
            }else{
                watchListCountDisplay.text = ""
            }
        }else{
            watchListON_OffBt.isHidden = true
        }
      //  updateSubscrptionLabel()
    }
    
    func updateTheView2(){
        let keyState = DataHandler.getTheSelectedStockInfoForView2()
        guard let marketcap_value = keyState.marketcap else {
            return
        }
        
        if(marketcap_value.count > 0 && (Double(marketcap_value)! > Double(keyState.ebitda)!)){
            marketCap.text = marketcap_value.count > 0 ? Utility.convertIntToDollar(number:Double(marketcap_value)!) : "--"
            EBITDA.text  = keyState.ebitda.count > 0 ? Utility.convertIntToDollar(number:Double(keyState.ebitda)!) : "--"
            
            textValueColor(textLabel: EBITDA, text: keyState.ebitda)

        }else{
            marketCap.text = "--"
            EBITDA.text = "--"
        }
        
        // marketcap.text = marketcap_value.count > 0 ? Utility.convertIntToDollar(number:Double(marketcap_value)!) : "--"
        beta.text = keyState.beta
        divYield.text = keyState.dividendyield.count > 0 ? keyState.dividendyield + "%": "--"
        shortRatio.text = keyState.shortratio.count > 0 ? keyState.shortratio : "--"
        priceToBook.text = keyState.priceToBook.count > 0 ?  keyState.priceToBook : "--"
        //ebitda.text  = keyState.ebitda.count > 0 ? Utility.convertIntToDollar(number:Double(keyState.ebitda)!) : "--"
        ROIC.text    = keyState.roic.count > 0 ? keyState.roic + "%" : "--"
        
        textValueColor(textLabel: ROIC, text: keyState.roic)
        
        ROA.text     = keyState.roa.count > 0 ?  keyState.roa + "%" : "--"
        
        textValueColor(textLabel: ROA, text: keyState.roa)
        
        grossProfit.text = keyState.grossprofit.count > 0 ?  Utility.convertIntToDollar(number:Double(keyState.grossprofit)!) : "--"
        
        textValueColor(textLabel: grossProfit, text: keyState.grossprofit)
    }
    
    func textValueColor(textLabel:UILabel,text:String){
        print(text)
        textLabel.textColor = Double(text)! >= 0.0 ? .black : .red
    }
    
    func loadTheGraph() {
        
        if(FinanciadetailVIew == nil){
            FinanciadetailVIew = FinancialDataView.init()
            mainView.addSubview(FinanciadetailVIew!)
            
            FinanciadetailVIew?.translatesAutoresizingMaskIntoConstraints = false
            FinanciadetailVIew?.topAnchor.constraint(equalTo: finaceDataView.bottomAnchor, constant: 0.0).isActive = true
            FinanciadetailVIew?.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
            
            FinanciadetailVIew?.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 1).isActive = true
            FinanciadetailVIew?.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 920.0/mainView.frame.size.height).isActive = true
            mainView.layoutIfNeeded()
        }
       
        FinanciadetailVIew?.loadFinacialData()
    }
    
    
    @IBAction func watchListON_Off(_ sender: Any) {
        let share = DataHandler.getIndexDataFromTheMenuStock(index: DataHandler.getTheSelectedIndex())
        var watchList = DataHandler.getThewatchlist()
        if watchList.count > 0  {
            if(!DataHandler.isShareExitinWatchList(shareName: share.shareName!)){
                let  shareDetail : Dictionary = ["shareName": share.shareName!,"companyName":share.companyName!]
                watchList.append(shareDetail)
                userDefaults.set(watchList, forKey: "watchlist")
                watchListON_OffBt.setImage(UIImage(named: "favorite.png"), for: .normal)
                Utility.showMessage(message: "Stock added to watchlist")
                NetworkHandler.updateTheWatchListCoount(shareName: share.shareName!, isRemove: true)
            }else{
                if let watchList = userDefaults.array(forKey: "watchlist") as? [Dictionary<String,String>]{
                    userDefaults.set(watchList.filter {!$0.values.contains(share.shareName!) }, forKey: "watchlist")
                    watchListON_OffBt.setImage(UIImage(named: "favorite_no.png"), for: .normal)
                    Utility.showMessage(message: "Stock removed from watchlist")
                    let watchList = DataHandler.getThewatchlist()
                    if watchList.count == 0 {
                        isWatchList = false;
                    }
                        updateTheSelectedStockAsMenuIcon(index: 0);
                        DataHandler.setSelectedIndex(index: 0)
                        self.utility.showLoadingView(view: self.view)
                        Utility.logEvent(title: "favourite removed")
                        reloadTableView()
                    NetworkHandler.updateTheWatchListCoount(shareName: share.shareName!, isRemove: false)
                }
            }
        }else{
            Utility.logEvent(title: "firebase_event_ddd_watchlist")
            let  shareDetail : Dictionary = ["shareName": share.shareName!,"companyName":share.companyName!]
            let array = [shareDetail]
            userDefaults.set(array, forKey: "watchlist")
            watchListON_OffBt.setImage(UIImage(named: "favorite.png"), for: .normal)
            Utility.showMessage(message: "Stock added to watchlist")
            NetworkHandler.updateTheWatchListCoount(shareName: share.shareName!, isRemove: true)
        }
    }
    
    @IBAction func paySubscrption(_ sender: Any) {
        if(!isValidPurchase){
           HandleSubscription.shared.purchase()
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //This method will be called when user changes tab.
        SearchBar.isSearchBarLifeTime = false
        isDividend = false
       
        var loadProfitLostService = false
        switch item.title {
            
        case "Main","Dividend","Profit","Loss":
            if(item.title == "Dividend"){
                isDividend = true
            }
            if(item.title == "Profit"){
                isProfitList = true
                loadProfitLostService = true
            }
            if(item.title == "Loss"){
                isProfitList = false
                loadProfitLostService = true
            }
            isWatchList = false
            refreshApplication(isProfitlLossService: loadProfitLostService)
            Utility.logEvent(title: "firebase_event_all")
        case "Watchlist":
            Utility.logEvent(title: "firebase_event_watchlist")
            loadTheWatchList()
        case "search":
            Utility.logEvent(title: "firebase_event_search")
            if(!SearchBar.isVisible){
                SearchBar.isSearchBarLifeTime = true
                SearchBar.showSearchBar()
            }
        
        default:
            print("default")
        }
    }
    
    func loadTheWatchList(){
        
        isWatchList = true
        let watchList = DataHandler.getThewatchlist()
        if watchList.count == 0{
            isWatchList = false
            Utility.showMessage(message: "Watchlist is empty")
        }
        fadeOut()
        reloadTableView()
        
        updateTheSelectedStockAsMenuIcon(index: 0)
        DataHandler.setSelectedIndex(index:0)
        self.utility.showLoadingView(view: self.view)
    }
}

// Main Stock Click
extension ViewController:UITableViewDataSource,UITableViewDelegate,SearchBarDelegate {
    func searchBardEndEditing(searchString: String) {
        fadeOut()
        if(SearchBar.isSearchBarLifeTime && searchString != ""){
            DataHandler.setSearchString(searchValue: searchString)
            updateTheSelectedStockAsMenuIcon(index: 0)
            DataHandler.setSelectedIndex(index:0)
            reloadTableView()
        }else{
            if(isWatchList){
                isWatchList = false
            }
            searchBarClosed()
        }
        
    }
    
    func searchBarClosed() {
        if(isWatchList){
            tabBar.selectedItem = tabBar.items?[1]
        }else{
            tabBar.selectedItem = tabBar.items?[0]
        }
        removeFadeOut()
        SearchBar.isSearchBarLifeTime = false
        reloadTableView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataHandler.getTheMainMenuStocksCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "mainStockLogo")!
        (cell as! CustomMainLogoCell).configure(index:indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if( indexPath.row == 0){
//            if(!SearchBar.isVisible){
//                SearchBar.showSearchBar()
//            }
//        }else{
            removeFadeOut()
            updateTheSelectedStockAsMenuIcon(index: indexPath.row );
            DataHandler.setSelectedIndex(index: indexPath.row )
            self.utility.showLoadingView(view: self.view)
       // }
    }
    
    @objc func refreshApplication(isProfitlLossService:Bool = false){
        DispatchQueue.main.async {
        self.utility.showLoadingView(view: self.view)
                
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            if(isProfitlLossService){
                NetworkHandler.loadTheStockBasicInfo_profit_loss(isProfitList: self.isProfitList, dispatch: dispatchGroup)
            }else{
                NetworkHandler.loadTheStockBasicInfo(dispatch: dispatchGroup)
            }
            
        
            dispatchGroup.notify(queue: .main) {
                SearchBar.isSearchBarLifeTime = false
                if(DataHandler.getTheMainMenuStocksCount() > 0){
                    self.reloadTableView()
                    self.updateTheSelectedStockAsMenuIcon(index:0);
                    DataHandler.setSelectedIndex(index: 0)
                }
            }
        }
    }
    
    func reloadTableView(){
        
        UIView.transition(with: self.stockLogoTableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
            
            DispatchQueue.main.async(execute: {
                self.stockLogoTableView.reloadData()
                let indexPath = IndexPath(row: 0, section: 0)
                self.stockLogoTableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
                self.removeFadeOut()
            })
        }, completion: nil)
    }
    
    func fadeOut(){
        DispatchQueue.main.async(execute: {
            self.mainDataView.alpha = 0.5
            self.finaceDataView.alpha = 0.5
        })
        
    }
    
    func removeFadeOut(){
        mainDataView.alpha = 1
        finaceDataView.alpha = 1
        self.view.endEditing(false)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        if touch.view?.tag == 1000 { // watchList
            
            if(SearchBar.isSearchBarLifeTime){
                Utility.logEvent(title: "Search watchlist")
                if(isWatchList){
                    isWatchList = false
                }
                SearchBar.isSearchBarLifeTime = false
                reloadTableView()
                
            }else {
    
                isWatchList = !isWatchList
                let watchList = DataHandler.getThewatchlist()
                if watchList.count == 0{
                    isWatchList = !isWatchList
                    Utility.showMessage(message: "Watchlist is empty")
                }
                fadeOut()
                reloadTableView()
            }
            updateTheSelectedStockAsMenuIcon(index: 0)
            DataHandler.setSelectedIndex(index:0)
            self.utility.showLoadingView(view: self.view)
        }else if (touch.view?.tag == 1002){ //Menu Action
            //            UIView.animate(withDuration: 2, animations: {
            //                if(self.isAnimated){
            //                    self.stockLogoTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.18).isActive = true
            //                    self.mainView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.78).isActive = true
            //                }else{
            //                    self.stockLogoTableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.001).isActive = true
            //                    self.mainView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.96).isActive = true
            //                }
            //            })
            //            isAnimated = !isAnimated
        }else if(touch.view?.tag == 1004){//subscription
            if(!isValidPurchase){
                HandleSubscription.shared.purchase()
            }
        }else if(touch.view?.tag == 1005){//subscription
            if(!SearchBar.isVisible){
                SearchBar.showSearchBar()
            }
        }
        
    }
}

