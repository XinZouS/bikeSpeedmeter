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
    
    private var engine: AVAudioEngine!      //The Audio Engine
    private var player: AVAudioPlayerNode!  //The Player of the audiofile
    private var file = AVAudioFile()        //Where we're going to store the audio file
    private var timer: Timer?               //Timer to update the meter every 0.1 ms
    private var volumeFloat: Float = 0.0    //Where We're going to store the volume float

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProgressView()
        setupAVAudioEngine()
    }
    
    
    private func setupProgressView() {
        view.addSubview(progressView)
        progressView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 20, topConstent: 150, rightConstent: 20, bottomConstent: 0, width: 0, height: 5)
    }
    
    private func setupAVAudioEngine() {
        //init engine and player
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
            let dataptrptr = buffer.floatChannelData!
            let dataptr = dataptrptr.pointee
            let datum = dataptr[Int(buffer.frameLength) - 1]
            
            self.volumeFloat = fabs(datum)
        }
        
        engine.prepare()
        do {
            try engine.start()
        } catch let err {
            print("audioEngine couldn't start because of an error: \(err)")
        }        
        
        //start timer to update the meter
        timer = Timer.scheduledTimer(timeInterval: 0.1 , target: self, selector: #selector(updateMeter), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateMeter() {
        self.progressView.setProgress(volumeFloat, animated: false)
        
//        if progressView.progress > 0.8{//turn red if the volume is LOUD
//            progressView.tintColor = .red
//        }else{//else green
//            progressView.tintColor = UIColor.green
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

