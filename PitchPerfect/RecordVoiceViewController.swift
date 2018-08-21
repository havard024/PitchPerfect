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

class RecordVoiceViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordVoiceLabel: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var startRecordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recordVoiceLabel.text = recordVoiceText.start.rawValue
        self.stopRecordButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startRecording() {
        print("Start Recording.")
        self.recordVoiceLabel.text = recordVoiceText.stop.rawValue
        self.stopRecordButton.isHidden = false
        self.startRecordButton.isHidden = true
        
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
        print("Stop Recording.")
        self.recordVoiceLabel.text = recordVoiceText.start.rawValue
        self.stopRecordButton.isHidden = true
        self.startRecordButton.isHidden = false
        
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

