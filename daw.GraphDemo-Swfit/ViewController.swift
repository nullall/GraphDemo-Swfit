//
//  ViewController.swift
//  daw.GraphDemo-Swfit
//
//  Created by Da.W on 2018/5/28.
//  Copyright © 2018年 daw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var annulusView:AnnulusView?
    var histogramView:HistogramView?
    var barChartView:BarChartView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        annulusView = AnnulusView.init(frame: CGRect.init(x: 0, y: 150, width:MPScreenWidth , height: 300))
        if let annulusView = annulusView{
            annulusView.chartDiameter=150
            annulusView.progressStrokeWidth = 30
            annulusView.dataArray = [123,433,11,234,98]
            annulusView.dataTypeArray = ["おそ","返回","说大大奥所","吾问无为谓","撒旦"]
            annulusView.colorArray = [UIColor.withHex(hexString: "369515"),UIColor.withHex(hexString: "187865"),UIColor.withHex(hexString: "AD1231"),UIColor.withHex(hexString: "999856"),UIColor.withHex(hexString: "b09282")]
            self.view.addSubview(annulusView)
            annulusView.reloadView()
        }
        
//        histogramView = HistogramView.init(frame: CGRect.init(x: 0, y: 500, width:MPScreenWidth , height: 300))
//        self.view.addSubview(histogramView!)
        
        barChartView = BarChartView.init(frame: CGRect.init(x: 0, y: 500, width:MPScreenWidth , height: 300))
        barChartView?.dataArray = [1223,4333,2143]
        barChartView?.dataTypeArray = ["おそ","返回","说大大奥所"]
        barChartView?.reloadView()
        self.view.addSubview(barChartView!)
    }

    @IBAction func reloadAction(_ sender: Any) {
        var dataArray:Array<CGFloat>=Array.init()
        var colorsArray:Array<UIColor>=Array.init()
        var dataTypeArray:Array<String>=Array.init()
        let maxCount = arc4random()%10+1
        for i:Int in 0..<Int(maxCount) {
            dataArray.append(CGFloat(arc4random()%1000))
            colorsArray.append(UIColor.withHex(hexInt: Int32(arc4random()%0xffffff)))
            dataTypeArray.append("\(i)")
        }
        if let annulusView = annulusView{
            annulusView.dataArray = dataArray
            annulusView.colorArray = colorsArray
            annulusView.dataTypeArray = dataTypeArray
            annulusView.reloadView()
        }
        
        if let histogramView = histogramView{
            histogramView.barWidth = min((histogramView.chartWidth-150)/CGFloat(maxCount), 30.0)
            histogramView.dataArray = dataArray
            histogramView.colorArray = colorsArray
            histogramView.dataTypeArray = dataTypeArray
            histogramView.reloadView()
        }
        
        barChartView?.reloadView()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

