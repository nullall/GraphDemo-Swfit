//
//  HistogramView.swift
//  daw.GraphDemo-Swfit
//
//  Created by Da.W on 2018/5/29.
//  Copyright © 2018年 daw. All rights reserved.
//

import UIKit

class HistogramView: UIView {
    /// 柱状图最大高度
    private var barMaxHeight:CGFloat?
    /// 柱状图间距
    private var barSpacing:CGFloat?
    /// 图表宽度
    var chartWidth:CGFloat = 286
    /// 图表高度
    var chartHeight:CGFloat = 155
    /// 柱形图宽度
    var barWidth:CGFloat = 30
    /// 数据字体大小
    var dataFontSize:CGFloat = 12
    /// 类型字体大小
    var dataTypeFontSize:CGFloat = 10
    /// 默认颜色
    var defaultColor:UIColor = UIColor.orange
    /// 颜色数组
    var colorArray:Array<UIColor> = Array.init()
    /// 数据类型/数据名数组
    var dataTypeArray:Array<String> = Array.init()
    /// 数据数组
    var dataArray:Array<CGFloat> = Array.init()

    func reloadView() {
        while self.subviews.count>0 {
            self.subviews.last?.removeFromSuperview()
        }
        drawViews()
    }
    
    func drawViews(){
        barMaxHeight = chartHeight-40;
        barSpacing = (chartWidth - barWidth * CGFloat(dataArray.count))/CGFloat(dataArray.count+1);
        
        let line:UIView = UIView.init(frame: CGRect.init(x: (self.frame.size.width-chartWidth)/2, y: chartHeight, width: chartWidth, height: 1))
        line.backgroundColor=UIColor.withHex(hexInt: 0x999999)
        self.addSubview(line)
        
        var maxCount:CGFloat = 1
        for count in dataArray {
            maxCount = max(maxCount, count)
        }
        
        for i:Int in 0..<dataArray.count {
            let count = dataArray[i]
            var frame:CGRect = CGRect.init(x: 0, y: 0, width: barWidth, height: 0)
            let location = CGFloat(dataArray.count - 1) / 2.0 - CGFloat(i)
            frame.origin.x = self.center.x - (barSpacing! + barWidth) * location - barWidth * 0.5;
            frame.size.height=count/maxCount * barMaxHeight!;
            frame.origin.y=chartHeight-frame.size.height;
            let barView:UIView = UIView.init(frame: frame)
            self.addSubview(barView)
            
            let layer:CAShapeLayer = CAShapeLayer.init()
            let bp:UIBezierPath = UIBezierPath.init(rect: barView.bounds)
            layer.path=bp.cgPath;
            
            if i<colorArray.count {
                layer.strokeColor=colorArray[i].cgColor;
                layer.fillColor=colorArray[i].cgColor;
            }else{
                layer.strokeColor=defaultColor.cgColor;
                layer.fillColor=defaultColor.cgColor;
            }
            barView.layer.addSublayer(layer)
            //动画效果
            var fromframe = barView.bounds
            fromframe.origin.y=barView.bounds.size.height;
            fromframe.size.height=0;
            
            let fillAnimation:CABasicAnimation = CABasicAnimation.init(keyPath: "path")
            fillAnimation.duration = 0.3;
            fillAnimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
            fillAnimation.fillMode = kCAFillModeForwards;
            fillAnimation.isRemovedOnCompletion = false;
            fillAnimation.fromValue = UIBezierPath.init(rect: fromframe).cgPath
            fillAnimation.toValue = UIBezierPath.init(rect: barView.bounds).cgPath
            layer.add(fillAnimation, forKey: nil)

            /**个数label*/
            let countLabelFrame:CGRect = CGRect.init(x: frame.origin.x-15, y: frame.origin.y-17, width: barWidth+30, height: 15)
            let countLabel:UILabel = UILabel.init(frame: countLabelFrame)
            countLabel.textAlignment = .center
            if (i<colorArray.count) {
                countLabel.textColor=colorArray[i]
            }else{
                countLabel.textColor = defaultColor
            }
            countLabel.font=UIFont.systemFont(ofSize: dataFontSize)
            countLabel.text="\(String(format: "%.0f", count))个"
            self.addSubview(countLabel)
            //显示动画
            countLabel.alpha=0
            UIView.animate(withDuration: 0.3) {
                countLabel.alpha=1
            }
            
            /**数据类型标题*/
            let typeLabelFrame:CGRect = CGRect.init(x: frame.origin.x-30, y: chartHeight+7, width: barWidth+60, height: 13)
            let typeLabel:UILabel = UILabel.init(frame: typeLabelFrame)
            typeLabel.textAlignment = .center;
            typeLabel.textColor=UIColor.withHex(hexInt: 0x7c7c7c)
            typeLabel.font=UIFont.systemFont(ofSize: dataTypeFontSize)
            if (i<dataTypeArray.count) {
                typeLabel.text=dataTypeArray[i];
            }else{
                typeLabel.text="---";
            }
            self.addSubview(typeLabel)
            
        }
        
    }

}
