//
//  InfoPopoverViewController.swift
//  DataVis
//
//  Created by Matthew Prockup on 8/4/16.
//  Copyright © 2016 Matthew Prockup. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class InfoPopoverViewController: UIViewController {
    let dismissButton:UIButton! = UIButton(type:UIButtonType.Custom)
    var textView:UITextView = UITextView()
    
    var playControlsView:UIView = UIView()
    var playButton:UIButton = UIButton()
    var playSlider:UISlider = UISlider()
    
    var timer:NSTimer!
    var addPlayback = false
    
    var audioExamplePlayer: AVAudioPlayer!
    
    func donePressed(){
        dismissViewControllerAnimated(true,
                                      completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Build a programmatic view
        view.backgroundColor = FlatUIColor.cloudsColor()
        
         timer = NSTimer(timeInterval: 0.25, target: self, selector: #selector(InfoPopoverViewController.updateSliderPosition), userInfo: nil, repeats: true)
         NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        let myLabel = UILabel()
        myLabel.text = "Selected Point"
        myLabel.frame = CGRectMake(0, 0, view.frame.width, 50)
        myLabel.font = UIFont(
            name: "Helvetica",
            size: 24)
        myLabel.textColor = FlatUIColor.wetasphaltColor()
        myLabel.textAlignment = .Center
        view.addSubview(myLabel)
        
        dismissButton.setTitle("Done", forState: .Normal)
        dismissButton.titleLabel!.font = UIFont(name: "Helvetica", size: 18)
        dismissButton.titleLabel!.textAlignment = .Left
        dismissButton.frame = CGRectMake(0,view.frame.height-50,view.frame.width,50)
        dismissButton.setTitleColor(FlatUIColor.belizeholeColor(), forState: UIControlState.Normal)
        dismissButton.addTarget(self,
                                action: "donePressed",
                                forControlEvents: .TouchUpInside)
        dismissButton.backgroundColor = FlatUIColor.cloudsColor()
        view.addSubview(dismissButton)

        
        textView.frame =  CGRectMake(10, 60, view.frame.width - 20,  view.frame.height-150-10)
        textView.selectable = false
        textView.editable = false
        textView.backgroundColor = UIColor.clearColor()
        textView.font = UIFont(name: "Helvetica", size: 14)
        view.addSubview(textView)
        
        
        playControlsView.frame = CGRectMake(0,view.frame.height-100, view.frame.width,50)
        playControlsView.backgroundColor = FlatUIColor.asbestosColor()
        
        playButton.frame = CGRectMake(10,0, 50,50)
        playButton.setBackgroundImage(UIImage(named: "play"), forState: UIControlState.Normal)
        playButton.addTarget(self,action: "playPressed:",forControlEvents: .TouchUpInside)
        playControlsView.addSubview(playButton)
        
        
        playSlider.frame = CGRectMake(60,0, view.frame.width - 60 - 10 ,50)
        playSlider.tintColor = FlatUIColor.emerlandColor()
        playSlider.addTarget(self, action: "sliderTouched:", forControlEvents: UIControlEvents.AllTouchEvents)
        playSlider.minimumValue = 0
        playSlider.maximumValue = 1.0
        
        playControlsView.addSubview(playSlider)
        playControlsView.hidden = true
        view.addSubview(playControlsView)

        
        if addPlayback{
            playControlsView.hidden = false
        }
    }
    
    
    func addPlaybackControls(audioFilePath:String){
        

        addPlayback = true
        
        
        let path = audioFilePath
        
        print("trying to load: \(path)")
        let url = NSURL(fileURLWithPath: path)
        do {
            audioExamplePlayer = try AVAudioPlayer(contentsOfURL: url)
            audioExamplePlayer.prepareToPlay()
        } catch {
            // couldn't load file :(
            print("couldn't load file")
        }
    }
    
    func sliderTouched(sender:UISlider){
        if audioExamplePlayer != nil{
            audioExamplePlayer.currentTime = Double(playSlider.value)*audioExamplePlayer.duration
        }
    }
    
    func updateSliderPosition(){
        if addPlayback && audioExamplePlayer != nil{
            playSlider.value = Float(audioExamplePlayer.currentTime/audioExamplePlayer.duration)
        }
    }
    
    
    var playing:Bool = false
    func playPressed(sender:UIButton){
        if playing{
            playButton.setBackgroundImage(UIImage(named: "play"), forState: UIControlState.Normal)
            playing = false
            if audioExamplePlayer != nil{
                audioExamplePlayer.stop()
            }
        }else{
            playButton.setBackgroundImage(UIImage(named: "pause"), forState: UIControlState.Normal)
            playing = true
            if audioExamplePlayer != nil{
                audioExamplePlayer.play()
            }
        }
    }
}