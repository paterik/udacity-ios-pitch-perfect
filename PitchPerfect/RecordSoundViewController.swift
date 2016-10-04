//
//  RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Patrick Paechnatz on 03.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    //
    // MARK: Outlets
    //
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackViewRow1: UIStackView!
    @IBOutlet weak var innerStackViewRow2: UIStackView!
    @IBOutlet weak var innerStackViewRow3: UIStackView!
    
    //
    // MARK: Internal Constants
    //
    let recordFileName: String = "recordedVoice.wav"
    let sequeIdentifier: String = "stopRecording"
    
    //
    // MARK: Outlets
    //
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    //
    // MARK: Internal Variables
    //
    var audioRecorder: AVAudioRecorder!
    
    //
    // MARK: ViewController Overrides
    //
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.setStackViewLayout()
            }, completion: nil
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RecordSoundViewController loaded")
        setStackViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInProgressMode(inProgress: false)
    }

    //
    // MARK: Navigation
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == sequeIdentifier) {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

    //
    // MARK: Actions
    //
    @IBAction func recordAudio(_ sender: AnyObject) {
        print("record button pressed")
        
        setInProgressMode(inProgress: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = recordFileName
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: AnyObject) {
        print("stop recording button pressed")
        
        setInProgressMode(inProgress: false)
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    //
    // MARK: internal functions
    //
    func setInProgressMode(inProgress: Bool) {
        recordingLabel.text = inProgress ? "Recording in Progress" : "Recording Done"
        recordButton.isEnabled = !inProgress
        stopRecordingButton.isEnabled = inProgress
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            print("AVAudioRecorder finished was saving your record, perform segue now")
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            
            let alert = UIAlertController(title: "Audio Recorder Error", message: "Saving your record was failing", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setInnerStackViewsAxis(axisStyle: UILayoutConstraintAxis)  {
        self.innerStackViewRow1.axis = axisStyle
        self.innerStackViewRow2.axis = axisStyle
        self.innerStackViewRow3.axis = axisStyle
    }
    
    func setStackViewLayout() {
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation.isPortrait{
            self.outerStackView.axis = .vertical
            self.setInnerStackViewsAxis(axisStyle: .horizontal)
        } else {
            self.outerStackView.axis = .horizontal
            self.setInnerStackViewsAxis(axisStyle: .vertical)
        }
    }
}

