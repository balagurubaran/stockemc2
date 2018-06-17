//
//  CandleStickChartViewController.swift
//  ChartsDemo-iOS
//
//  Created by Jacob Christie on 2017-07-09.
//  Copyright © 2017 jc. All rights reserved.
//

import UIKit
import Charts

class CandleStickChart {

    func loadCandelChart(chartView:CandleStickChartView,revenue_earnigData:[Financial]){
    
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = false
        chartView.setScaleEnabled(true)
        chartView.maxVisibleCount = 200
        chartView.pinchZoomEnabled = true
        
        chartView.legend.horizontalAlignment = .right
        chartView.legend.verticalAlignment = .top
        chartView.legend.orientation = .vertical
        chartView.legend.drawInside = false
        chartView.legend.font = UIFont(name: "HelveticaNeue-Light", size: 10)!
        
        chartView.leftAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.leftAxis.spaceTop = 0.3
        chartView.leftAxis.spaceBottom = 0.3
        chartView.leftAxis.axisMinimum = 0
        
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = UIFont(name: "HelveticaNeue-Light", size: 10)!
        chartView.data = setDataCount(DataHandler.getThe30DayPrice().count, range:20)
    }
   
    
    func setDataCount(_ count: Int, range: UInt32)->BarLineScatterCandleBubbleChartData {
//        var i = 0
//        let yVals1 = DataHandler.getThe30DayPrice().map { (sale) -> CandleChartDataEntry in
//
//            //return BarChartDataEntry(x:year, y:  Double(sale.revenue!)!)
//            let mult = range + 1
//            let val = Double(20 + mult)//Double(sale.high!)
//            let high = sale.high!
//            let low = sale.low!
//            let open = sale.open!
//            let close = sale.close!
//            let even = i % 2 == 0
//            i = i + 1
//            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close, icon: UIImage(named: "icon")!)
//        }
 var i = 0
         let yVals1 = DataHandler.getThe30DayPrice().map { (sale) -> CandleChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(40) + mult)
            let high = sale.high!
            let low = sale.low!
            let open = sale.open!
            let close = sale.close!
            let even = i % 2 == 0
            i = i + 1
            return CandleChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: even ? val + open : val - open, close: even ? val - close : val + close, icon: UIImage(named: "icon")!)
        }

        let set1 = CandleChartDataSet(values: yVals1, label: "Data Set")
        set1.axisDependency = .left
        set1.setColor(UIColor(white: 80/255, alpha: 1))
        set1.drawIconsEnabled = false
        set1.shadowColor = .darkGray
        set1.shadowWidth = 0.7
        set1.decreasingColor = .red
        set1.decreasingFilled = true
        set1.increasingColor = UIColor(red: 122/255, green: 242/255, blue: 84/255, alpha: 1)
        set1.increasingFilled = false
        set1.neutralColor = .blue
        
        return CandleChartData(dataSet: set1)
       
    }
}
