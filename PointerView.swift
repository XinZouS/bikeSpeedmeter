//
//  Pointer.swift
//  AudioDemo
//
//  Created by Xin Zou on 1/28/18.
//  Copyright © 2018 Xin Zou. All rights reserved.
//

import UIKit


class PointerView: UIView {
    
    public var image: UIImage! {
        didSet{
            pointerImgView.image = image
        }
    }
    
    private let pointerContainerView = UIView()
    private let pointerImgView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        v.backgroundColor = .green 
        return v
    }()
    

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
        pointerImgView.addConstraints(left: nil, top: nil, right: nil, bottom: pointerContainerView.bottomAnchor, leftConstent: nil, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 10, height: 160)
        pointerImgView.centerXAnchor.constraint(equalTo: pointerContainerView.centerXAnchor).isActive = true
    }
    
    public func rotateTo(_ angle: Float) {
        pointerContainerView.transform = CGAffineTransform(rotationAngle: CGFloat(angle * 10))
    }
    

    
    
}
