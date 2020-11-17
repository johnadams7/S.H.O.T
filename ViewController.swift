//
//  ViewController.swift
//  S.H.O.T.
//
//  Created by John Adams on 11/7/20.
//

import UIKit
import Foundation
import CoreBluetooth
import Charts

class ViewController: UIViewController, ChartViewDelegate {
    
    let BTVC = BluetoothViewController()
    
    
    var lineChart = LineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineChart.delegate = self
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lineChart.frame = CGRect(x: 0, y:0,
                                 width: 1000,//self.view.frame.size.width,
                                 height: 600)//self.view.frame.size.width)
        lineChart.center = view.center
        view.addSubview(lineChart)
        
        let data = LineChartData()
        var chartEntries1 = [ChartDataEntry]()

        for x in 0..<350 {
          
            chartEntries1.append(ChartDataEntry(x: Double(x), y: Double(Xs[x])))
        
        }
        let line1 = LineChartDataSet(entries: chartEntries1, label: "Header")
        data.addDataSet(line1)
        line1.colors = ChartColorTemplates.liberty()
        line1.circleRadius = CGFloat.init(0.2)
        
        
        var chartEntries2 = [ChartDataEntry]()
        
        for x in 0..<350 {
          
            chartEntries2.append(ChartDataEntry(x: Double(x), y: Double(Ys[x])))
        
        }
        let line2 = LineChartDataSet(entries: chartEntries2, label: "Pitch")
        data.addDataSet(line2)
        line2.colors = ChartColorTemplates.joyful()
        line2.circleRadius = CGFloat(0.2)
        
       
        var chartEntries3 = [ChartDataEntry]()
        
        for x in 0..<350 {
          
            chartEntries3.append(ChartDataEntry(x: Double(x), y: Double(Zs[x])))
        
        }
        let line3 = LineChartDataSet(entries: chartEntries3, label: "Roll")
        data.addDataSet(line3)
        line3.colors = ChartColorTemplates.colorful()
        line3.circleRadius = CGFloat(0.2)
        
        lineChart.data = data
    
        
       /* var entries = [ChartDataEntry]()
        
        for x in 0..<350 {
          
            entries.append(ChartDataEntry(x: Double(x), y: Double(Zs[x])))
            print(entries)
            
        }
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.liberty()
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }*/
    
    
}
}
