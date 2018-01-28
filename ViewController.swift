//
//  ViewController.swift
//  AudioDemo
//
//  Created by Xin Zou on 1/11/18.
//  Copyright © 2018 Xin Zou. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    let progressView: UIProgressView = {
        let v = UIProgressView()
        v.progressViewStyle = .default
        v.tintColor = .cyan
        v.trackTintColor = .lightGray
        v.progress = 0.3
        return v
    }()
    
    let averageLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        return l
    }()
    
    let countLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 20)
        return l
    }()

    private let audioEngine = AudioEngine()
    private var timer : Timer!
    
    private var volumeFloat: Float = 0.0    //Where We're going to store the volume float
    private var volumeAverage: Float = 0.0
    private var volumes = [Float](repeating: 0.0, count: 20)
    private var volumeSum: Float = 0.0
    private var volumeCurrIdx: Int = 0
    private var volumePeakValue: Float = 0.0
    private var volumePeakCount: Int = 0 {
        didSet{
            //
        }
    }

    let pointer = PointerView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProgressView()
        setupLabels()
        setupAVAudioEngine()
        
        setupPointerView()
    }
    
    
    private func setupProgressView() {
        view.addSubview(progressView)
        progressView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 20, topConstent: 150, rightConstent: 20, bottomConstent: 0, width: 0, height: 5)
    }
    
    private func setupLabels() {
        view.addSubview(averageLabel)
        averageLabel.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: nil, bottom: nil, leftConstent: 60, topConstent: 200, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        view.addSubview(countLabel)
        countLabel.addConstraints(left: nil, top: view.topAnchor, right: view.rightAnchor, bottom: nil, leftConstent: nil, topConstent: 200, rightConstent: 60, bottomConstent: 0, width: 0, height: 0)
    }

    private func setupAVAudioEngine() {
        audioEngine.sensibility = 5
        audioEngine.setupAVAudioEngine { (getVolum) in
            self.volumeFloat = getVolum
        }
        timer = Timer.scheduledTimer(timeInterval: 0.05 , target: self, selector: #selector(updateMeter), userInfo: nil, repeats: true)
    }
    
    @objc func updateMeter() { // call by timer
        if volumeFloat > 0.1 {
            volumePeakCount += (volumeFloat > volumeAverage) ? 1 : 0
            countLabel.text = "cnt = \(volumePeakCount)"
        }
        getAverage()

        self.progressView.setProgress(volumeFloat, animated: false)
        pointer.rotateTo(volumeFloat)
    }
    
    private func getAverage() {
        let len = volumes.count
        volumeSum -= volumes[volumeCurrIdx]
        volumes[volumeCurrIdx] = volumeFloat
        volumeSum += volumeFloat
        volumeAverage = volumeSum / Float(volumes.count)
        averageLabel.text = "avg = \(volumeAverage)"
        volumeCurrIdx = (volumeCurrIdx + 1) % len
    }
    
    private func setupPointerView() {
        pointer.addPointerInCenterOf(self.view)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

