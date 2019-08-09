//
//  ViewController.swift
//  AudioTest
//
//  Created by Sivan.Payyadakath on 2019/08/09.
//  Copyright © 2019 Sivan.Payyadakath. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        playButton.isEnabled = false
        stopButton.isEnabled = false
        status.text = "Start Recording"
        
        
        let filemgr = FileManager.default
        
        let dirPaths = filemgr.urls(for: .documentDirectory, in: .userDomainMask)
        
        let soundFileUrl = dirPaths[0].appendingPathComponent("sound.caf")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0
        ] as [String: Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            
        } catch let error as NSError {
            print("audioSessionError \(error.localizedDescription)")
        }
        
        do{
            try audioRecorder = AVAudioRecorder(url: soundFileUrl, settings: recordSettings)
            audioRecorder?.prepareToRecord()
        }
        catch let error as NSError{
            print("prepare recorder error \(error.localizedDescription)")
        }
        
    }

    @IBAction func recordAudio(_ sender: Any) {
        
        if audioRecorder?.isRecording == false {
            print("recording now")
            status.text = "recording in progress....."
            playButton.isEnabled = false
            stopButton.isEnabled = true
            audioRecorder?.record()
        }

    }
    
    @IBAction func playAudio(_ sender: Any) {

        print("trying to play")
        status.text = "playing audio now........"
        if audioRecorder?.isRecording == false {
            recordButton.isEnabled = false
            stopButton.isEnabled = true
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf: audioRecorder!.url)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer?.volume = 1.0
                audioPlayer!.play()

            } catch let error as NSError {
                print("audio player error: \(error.localizedDescription)")
            }
        }
        
    }
    
    @IBAction func stopAudio(_ sender: Any) {
        recordButton.isEnabled = true
        playButton.isEnabled = true
        stopButton.isEnabled = false
        
        status.text = "Recording stopped. "
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioRecorder?.stop()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        status.text = "record a new audio"
        stopButton.isEnabled = false
        recordButton.isEnabled = true
    }
    
}

