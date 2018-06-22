//
//  ViewController+UICollectionView.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 1/30/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation

import UIKit
import Charts

class FinancialDataView:UIView {
    
    @IBOutlet weak var barchartView:BarChartView?
    @IBOutlet weak var EPSBarchartView:BarChartView?
    @IBOutlet weak var VolumeBarchartView:BarChartView?
    
    var contentViewSize:CGFloat = 0.0
    
   convenience init() {
        self.init(frame: CGRect.zero)
    
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        let bundle = Bundle(for: type(of: self))

        guard let view = bundle.loadNibNamed("FinacialDetail", owner: self, options: nil)?.first as? UIView else {
            return
        }

        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0).isActive = true

        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        self.layoutIfNeeded()
    }
   
    func loadFinacialData() {
        
        contentViewSize = 0.0
    
        let barView = BarView.init()
        barView.loadBarCharRevenue_earning(barChart: barchartView!, revenue_earnigData: financialData)
        
        let volumeBarView = BarView.init()
        volumeBarView.loadVolumeToBarCharView(chartView: VolumeBarchartView!, volume: DataHandler.consolidatedTradeVolume())
    
        
        let EPSData = EPSChartData.init()
        EPSData.loadEPSBarCHart(chartView: EPSBarchartView!)
    
    }
    
    func setUPBaseViewProperty(view:UIView){
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10.0
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.layer.shadowColor   = UIColor.black.cgColor
        view.layer.shadowOffset  = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius  = 2
       view.layer.masksToBounds = false
        
        contentViewSize = contentViewSize + view.frame.size.height + 8.0
        
        //view.dropShadow()
    }
}
