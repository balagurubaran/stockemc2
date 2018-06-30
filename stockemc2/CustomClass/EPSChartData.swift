//
//  EPSChartView.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 2/3/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import Charts

class EPSChartData:NSObject {
    
    
    
    func loadEPSDataView(chartView: PieChartView) {
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //        chartView.legend = l
        
        // entry label styling
        chartView.entryLabelColor = .black
        chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        chartView.chartDescription?.text = "EPS"
    
        //chartView.setExtraOffsets(left: 70, top: -30, right: 70, bottom: 10)
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        let entries = EPSData.map { (eps) -> PieChartDataEntry in
            let displayText = eps.actual >= 0 ? eps.year.description : ("-" +  eps.year.description)
            return PieChartDataEntry(value: abs(eps.actual), label: displayText)
        }
        
        let set = PieChartDataSet(values: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
    
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .decimal
        pFormatter.maximumFractionDigits = 3
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = ""
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 8, weight: .medium))
        data.setValueTextColor(.white)
        
        chartView.data = data
        chartView.highlightValues(nil)

    }
    
    func loadEPSBarCHart(chartView:BarChartView){
        if(EPSData.count <= 0){
            return
        }
        
        barCharSettings(chartView:chartView)
        
        let actualEPSEntry = EPSData.map { (eps) -> BarChartDataEntry in
            return BarChartDataEntry(x:Double(eps.index), y:  eps.actual)
        }
        let estimatedEPSEntry = EPSData.map { (eps) -> BarChartDataEntry in
            return BarChartDataEntry(x:Double(eps.index), y:  eps.estimated)
        }
        
        let actualEPSBarColor = estimatedEPSEntry.map { (entry) -> NSUIColor in
            return entry.y >= 0 ? Utility.green : Utility.red
        }
        
        let estimatedEPSBarColor = estimatedEPSEntry.map { (entry) -> NSUIColor in
            return entry.y >= 0 ? Utility.appColor : Utility.red
        }
        
        
        let actualEPSSet = BarChartDataSet(values: actualEPSEntry, label: "Actual")
        //actualEPSSet.setColor(UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1))
        actualEPSSet.colors = actualEPSBarColor
        
        let estimatedEPSSet = BarChartDataSet(values: estimatedEPSEntry, label: "Estimated")
        //estimatedEPSSet.setColor(UIColor(red: 255/255, green: 102/255, blue: 0/255, alpha: 1))
        estimatedEPSSet.colors = estimatedEPSBarColor
    
        let chartData = BarChartData(dataSets: [estimatedEPSSet,actualEPSSet])
        chartData.setValueFont(.systemFont(ofSize: 13))
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 3
        chartData.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        chartData.barWidth = 0.25 / (4.0/Double(EPSData.count))
        
        //let groupSpace = 0.35 + (0.35 / (4.0/Double(EPSData.count)))
        //let barSpace = 0.05 * (4.0/Double(EPSData.count))
            
        chartData.groupBars(fromX: 0, groupSpace: 0.35, barSpace: 0.05)
    
        //chartData.groupWidth(groupSpace: <#T##Double#>, barSpace: <#T##Double#>)
        
        chartView.data = chartData
    }
    
    
    
    private func barCharSettings(chartView:BarChartView){
        
        //chartView.setExtraOffsets(left: 20, top: -30, right: 20, bottom: 10)
        
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true
        chartView.chartDescription?.text = "Earning per Share"
        
        
        chartView.rightAxis.enabled = false
        chartView.animate(yAxisDuration: 1.5)
        chartView.fitBars = true
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 13)
        xAxis.drawAxisLineEnabled = false
        xAxis.labelTextColor = .lightGray
        xAxis.labelCount = EPSData.count
        xAxis.centerAxisLabelsEnabled = true
        xAxis.granularity = 1
       // xAxis.valueFormatter = self
        xAxis.axisMinimum = 0
        
        let minEstimated = EPSData.min(by: { (a, b) -> Bool in
            
            return (a.estimated < b.estimated)
        })
        
        let minActual = EPSData.min(by: { (a, b) -> Bool in
            
            return (a.actual < b.actual)
        })
        
//        let maxEstimated = EPSData.max(by: { (a, b) -> Bool in
//
//            return (a.estimated < b.estimated)
//        })
//
//        let maxActual = EPSData.max(by: { (a, b) -> Bool in
//
//            return (a.actual < b.actual)
//        })
        
        var min = minActual?.actual
        if((minEstimated?.estimated)! <  (minActual?.actual)!){
            min = minEstimated?.estimated
        }
//
//        var max = minActual?.actual
//        if((maxEstimated?.estimated)! >  (maxEstimated?.actual)!){
//            max = maxEstimated?.estimated
//        }
        
//        print(max!);
        let leftAxis = chartView.leftAxis
        leftAxis.drawLabelsEnabled = true
        leftAxis.spaceTop = 0.25
        leftAxis.spaceBottom = 0.25
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawZeroLineEnabled = false
        leftAxis.zeroLineColor = .gray
        leftAxis.zeroLineWidth = 0.7
        leftAxis.axisMinimum = 0.0
        if(min! < 0.0){
            leftAxis.axisMinimum = min!  + (min!/4)
        }
        
//        if(max! <= 0.0){
//            leftAxis.axisMaximum = 0;
//        }
        
    }
}
//
//extension EPSChartData: IAxisValueFormatter {
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        return EPSQLabels[min(max(Int(value), 0), EPSQLabels.count - 1)]
//    }
//}

