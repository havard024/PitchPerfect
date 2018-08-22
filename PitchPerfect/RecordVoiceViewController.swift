//
//  RecordVoiceViewController.swift
//  PitchPerfect
//
//  Created by mac on 8/21/18.
//

import UIKit
import AVFoundation

enum recordVoiceText: String {
    case stop = "Tap to finish recording"
    case start = "Tap to start recording"
}

enum uiState {
    
}

class RecordVoiceViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordVoiceLabel: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var startRecordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureUI(_ isRecording: Bool) {
        self.stopRecordButton.isHidden = !isRecording
        self.startRecordButton.isHidden = isRecording
        self.recordVoiceLabel.text = isRecording ? recordVoiceText.stop.rawValue : recordVoiceText.start.rawValue
    }
    
    @IBAction func startRecording() {
        print("Start Recording.")
        self.recordVoiceLabel.text = recordVoiceText.stop.rawValue
        configureUI(true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording() {
        // NOTE: Not configuring UI back to notRecording state to prevent UI from changing while transitioning. Instead The notRecording state is reset when user transitions back from the next view
        print("Stop Recording.")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not successfull.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlayVoiceViewController
            let recordedAudioUrl = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioUrl
        }
    }
}

