//
//  PlayVoiceViewController.swift
//  PitchPerfect
//
//  Created by mac on 8/21/18.
//

import UIKit
import AVFoundation

class PlayVoiceViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var recordANewSoundButton: UIButton!

    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case fast = 0, slow, chipmunk, vader, reverb, echo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        
        // Hide back button since view has custom back button inside the view
        navigationItem.hidesBackButton = true
        
        // Set title to fill empty navigation bar
        navigationItem.title = "Pitch Perfect"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    // MARK: Actions
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func pauseButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }
    
    @IBAction func recordANewSoundClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
