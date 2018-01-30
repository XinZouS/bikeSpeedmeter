//
//  Pointer.swift
//  AudioDemo
//
//  Created by Xin Zou on 1/28/18.
//  Copyright © 2018 Xin Zou. All rights reserved.
//

import UIKit


class PointerView: UIView {
    
    private var startingAngle: CGFloat = 0
    
    private let pointerContainerView = UIView()
    private let pointerImgView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        //v.backgroundColor = .orange
        return v
    }()
    
    /// 0=12:00, 1/2pi=3:00, pi=6:00, -1/2pi=9:00
    public func setStartingAngle(_ a: CGFloat) {
        startingAngle = a
    }
    
    public func setPointerImage(_ img: UIImage, shadowColor: UIColor?, shadowRadius: CGFloat?) {
        pointerImgView.image = img
        if let clr = shadowColor {
            pointerImgView.layer.shadowColor = clr.cgColor
            pointerImgView.layer.shadowRadius = shadowRadius ?? 0.0
            pointerImgView.layer.shadowOpacity = 1
        }
    }
    
    public func addPointerInCenterOf(_ parentView: UIView) {
        parentView.addSubview(pointerContainerView)
        pointerContainerView.translatesAutoresizingMaskIntoConstraints = false
        pointerContainerView.centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 0).isActive = true
        pointerContainerView.centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: 0).isActive = true
        pointerContainerView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        pointerContainerView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pointerContainerView.backgroundColor = .yellow
        
        pointerContainerView.addSubview(pointerImgView)
        pointerImgView.translatesAutoresizingMaskIntoConstraints = false
        pointerImgView.addConstraints(left: nil, top: nil, right: nil, bottom: pointerContainerView.bottomAnchor, leftConstent: nil, topConstent: 0, rightConstent: 0, bottomConstent: -10, width: 50, height: 180)
        pointerImgView.centerXAnchor.constraint(equalTo: pointerContainerView.centerXAnchor).isActive = true
    }
    
    public func rotateTo(_ angle: Float) {
        pointerContainerView.transform = CGAffineTransform(rotationAngle: startingAngle + CGFloat(angle * 10))
    }
    

    
    
}
