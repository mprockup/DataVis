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
        (scnView.scene as! DataScene).resetCameraPostion()
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
        delimiter = NSCharacterSet(charactersInString: ",")
        labelType = LabelType.Continuous
        
        if let csvURL = NSBundle.mainBundle().URLForResource("test", withExtension: "csv") {
            if NSFileManager.defaultManager().fileExistsAtPath(csvURL.path!) {
                
                dataArray = DataArray(fromSpreadsheet: csvURL,
                    delimiter: delimiter,
                    labelType: labelType)
            }
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        let touch:UITouch = (touches?.first)!
        let loc:CGPoint = touch.locationInView(self.view)
        let results:[SCNHitTestResult] = scnView.hitTest(loc, options: nil)
        
        if (results.count > 0) {
            let node:SCNNode = results[0].node
            print(node)
            let ex:Example = dataArray.nodeToExampleDict[node]!
            print("Example with (x, y, z, label) = (", ex.x, ", ", ex.y, ", ", ex.z, ", ", ex.label, ")");
        }
    }
}
















