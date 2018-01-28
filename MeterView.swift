//
//  MeterView.swift
//  AudioDemo
//
//  Created by Xin Zou on 1/28/18.
//  Copyright © 2018 Xin Zou. All rights reserved.
//

import UIKit

class MeterView: UIView {
    
    public var startAngle: CGFloat = 0
    public var endAngle: CGFloat = CGFloat.pi
    
    
    private let backgroundView = UIView()
    
    
    public func addOnCenterOfParentView(_ v: UIView, offsetX: CGFloat, offsetY: CGFloat, size: CGSize) {
        v.addSubview(self)
        self.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: size.width, height: size.height)
        self.centerXAnchor.constraint(equalTo: v.centerXAnchor, constant: offsetX).isActive = true
        self.centerYAnchor.constraint(equalTo: v.centerYAnchor, constant: offsetY).isActive = true
        self.backgroundColor = .cyan
    }
    
    
}
