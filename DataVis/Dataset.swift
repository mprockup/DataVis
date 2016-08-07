//
//  Dataset.swift
//  DataVis
//
//  Created by Matthew Prockup on 8/1/16.
//  Copyright © 2016 Matthew Prockup. All rights reserved.
//

import Foundation
import UIKit
public class Dataset{
    
    var dataset: [String:[Float]]! = [:]
    var datasetImagePaths:[String] = []
    var datasetAudioPaths:[String] = []
    var numCols:Int = 0
    var header:[String] = []
    var numErrors:Int = 0
    var errorLines:[Int] = []
    var numRows = 0
    
    public init(fromSpreadsheet fileURL: NSURL, delimiter: NSCharacterSet) {
        self.parseSpreadsheet(fileURL, delimiter: delimiter)
    }

    
    //MARK: Parse Data
    func parseSpreadsheet(fileURL: NSURL, delimiter: NSCharacterSet, hasHeader:Bool = true) {
        
        do {
            // Parse file into a single string
            let fileString = try String(contentsOfURL: fileURL)
            
            // Get array of lines
            var lines: [String] = []
            fileString.stringByTrimmingCharactersInSet(
                NSCharacterSet.newlineCharacterSet()).enumerateLines {
                    (line, stop) in lines.append(line)
            }
            
            // Get feature and label names from first line
            if hasHeader{
                self.parseHeader(lines[0], delimiter: delimiter)
            }else{
                var dims:Int = lines[0].componentsSeparatedByCharactersInSet(delimiter).count
                numCols = dims
                for i in 0..<dims{
                    let dataLabel:String = "Dim \(i)"
                    header.append(dataLabel)
                }
            }
            
            for h in header{
                dataset[h] = []
            }
            
            // Create examples from each subsequent line, keep track of errors
            for (var i = 1; i < lines.count; i++) {
                if !addExampleFromLine(lines[i], delimiter: delimiter){
                    numErrors++
                    errorLines.append(i)
                }
            }
            
            //Trim the dictionary of garbage headers, for audio files and images etc.
            for h in header{
                if dataset[h]!.count <= 0{
                    dataset.removeValueForKey(h)
                }
            }
        }
        catch {
            print("Nope: File reading issue.")
        }
    }
    
    
    func parseHeader(line: String, delimiter: NSCharacterSet) {
        header = line.componentsSeparatedByCharactersInSet(delimiter)
        numCols = header.count
    }
    
    
    //Add an example to the lists.
    // - Return true if added successfully, false if not.
    func addExampleFromLine(line: String, delimiter: NSCharacterSet) -> Bool {
        
        //parse the line
        var stringVals: [String] = line.componentsSeparatedByCharactersInSet(delimiter)
        
        //see if it is the right size
        if stringVals.count != numCols{
            print("Loading Error: wrong number of items based on supplied or inferred table heading.")
            return false
        }
        
        for i in 0..<stringVals.count{
            
            //make true/false/na values
            if (stringVals[i].lowercaseString == "true" || stringVals[i].lowercaseString == "t" ){
                stringVals[i] = "1"
            }else if (stringVals[i].lowercaseString == "false" || stringVals[i].lowercaseString == "f" ){
                stringVals[i] = "0"
            }else if (stringVals[i].lowercaseString == "na" || stringVals[i].lowercaseString == "n/a" || stringVals[i].lowercaseString == ""){
                stringVals[i] = "-1"
            }else if (stringVals[i].lowercaseString == "null" || stringVals[i].lowercaseString == "nil" || stringVals[i].lowercaseString == "none"){
                stringVals[i] = "-1"
            }
        }
        
            // Parse the data and place it in the dictionary
        var foundAudio = false; var foundImage = false
        for s in 0..<stringVals.count{
            let d = Float(stringVals[s])
            if d != nil{
                dataset[header[s]]!.append(d!)
            }
            else if stringVals[s].containsString(".wav") || stringVals[s].containsString(".mp3") || stringVals[s].containsString(".m4a") || stringVals[s].containsString(".aiff"){
                datasetAudioPaths.append(stringVals[s])
                foundAudio = true
            }else if stringVals[s].containsString(".bmp") || stringVals[s].containsString(".jpg") || stringVals[s].containsString(".png") || stringVals[s].containsString(".tiff") || stringVals[s].containsString(".jpeg"){
                foundImage = true
                datasetImagePaths.append(stringVals[s])
            }
            else{
                dataset[header[s]]!.append(Float(-1))
            }
        }
        
        //Deal with missing media paths
        if !foundAudio{
            datasetAudioPaths.append("")
        }
        if !foundImage{
            datasetImagePaths.append("")
        }
        numRows++
        return true
    }
    
    
}