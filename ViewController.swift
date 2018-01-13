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
    
    var engine: AVAudioEngine!      //The Audio Engine
    var player: AVAudioPlayerNode!  //The Player of the audiofile
    var file = AVAudioFile()        //Where we're going to store the audio file
    var timer: Timer?               //Timer to update the meter every 0.1 ms
    var volumeFloat:Float = 0.0     //Where We're going to store the volume float

    
    
    
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
        player = AVAudioPlayerNode()
        
        //Look for the audiofile on the project
        let path = Bundle.main.path(forResource: "Trouble_Is_A_Friend", ofType: "mp3")!
        let url = NSURL.fileURL(withPath: path)
        
        //create the AVAudioFile
        let file = try? AVAudioFile(forReading: url)
        let buffer = AVAudioPCMBuffer(pcmFormat: file!.processingFormat, frameCapacity: AVAudioFrameCount(file!.length))
        do {
            //Do it
            try file!.read(into: buffer!)
        } catch _ {
        }
        
        engine.attach(player)
        engine.connect(player, to: engine.mainMixerNode, format: buffer!.format)

        
        //installTap with a bufferSize of 1024 with the processingFormat of the current audioFile on bus 0
        engine.mainMixerNode.installTap(onBus:0, bufferSize: 1024, format: file?.processingFormat) {
            (buffer : AVAudioPCMBuffer!, time : AVAudioTime!) in
            
            let dataptrptr = buffer.floatChannelData!           //Get buffer of floats
            let dataptr = dataptrptr.pointee
            let datum = dataptr[Int(buffer.frameLength) - 1]    //Get a single float to read
            
            //store the float on the variable
            self.volumeFloat = fabs((datum))
        }
        
        
        //Loop the audio file for demo purposes
        player.scheduleBuffer(buffer!, at: nil, options: AVAudioPlayerNodeBufferOptions.loops, completionHandler: nil)
        
        engine.prepare()
        do {
            try engine.start()
        } catch _ {
        }
        
        player.play()


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

