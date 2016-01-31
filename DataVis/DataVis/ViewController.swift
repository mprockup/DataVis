//
//  ViewController.swift
//  DataVis
//
//  Created by Matthew Prockup on 1/31/16.
//  Copyright (c) 2016 Matthew Prockup. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var delimiter: NSCharacterSet!
    var labelType: LabelType!
    var dataArray: DataArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

