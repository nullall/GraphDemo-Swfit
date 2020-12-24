//
//  AnnulusView.swift
//  daw.GraphDemo-Swfit
//
//  Created by Da.W on 2018/5/28.
//  Copyright © 2018年 daw. All rights reserved.
//

import UIKit

class AnnulusView: UIView {
    /// 每个数据所占比例
    private var scaleArray:Array<CGFloat> = Array.init()
    /// 累加占比
    private var angleArray:Array<CGFloat> = Array.init()
    /// 总的个数
    private var amount:CGFloat = 0
    /// 放置整个图表的View
    private var chartView:UIView?
    
    
    /// 圆形直径
    var chartDiameter:CGFloat = 150
    /// 圆环宽度
    var progressStrokeWidth:CGFloat = 30
    /// 颜色数组
    var colorArray:Array<UIColor> = Array.init()
    /// 数据类型/数据名数组
    var dataTypeArray:Array<String> = Array.init()
    /// 数据数组
    var dataArray:Array<CGFloat>? {
        didSet{
            amount=0
            for count in dataArray! {
                amount += count
            }
            scaleArray.removeAll()
            angleArray.removeAll()
            var angleSum:CGFloat = 0
            angleArray.append(angleSum)
            if amount>0 {
                for count in dataArray! {
                    scaleArray.append(count/amount)
                    angleSum += count/amount
                    angleArray.append(angleSum)
                }
            }
        }
    }
    
    func reloadView() {
        while self.subviews.count>0 {
            self.subviews.last?.removeFromSuperview()
        }
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        initView()
    }
    
    func initView() {
        chartView = UIView.init(frame: CGRect.init(x: (MPScreenWidth - chartDiameter)/2, y: 25, width: chartDiameter, height: chartDiameter))
        self.addSubview(chartView!)
        drawChart()
        addOtherView()

    }
    
