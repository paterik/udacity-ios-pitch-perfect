//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Patrick Paechnatz on 03.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    //
    // MARK: Outlets
    //
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var outerStackView: UIStackView!
    @IBOutlet weak var innerStackViewRow1: UIStackView!
    @IBOutlet weak var innerStackViewRow2: UIStackView!
    @IBOutlet weak var innerStackViewRow3: UIStackView!
    @IBOutlet weak var innerStackViewRow4: UIStackView!
    
    //
    // MARK: Constants
    //
    
    let debugMode: Bool = true
    
    //
    // MARK: Internal Variables
    //
    
    var recordedAudioURL: NSURL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    enum ButtonType: Int {
        case Slow = 0, Fast, Chipmunk, Vader, Echo, Reverb
    }
    
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
        
        if debugMode { print("PlaySoundViewController loaded") }
        
        setStackViewLayout()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        configureUI(playState: .NotPlaying)
    }
    
    //
    // MARK: Actions
    //
    @IBAction func playSoundForButton(sender: UIButton) {
        
        if debugMode { print("Play Sound Button Pressed \(sender.tag)") }
        
        switch(ButtonType(rawValue: sender.tag)!) {
        case .Slow:
            playSound(rate: 0.5)
        case .Fast:
            playSound(rate: 1.5)
        case .Chipmunk:
            playSound(pitch: 1000)
        case .Vader:
            playSound(pitch: -1000)
        case .Echo:
            playSound(echo: true)
        case .Reverb:
            playSound(reverb: true)
        }
        
        configureUI(playState: .Playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        
        if debugMode { print("Stop Audio Button Pressed") }
        
        stopAudio()
    }
    
    //
    // MARK: UI Functions
    //
    func setInnerStackViewsAxis(axisStyle: UILayoutConstraintAxis)  {
        self.innerStackViewRow1.axis = axisStyle
        self.innerStackViewRow2.axis = axisStyle
        self.innerStackViewRow3.axis = axisStyle
        self.innerStackViewRow4.axis = axisStyle
    }
    
    func setStackViewLayout() {
        
        let orientation = UIApplication.shared.statusBarOrientation
        
        self.outerStackView.axis = .horizontal
        self.setInnerStackViewsAxis(axisStyle: .vertical)
        
        if orientation.isPortrait {
            self.outerStackView.axis = .vertical
            self.setInnerStackViewsAxis(axisStyle: .horizontal)
        }
    }
}
