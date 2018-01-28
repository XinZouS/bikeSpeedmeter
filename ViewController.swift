//
//  ViewController.swift
//  AudioDemo
//
//  Created by Xin Zou on 1/11/18.
//  Copyright © 2018 Xin Zou. All rights reserved.
//

import UIKit
import AVFoundation

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

    private var engine: AVAudioEngine!      //The Audio Engine
    private var player: AVAudioPlayerNode!  //The Player of the audiofile
    private var file = AVAudioFile()        //Where we're going to store the audio file
    private var timer: Timer?               //Timer to update the meter every 0.1 ms
    
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
        
        engine = AVAudioEngine()
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        let inputNode = engine.inputNode as AVAudioInputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            let dataFloatChannel = buffer.floatChannelData!
            let dataptr = dataFloatChannel.pointee
            let datum = dataptr[Int(buffer.frameLength) - 1]
            
            self.volumeFloat = fabs(datum) * 10
            self.volumePeakValue = max(self.volumePeakValue, self.volumeFloat)
        }
        
        engine.prepare()
        do {
            try engine.start()
        } catch let err {
            print("audioEngine couldn't start because of an error: \(err)")
        }        
        
        //start timer to update the meter
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

