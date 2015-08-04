//
//  PlaySoundsViewController.swift
//  Recorder
//
//  Created by Andrew Fruth on 7/25/15.
//  Copyright (c) 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!


    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetAudio() {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
    }
    
    func setConditionsAndPlayAudio(#audioRate: Float) {
        audioPlayer.currentTime = 0
        audioPlayer.rate = audioRate
        audioPlayer.play()
    }
    
    func prepareAndPlayAudio(#audioRate: Float) {
        resetAudio()
        setConditionsAndPlayAudio(audioRate: audioRate)
    }
    
    @IBAction func playAudioSlowly(sender: UIButton) {
        prepareAndPlayAudio(audioRate: 0.5)
    }

    @IBAction func playAudioQuickly(sender: UIButton) {
        prepareAndPlayAudio(audioRate: 2.0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    func playAudioWithVariablePitch(pitch: Float){
        resetAudio()
        
        // setting up audioEngine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func stopAllAudio(sender: UIButton) {
        resetAudio()
    }

}
