//
//  DataArray.swift
//  DataVis
//
//  Created by Jeff Gregorio on 1/31/16.
//  Copyright © 2016 Matthew Prockup. All rights reserved.
//

import Foundation

public enum LabelType {
    case Categorical
    case Continuous
}

public class DataArray {
    
    var examples: [Example] = []
    var labelType: LabelType
    var labelName: String!
    var xName: String!
    var yName: String!
    var zName: String!
    
    public init(fromSpreadsheet fileURL: NSURL, delimiter: NSCharacterSet, labelType: LabelType) {
        
        self.labelType = labelType;
        
        self.parseSpreadsheet(fileURL,
            delimiter: delimiter,
            labelType: self.labelType)
    }
    
    subscript(index: Int) -> Example {
        get { return examples[index] }
        set(newValue) { examples[index] = newValue }
    }
    
    func parseSpreadsheet(fileURL: NSURL, delimiter: NSCharacterSet, labelType: LabelType) {
        
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
            self.parseHeader(lines[0], delimiter: delimiter)
            
            // Create examples from each subsequent line
            for (var i = 1; i < lines.count; i++) {
                addExampleFromLine(lines[i], delimiter: delimiter)
            }
        }
        catch {
            print("Nope")
        }
    }
    
    func parseHeader(line: String, delimiter: NSCharacterSet) {
        let names: [String] = line.componentsSeparatedByCharactersInSet(delimiter)
        xName = names[0]
        yName = names[1]
        zName = names[2]
        labelName = names[3]
    }
    
    func addExampleFromLine(line: String, delimiter: NSCharacterSet) {
        let stringVals: [String] = line.componentsSeparatedByCharactersInSet(delimiter)
        let ex = Example(x: Double(stringVals[0])!,
            y: Double(stringVals[1])!,
            z: Double(stringVals[2])!,
            label: Double(stringVals[3])!)
        examples.append(ex)
    }
}

public class Example {
    
    var x = 0.0
    var y = 0.0
    var z = 0.0
    var label = 0.0
    
    public init(x: Double, y: Double, z: Double, label: Double) {
        
        self.x = x;
        self.y = y;
        self.z = z;
        self.label = label;
        
        print("Example with (x, y, z, label) = (", x, ", ", y, ", ", z, ", ", label, ")");
    }
}