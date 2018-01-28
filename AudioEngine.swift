//
//  AudioEngine.swift
//  AudioDemo
//
//  Created by Xin Zou on 1/28/18.
//  Copyright © 2018 Xin Zou. All rights reserved.
//

import Foundation
import AVFoundation

class AudioEngine: NSObject {
    
    private var engine: AVAudioEngine!      //The Audio Engine
    private var player: AVAudioPlayerNode!  //The Player of the audiofile
    private var file = AVAudioFile()        //Where we're going to store the audio file
    private var volumeFloat: Float = 0.0
    
    public var sensibility: Float = 10.0
    
    
    override init() {
        super.init()
        
        
    }
    
    /// didUpdate: return the current volum float value
    public func setupAVAudioEngine(didUpdate: @escaping((Float) -> Void)) {
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
            
            self.volumeFloat = fabs(datum) * self.sensibility
            didUpdate(self.volumeFloat)
        }
        
        engine.prepare()
        do {
            try engine.start()
        } catch let err {
            print("audioEngine couldn't start because of an error: \(err)")
        }
        
    }
    
    
}


