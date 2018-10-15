//
//  BarView.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 1/29/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import UIKit
import Charts

class BarView {
    var revenue = [BarChartDataEntry]()
    var earnings = [BarChartDataEntry]()
    
    func loadBarCharRevenue_earning(barChart:BarChartView,revenue_earnigData:[Financial]){
        if(revenue_earnigData.count <= 0){
            let chartData = BarChartData(dataSets: [])
            barChart.data = chartData
            return
        }
        var minValue:Double = 0.0
        var maxValue:Double = 0.0
        
        
        let sales = revenue_earnigData
       
        let minYearSale = revenue_earnigData.max(by: { (a, b) -> Bool in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = appDateFormat //Your New Date format as per requirement change it own
        
             guard  let aYear = Int((dateFormatter.date(from: a.year)?.getYear())!) else {
                return false
             }
            
            guard  let bYear = Int((dateFormatter.date(from: b.year)?.getYear())!) else {
                return false
            }
            
            return aYear > bYear
        })
        
        let maxYearSale = revenue_earnigData.max(by: { (a, b) -> Bool in
            guard  let aYear = Int(getDate(date: a.year).getYear()) else {
                return false
            }
            
            guard  let bYear = Int(getDate(date: b.year).getYear()) else {
                return false
            }
            
            return aYear < bYear
        })
        
        
        let minYear:Int     =  Int(getDate(date: minYearSale!.year).getYear())!
        let maxYear:Int     =  Int(getDate(date: maxYearSale!.year).getYear())!
        
      
        let revenue = sales.map { (sale) -> BarChartDataEntry in
            let year:Double     =  Double(getDate(date: sale.year).getYear())!
            return BarChartDataEntry(x:year, y:  Double(sale.revenue!)!)
        }
        let earnings = sales.map { (sale) -> BarChartDataEntry in
            let year:Double     =  Double(getDate(date: sale.year).getYear())!
            return BarChartDataEntry(x:year, y:  Double(sale.earnings!)!)
        }
        
        let revenueBarColor = revenue.map { (entry) -> NSUIColor in
            return entry.y >= 0 ? Utility.green : Utility.red
        }
        
        let earningsBarColor = earnings.map { (entry) -> NSUIColor in
            return entry.y >= 0 ? Utility.appColor : Utility.red
        }
        

        let orderEarnings = sales.sorted { (a, b) -> Bool in
            return (a.earnings! > b.earnings!)
        }
        
        let orderRevenue = sales.sorted { (a, b) -> Bool in
            return (a.revenue! > b.revenue!)
        }
    
        if let value = orderRevenue[0].revenue {
            maxValue = Double(value)!
            if let value = orderEarnings[0].earnings {
                minValue = Double(value)!
            }
        }
        if(orderEarnings.count > 1){
            if let value = orderEarnings[orderEarnings.count - 1].earnings {
                minValue = Double(value)!
            }
        }

        if (minValue > 0){
            minValue = 0;
        }
        
        //maxValue = orderSales
        //minValue = revenueMin?.revenue < earningMin ?  revenueMin : earningMin
        
        barCharSettings(barChart:barChart, maxValue: maxValue + maxValue/2, minValue: minValue * 3 ,minYear:minYear,maxYear:maxYear)
        
        let chartDataSetRevenue = BarChartDataSet(values: revenue, label: "Revenue")
        chartDataSetRevenue.colors = revenueBarColor
        
        let chartDataSetEarning = BarChartDataSet(values: earnings, label: "Earning")
        chartDataSetEarning.colors = earningsBarColor
        
        //        let lineDataSet  = LineChartDataSet(values: earnings, label: "Earning")
        //        lineDataSet.colors = [.blue]
        //
        //        let lineData = LineChartData()
        //        lineData.addDataSet(lineDataSet)
        
        let chartData = BarChartData(dataSets: [chartDataSetRevenue,chartDataSetEarning])
        chartData.setValueFormatter(LargeValueFormatter())
        chartData.barWidth = 0.25
        //        // Set bar chart data to previously created data
        chartData.groupBars(fromX: Double(minYear), groupSpace: 0.20, barSpace: 0.05)
        barChart.data = chartData
    }
    
    private func getDate(date:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = appDateFormat //Your New Date format as per requirement change it own
        let date = dateFormatter.date(from: date)
        return date!
    }
    
    private func barCharSettings(barChart:BarChartView,maxValue:Double,minValue:Double,minYear:Int,maxYear:Int){
        barChart.chartDescription?.text = ""
        barChart.xAxis.labelPosition = .bottom
        
         barChart.xAxis.axisMinimum = Double(minYear)
         barChart.xAxis.axisMaximum = Double(maxYear)
        
        barChart.xAxis.granularity = 1.0
        barChart.fitBars = true
        barChart.leftAxis.axisMinimum = minValue
        barChart.leftAxis.axisMaximum = maxValue
        barChart.leftAxis.valueFormatter = LargeValueFormatter()
        
        barChart.scaleYEnabled = false
        barChart.scaleXEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        barChart.drawBarShadowEnabled = false
        barChart.chartDescription?.enabled = false
        
        barChart.highlighter = nil
        
    
        barChart.rightAxis.enabled = false
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.animate(yAxisDuration: 1.5)
        barChart.layer.cornerRadius = 10.0;
        
        //        let l = barChart.legend
        //        l.horizontalAlignment = .right
        //        l.verticalAlignment = .top
        //        l.orientation = .vertical
        //        l.drawInside = true
        //        l.font = .systemFont(ofSize: 8, weight: .light)
        //        l.yOffset = 10
        //        l.xOffset = 10
        //        l.yEntrySpace = 0
    }
    
    func loadVolumeToBarCharView(chartView:BarChartView,volume:[TradeVolme]){
        if(volume.count <= 0){
            return
        }
        
        let lastValue = volume.last
        
        let revenue = volume.map { (tradeV) -> BarChartDataEntry in
            //let Timestamp     =  price.timeStamp
            return BarChartDataEntry(x:Double(tradeV.Index!), y:  Double(tradeV.Volume!))
            
        }
        let chartDataSetRevenue = BarChartDataSet(values: revenue, label: "Day's trade volume")
        chartDataSetRevenue.colors = [Utility.green]
        
        let data = BarChartData(dataSet: chartDataSetRevenue)
        //data.barWidth = 0.25
        chartView.data = data
        
        chartView.fitBars = true
        
        chartView.chartDescription?.text = ""
        chartView.xAxis.labelPosition = .bottom
        
        chartView.xAxis.axisMaximum = Double((lastValue?.Index)!)
        //chartView.xAxis.axisMinimum = Double((volume.first?.Index)!)
        
        chartView.xAxis.granularity = 1.0
        chartView.fitBars = true
        //chartView.leftAxis.axisMinimum = minValue
        //chartView.leftAxis.axisMaximum = maxValue
        chartView.leftAxis.valueFormatter = LargeValueFormatter()
        
        chartView.scaleYEnabled = false
        chartView.scaleXEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.drawBarShadowEnabled = false
        chartView.chartDescription?.enabled = false
        
        chartView.highlighter = nil
        
        
        
        chartView.rightAxis.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.animate(yAxisDuration: 1.5)
        chartView.layer.cornerRadius = 10.0;
        
        chartView.setNeedsDisplay()
        
        
    }
}
