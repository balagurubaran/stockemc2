//
//  TodayViewController.swift
//  Watchlist
//
//  Created by Balagurubaran Kalingarayan on 12/29/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding,UITableViewDelegate,UITableViewDataSource {
    let service = WidgetService()

    @IBOutlet weak var WidgetTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: "refershdata_widget"), object: nil)
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        // Do any additional setup after loading the view from its nib.
    }
    
    @objc func loadData(){
        DispatchQueue.main.async {
            self.WidgetTableview.reloadData()
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        switch activeDisplayMode {
        case .expanded: preferredContentSize.height =  CGFloat(self.service.widgetDetail.count) * 60.0;
        case .compact: preferredContentSize.height = 130
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
       // Network.uti
        DispatchQueue.main.async {
            self.service.widgetServiceCall()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (service.widgetDetail.count)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = URL(string: "com.iappscrazy.stockemc2.widget://")
        {
            self.extensionContext?.open(url, completionHandler: {success in print("called url complete handler: \(success)")})
        }
    }
    
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "widgetcell")!
        if(service.widgetDetail.count > 0){
            let eachwidgetcelldata = service.widgetDetail[indexPath.row]
        
            (cell as! Watchlistcell).configure(widget: eachwidgetcelldata)
        }
        return cell

    }
}
