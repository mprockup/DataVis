//
//  LoadView.swift
//  DataVis
//
//  Created by Matthew Prockup on 8/3/16.
//  Copyright © 2016 Matthew Prockup. All rights reserved.
//

import Foundation
import UIKit

protocol LoadViewDelegate: class {
    func fileSelected(sender: LoadView, filepath:String)
}

class LoadView:UIView,UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate:LoadViewDelegate?
    var tableView: UITableView!
    
    //array for filepaths
    var fullPaths:NSMutableArray = []
    //array for audio file names
    var fileNames:NSMutableArray=[]
    
    let documentsPath:String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString as String
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addDefaultFile()
        searchDocsDir()
        
        var label:UILabel = UILabel(frame: frame)
        label.frame.size.height = 50
        label.frame.origin.y=20
        label.text = "Load Dataset"
        label.font = UIFont(name: "Helvetica-Light", size: 32)
        label.textAlignment = .Center
        self.addSubview(label)
        
        var cancelButton:UIButton = UIButton(frame: CGRectMake(frame.width-80, 20, 70, 50))
        cancelButton.setTitle("Cancel", forState: .Normal)
        cancelButton.titleLabel!.font = UIFont(name: "Helvetica-Light", size: 18)
        cancelButton.titleLabel!.textAlignment = .Center
        
        cancelButton.setTitleColor(FlatUIColor.belizeholeColor(), forState: UIControlState.Normal)
        cancelButton.addTarget(self,
                                action: "cancelPressed",
                                forControlEvents: .TouchUpInside)
        self.addSubview(cancelButton)
        
        
        tableView = UITableView()
        tableView.frame =   frame
        tableView.frame.size.height = frame.height-70
        tableView.frame.origin.y = 70
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
        self.backgroundColor = UIColor.whiteColor()
    }
    
    
    func addDefaultFile(){
        let defaultFile1:String = NSBundle.mainBundle().pathForResource("default", ofType: "tsv")!
        let defaultFile2:String = NSBundle.mainBundle().pathForResource("test", ofType: "csv")!
        do{
            try NSFileManager.defaultManager().copyItemAtPath(defaultFile1, toPath: (documentsPath as String + "/default1.tsv"))
            try NSFileManager.defaultManager().copyItemAtPath(defaultFile2, toPath: (documentsPath as String + "/default2.csv"))
        }catch{
            print("Error copying files")
        }
    }
    //Do a search of the documents directory
    func searchDocsDir(){
        
        var directoryContent:[String] = []
        do{
            directoryContent = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(documentsPath as String)
        }catch{
            print("Error getting directory content")
        }
        var cnt = 0
        for i in 0 ..< directoryContent.count {
            
            let fp = "\(documentsPath)/\((directoryContent )[i])"
            let filename = "\((directoryContent as [String])[i])"
            let components:NSArray = filename.componentsSeparatedByString(".")
            let suffix:String = components[components.count-1] as! String
            
            //make sure its an audio file supported
            if suffix == "tsv" || suffix=="csv"{
                cnt += 1
                print("\(cnt) : \(documentsPath)/\((directoryContent as [String])[i])")
                fullPaths.addObject(fp)
                fileNames.addObject(filename)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileNames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = self.fileNames[indexPath.row] as? String
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("File Selected: \(fileNames.objectAtIndex(indexPath.row))")
        delegate?.fileSelected(self, filepath: fullPaths.objectAtIndex(indexPath.row) as! String)
        self.removeFromSuperview()
    }
    
    func cancelPressed(){
        self.removeFromSuperview()
    }
}