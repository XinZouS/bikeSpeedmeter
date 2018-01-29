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
    
    
    public func addOnCenterOfParentView(_ v: UIView, offsetX: CGFloat, offsetY: CGFloat, size: CGSize) {
        v.addSubview(self)
        self.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: size.width, height: size.height)
        self.centerXAnchor.constraint(equalTo: v.centerXAnchor, constant: offsetX).isActive = true
        self.centerYAnchor.constraint(equalTo: v.centerYAnchor, constant: offsetY).isActive = true
        //self.backgroundColor = .cyan
        backgroundSize = size
    }
    
    public func addCirclePath(radius r: CGFloat, startAngle st: CGFloat, endAngle nd: CGFloat) {
        circlePath = UIBezierPath(arcCenter: .zero, radius: r, startAngle: st, endAngle: nd, clockwise: true)
        
        let outterLayer = CAShapeLayer()
        outterLayer.path = circlePath.cgPath
        outterLayer.strokeColor = UIColor.cyan.cgColor // circle line color
        outterLayer.fillColor = UIColor.clear.cgColor   // center in circle color
        outterLayer.lineWidth = 10
        outterLayer.lineCap = kCALineCapRound
        outterLayer.position = CGPoint(x: backgroundSize.width * 0.5, y: backgroundSize.height * 0.5)
        self.layer.addSublayer(outterLayer)
    }
    
    
    
}
