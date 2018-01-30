//
//  MeterView.swift
//  AudioDemo
//
//  Created by Xin Zou on 1/28/18.
//  Copyright © 2018 Xin Zou. All rights reserved.
//

import UIKit

class MeterView: UIView {
    
    private var circlePath: UIBezierPath!
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
    
    public func addCirclePath(radius r: CGFloat, startAngle st: CGFloat, endAngle nd: CGFloat) {
        circlePath = UIBezierPath(arcCenter: .zero, radius: r, startAngle: st, endAngle: nd, clockwise: true)
        
        let outterLayer = CAShapeLayer()
        outterLayer.path = circlePath.cgPath
        outterLayer.strokeColor = UIColor.cyan.cgColor // circle line color
        outterLayer.fillColor = UIColor.clear.cgColor   // center in circle color
        outterLayer.lineWidth = 10
        outterLayer.lineCap = kCALineCapRound
        outterLayer.position = backgroundCenter
        self.layer.addSublayer(outterLayer)
        
        addScales(length: 40, step: 10, outerRadius: r - 15, startAngle: st, endAngle: nd, pinHeigh: 30, pinWidth: 5, color: .white)
        addScales(length: 40, step: 5, outerRadius: r - 10, startAngle: st, endAngle: nd, pinHeigh: 15, pinWidth: 2, color: .white)
        
    }
    
    
    
    /// length: Full len of scale; step: min step to devide; mark: bigger mark step;
    private func addScales(length: CGFloat, step: CGFloat, outerRadius r: CGFloat, startAngle st: CGFloat, endAngle nd: CGFloat, pinHeigh: CGFloat, pinWidth: Int, color: UIColor) {
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
        self.layer.addSublayer(shapeLayerDash)
    }
    
    
    
}
