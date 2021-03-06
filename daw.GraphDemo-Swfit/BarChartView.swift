//
//  BarChartView.swift
//  daw.GraphDemo-Swfit
//
//  Created by Da.W on 2018/9/21.
//  Copyright © 2018年 daw. All rights reserved.
//

import UIKit

class BarChartView: UIView {

    /// 柱状图最大高度
    private var barMaxHeight:CGFloat?
    /// 柱状图间距
    private var barSpacing:CGFloat?
    /// 图表宽度
    var chartWidth:CGFloat = 286
    /// 图表高度
    var chartHeight:CGFloat = 155
    /// 柱形图宽度
    var barWidth:CGFloat = 10
    /// 数据字体大小
    var dataFontSize:CGFloat = 12
    /// 类型字体大小
    var dataTypeFontSize:CGFloat = 12
    /// 默认颜色
    var defaultColor:UIColor = UIColor.white
    /// 颜色数组
    var colorArray:Array<UIColor> = Array.init()
    /// 数据类型/数据名数组
    var dataTypeArray:Array<String> = Array.init()
    /// 数据数组
    var dataArray:Array<CGFloat> = Array.init()
    
    /// 柱状图距离顶部距离
    private let marginTop:CGFloat = 0
    
    func reloadView() {
        while self.subviews.count>0 {
            self.subviews.last?.removeFromSuperview()
        }
        drawViews()
    }
    
    func drawViews(){
        barMaxHeight = chartHeight-marginTop;
        barSpacing = (chartWidth - barWidth * CGFloat(dataArray.count))/CGFloat(dataArray.count+1);
        
        let line:UIView = UIView.init(frame: CGRect.init(x: (self.frame.size.width-chartWidth)/2, y: chartHeight, width: chartWidth, height: 1))
        line.backgroundColor=UIColor.withHex(hexInt: 0xffffff)
        self.addSubview(line)
        
        var amount:CGFloat = 1
        for count in dataArray {
            amount += count
        }
        if amount>1{
            amount -= 1
        }
        
        for i:Int in 0..<dataArray.count {
            let count = dataArray[i]
            var frame:CGRect = CGRect.init(x: 0, y: marginTop, width: barWidth, height: barMaxHeight!)
            let location = CGFloat(dataArray.count - 1) / 2.0 - CGFloat(i)
            frame.origin.x = self.center.x - (barSpacing! + barWidth) * location - barWidth * 0.5;
            
            let barBGView:UIView = UIView.init(frame: frame)
            barBGView.layer.cornerRadius = barWidth/2
            barBGView.layer.masksToBounds = true
            barBGView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1)
            self.addSubview(barBGView)
            
            var barframe = barBGView.bounds
            barframe.size.height = count/amount * barMaxHeight!
            barframe.origin.y=chartHeight-barframe.size.height;
            let barView:UIView = UIView.init(frame: barframe)
            barView.layer.cornerRadius = barWidth/2
            barView.layer.masksToBounds = true
            barBGView.addSubview(barView)
            
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
            let countLabelFrame:CGRect = CGRect.init(x: frame.origin.x-25, y: barframe.origin.y-17, width: barWidth+50, height: 15)
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
            let typeLabelFrame:CGRect = CGRect.init(x: frame.origin.x-40, y: chartHeight+7, width: barWidth+80, height: 13)
            let typeLabel:UILabel = UILabel.init(frame: typeLabelFrame)
            typeLabel.textAlignment = .center;
            typeLabel.textColor=UIColor.withHex(hexInt: 0xffffff)
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
