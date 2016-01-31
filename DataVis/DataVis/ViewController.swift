///Users/mprockup/Documents/HamrPhilly2/DataVis/DataVis/DataVis/ViewController.swift
//  ViewController.swift
//  DataVis
//
//  Created by Matthew Prockup on 1/31/16.
//  Copyright (c) 2016 Matthew Prockup. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {
    
    var  scnView:SCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        scnView = self.view as! SCNView
        scnView.scene = PrimativeScene()
        scnView.backgroundColor = UIColor.blackColor()
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetCamera(sender: AnyObject) {
        (scnView.scene as! PrimativeScene).resetCameraPostion()
    }
    
    
    

}

