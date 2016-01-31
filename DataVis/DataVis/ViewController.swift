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
    
    var delimiter: NSCharacterSet!
    var labelType: LabelType!
    var dataArray: DataArray!
    
    
    var  scnView:SCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadDataFile()
        setupScene()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetCamera(sender: AnyObject) {
        setupScene()
    }
    
    
    //SETUP THE SCENE
    func setupScene(){
        scnView = self.view as! SCNView
        scnView.scene = DataScene(data: dataArray)
        scnView.backgroundColor = UIColor.blackColor()
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
    }
    
    // LOAD DATA FILE
    func loadDataFile(){
        delimiter = NSCharacterSet(charactersInString: "\t")
        labelType = LabelType.Categorical
        
        if let csvURL = NSBundle.mainBundle().URLForResource("NMF_3_MELLIN_proj_42", withExtension: "tsv") {
            if NSFileManager.defaultManager().fileExistsAtPath(csvURL.path!) {
                
                dataArray = DataArray(fromSpreadsheet: csvURL,
                    delimiter: delimiter,
                    labelType: labelType)
            }
        }
        
    }

}

