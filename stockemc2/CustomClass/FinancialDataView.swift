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
    @IBOutlet weak var scrollview: UIScrollView!
    
    var contentViewSize:CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bundle = Bundle(for: type(of: self))

        guard let view = bundle.loadNibNamed("FinacialDetail", owner: self, options: nil)?.first as? UIView else {
            return
        }
        view.frame = CGRect.init(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: frame.size.width, height: frame.size.height - 20))
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
        
        self.addSubview(view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    func loadFinacialData()->UIView {
        scrollview.scrollToTop()
        contentViewSize = 0.0
    
        let barView = BarView.init()
        setUPBaseViewProperty(view: barchartView!)
        barView.loadBarCharRevenue_earning(barChart: barchartView!, revenue_earnigData: financialData)
        
        let volumeBarView = BarView.init()
        setUPBaseViewProperty(view: VolumeBarchartView!)
        volumeBarView.loadVolumeToBarCharView(chartView: VolumeBarchartView!, volume: DataHandler.consolidatedTradeVolume())
        
//        let candle = CandleStickChart.init()
//        candle.loadCandelChart(chartView: barchartView!, revenue_earnigData: financialData)
        
        let EPSData = EPSChartData.init()
        setUPBaseViewProperty(view: EPSBarchartView!)
        EPSData.loadEPSBarCHart(chartView: EPSBarchartView!)
    
        //barchartView?.dropShadow()
        //EPSBarchartView?.dropShadow()
//        if(scrollview.frame.size.height < contentViewSize){
//            contentViewSize = contentViewSize - scrollview.frame.size.height;
//        }
        scrollview.contentSize = CGSize.init(width: self.frame.size.width, height: contentViewSize + 80)
        return self
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
