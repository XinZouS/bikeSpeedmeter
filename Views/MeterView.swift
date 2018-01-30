//
//  MeterView.swift
//  AudioDemo
//
//  Created by Xin Zou on 1/28/18.
//  Copyright © 2018 Xin Zou. All rights reserved.
//

import UIKit

class MeterView: UIView {
    
    //private var circlePath: UIBezierPath!
    private let backgroundView = UIView()
    private var backgroundSize = CGSize()
    private var backgroundCenter = CGPoint(x: 0, y: 0)
    
    
    public func addOnCenterOfParentView(_ v: UIView, offsetX: CGFloat, offsetY: CGFloat, size: CGSize) {
        v.addSubview(self)
        self.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: size.width, height: size.height)
        self.centerXAnchor.constraint(equalTo: v.centerXAnchor, constant: offsetX).isActive = true
        self.centerYAnchor.constraint(equalTo: v.centerYAnchor, constant: offsetY).isActive = true
        //self.backgroundColor = .cyan
        backgroundSize = size
        backgroundCenter = CGPoint(x: backgroundSize.width * 0.5, y: backgroundSize.height * 0.5)
    }
    
    public func addCirclePath(radius r: CGFloat, lineWidth: CGFloat, startAngle st: CGFloat, endAngle nd: CGFloat, color: UIColor) {
        let circlePath = UIBezierPath(arcCenter: .zero, radius: r, startAngle: st, endAngle: nd, clockwise: true)
        
        let outterLayer = CAShapeLayer()
        outterLayer.path = circlePath.cgPath
        outterLayer.strokeColor = color.cgColor // circle line color
        outterLayer.fillColor = UIColor.clear.cgColor   // center in circle color
        outterLayer.lineWidth = lineWidth
        outterLayer.lineCap = kCALineCapRound
        outterLayer.position = backgroundCenter
        self.layer.addSublayer(outterLayer)        
    }
    
    
    
    /// length: Full len of scale; step: min step to devide; mark: bigger mark step;
    public func addScales(length: CGFloat, step: CGFloat, radius r: CGFloat, startAngle st: CGFloat, endAngle nd: CGFloat, pinHeigh: CGFloat, pinWidth: Int, color: UIColor, shadowColor: UIColor?, shadowRadius: CGFloat?) {
        let path = UIBezierPath(arcCenter: .zero, radius: r, startAngle: st, endAngle: nd, clockwise: true)
        let shapeLayerDash = CAShapeLayer()
        shapeLayerDash.path = path.cgPath
        shapeLayerDash.position = CGPoint(x: backgroundSize.width * 0.5, y: backgroundSize.height * 0.5)
        shapeLayerDash.fillColor = UIColor.clear.cgColor
        shapeLayerDash.strokeColor = color.cgColor
        shapeLayerDash.lineWidth = pinHeigh
        // full length of arc is 740
        let arcLen: CGFloat = r * abs(nd - st) //(2 * pi * r) * ((nd - st) / 2 * pi)
        let stepPx = Int(arcLen / (length / step)) - pinWidth
        shapeLayerDash.lineDashPattern = [NSNumber(value: pinWidth), NSNumber(value: stepPx)]
        shapeLayerDash.lineCap = kCALineCapButt
        if let clr = shadowColor {
            shapeLayerDash.shadowColor = clr.cgColor
            shapeLayerDash.shadowRadius = shadowRadius ?? 3.0
            shapeLayerDash.shadowOpacity = 1
        }
        self.layer.addSublayer(shapeLayerDash)
    }
    
    public func addScaleLabels(length: CGFloat, step: CGFloat, angle: CGFloat, radius: CGFloat, color: UIColor, shadowColor: UIColor?, shadowRadius: CGFloat?) {
        
    }
    
    
}