    func drawChart() {
        guard scaleArray.count>0 else {
            return
        }
        
        
        /// 中心坐标
        let circleCenter:CGPoint = CGPoint.init(x: (chartView!.bounds.size.width)/2, y: (chartView!.bounds.size.height)/2)
        /// 直径
//        let diam = chartDiameter!
        /// 内环半径
        let radius:CGFloat = (chartDiameter - progressStrokeWidth)/2.0
        
        for i:Int in 0..<scaleArray.count {
            //防止没有设置类型名称导致越界
            if dataTypeArray.count == i{
                dataTypeArray.append("")
            }
            if colorArray.count == i{
                colorArray.append(UIColor.withHex(hexInt: Int32(arc4random()%0xffffff)))
            }
            
            let layer:CAShapeLayer = CAShapeLayer.init()
            layer.frame=chartView!.bounds
            layer.lineWidth = progressStrokeWidth
            layer.fillColor=UIColor.clear.cgColor
            layer.strokeColor = colorArray[i].cgColor;
            chartView!.layer.addSublayer(layer)
            
            let startAngle:CGFloat = 2 * CGFloat.pi * angleArray[i] - CGFloat.pi/4
            let endAngle:CGFloat = 2 * CGFloat.pi * angleArray[i+1] - CGFloat.pi/4
            let bezierPath:UIBezierPath = UIBezierPath.init(arcCenter: circleCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            layer.path = bezierPath.cgPath
            
            //动画效果
            let endAni = CABasicAnimation.init(keyPath: "strokeEnd")
            endAni.fromValue=0
            endAni.toValue=1
            layer.add(endAni, forKey: nil)
            
            //设置其他的内容
            //+5是为了不完全贴合
            let x:CGFloat = chartView!.center.x + (chartDiameter/2+5)*cos(2*CGFloat.pi*angleArray[i] + CGFloat.pi*scaleArray[i] - CGFloat.pi/4)
            let y:CGFloat = chartView!.center.y + (chartDiameter/2+5)*sin(2*CGFloat.pi*angleArray[i] + CGFloat.pi*scaleArray[i] - CGFloat.pi/4)
            
            setData(value: "\(String(format: "%.0f", dataArray![i]))个 \(String(format: "%.2f", scaleArray[i]*100))%", typeName: dataTypeArray[i], color: colorArray[i], origin: CGPoint.init(x: x, y: y))
        }
    }
    
    
    /// 描述信息view的绘制
    ///
    /// - Parameters:
    ///   - value: 数据信息（数量多少，占百分百）
    ///   - typeName: 数据名
    ///   - color: 对应颜色
    ///   - origin: 起始点的位置
    func setData(value:String, typeName:String, color:UIColor, origin:CGPoint) {
        var point = origin
        let width:CGFloat = 100 //整个描述的宽度
        let height:CGFloat = 35 //整个描述的高度
        if point.x<self.center.x {
            point.x = point.x - width
        }
        if (point.y<self.chartView!.center.y) {
            point.y=point.y-height;
        }
        let dataView:UIView = UIView.init(frame: CGRect.init(x: point.x, y: point.y, width: width, height: height))
        self.addSubview(dataView)
        
        //实线
        let solidShapeLayer:CAShapeLayer = CAShapeLayer.init()
        solidShapeLayer.fillColor = UIColor.clear.cgColor
        solidShapeLayer.strokeColor = UIColor.withHex(hexString: "#EEF3F7").cgColor
        solidShapeLayer.lineWidth = 1.0
        let solidShapePath = CGMutablePath()
        if (point.x>self.center.x) {
            if (point.y<chartView!.center.y) {
                solidShapePath.move(to: CGPoint.init(x: 0, y: height))
            }else{
                solidShapePath.move(to: CGPoint.init(x: 0, y: 0))
            }
            solidShapePath.addLine(to: CGPoint.init(x: 13, y: 17))
            solidShapePath.addLine(to: CGPoint.init(x: 100, y: 17))
        }else{
            if (point.y<chartView!.center.y) {
                solidShapePath.move(to: CGPoint.init(x: 100, y: height))
            }else{
                solidShapePath.move(to: CGPoint.init(x: 100, y: 0))
            }
            solidShapePath.addLine(to: CGPoint.init(x: 100-13, y: 17))
            solidShapePath.addLine(to: CGPoint.init(x: 0, y: 17))
        }
        solidShapeLayer.path=solidShapePath
        dataView.layer.addSublayer(solidShapeLayer)
        
        //画实心圆
        let solidLine:CAShapeLayer = CAShapeLayer.init()
        solidLine.fillColor = color.cgColor
        solidLine.strokeColor = color.cgColor
        solidLine.lineWidth = 1.0
        let solidPath = CGMutablePath()
        if (point.x>self.center.x) {
            if (point.y<chartView!.center.y) {
                solidPath.addEllipse(in: CGRect.init(x: 0, y: height-3, width: 3, height: 3))
            }else{
                solidPath.addEllipse(in: CGRect.init(x: 0, y: 0, width: 3, height: 3))
            }
        }else{
            if (point.y<chartView!.center.y) {
                solidPath.addEllipse(in: CGRect.init(x: 100-3, y: height-3, width: 3, height: 3))
            }else{
                solidPath.addEllipse(in: CGRect.init(x: 100-3, y: 0, width: 3, height: 3))
            }
        }
        solidLine.path = solidPath;
        dataView.layer.addSublayer(solidLine)
        
        //数据信息
        let dataLabel:UILabel = UILabel.init()
        let dataTypeLabel:UILabel = UILabel.init()
        dataView.addSubview(dataLabel)
        dataView.addSubview(dataTypeLabel)
        if (point.x>self.center.x) {
            dataLabel.textAlignment = .right;
            dataTypeLabel.textAlignment = .right;
            dataLabel.frame=CGRect.init(x: 13, y: 0, width: 100-13, height: 16)
            dataTypeLabel.frame=CGRect.init(x: 13, y: 18, width: 100-13, height: 16)
        }else{
            dataLabel.textAlignment = .left;
            dataTypeLabel.textAlignment = .left;
            dataLabel.frame=CGRect.init(x: 0, y: 0, width: 100-13, height: 16)
            dataTypeLabel.frame=CGRect.init(x: 0, y: 18, width: 100-13, height: 16)
        }
        dataLabel.font=UIFont.systemFont(ofSize: 10)
        dataTypeLabel.font=UIFont.systemFont(ofSize: 10)
        dataLabel.textColor=UIColor.withHex(hexString: "#7C7C7C")
        dataTypeLabel.textColor=UIColor.withHex(hexString: "#b2b2b2")
        dataLabel.text=value
        dataTypeLabel.text=typeName
        
        //动画效果
        let endAni = CABasicAnimation.init(keyPath: "strokeEnd")
        endAni.fromValue=0
        endAni.toValue=1
        endAni.duration=0.25
        solidShapeLayer.add(endAni, forKey: nil)
        
        dataLabel.alpha=0
        dataTypeLabel.alpha=0
        UIView.animate(withDuration: 0.3) {
            dataLabel.alpha=1
            dataTypeLabel.alpha=1
        }
        
    }
    
    /// 添加其他的一些VIEW
    func addOtherView() {
        let amountLabel = UILabel.init(frame: CGRect.init(x: 0, y: (chartDiameter-15)/2, width: chartDiameter, height: 15))
        amountLabel.textColor = UIColor.withHex(hexString: "#575757")
        amountLabel.textAlignment = .center
        amountLabel.font=UIFont.systemFont(ofSize: 13)
        amountLabel.text="共\(amount)个"
        chartView!.addSubview(amountLabel)
        amountLabel.alpha=0
        UIView.animate(withDuration: 0.3) {
            amountLabel.alpha=1
        }
    }
    

}
