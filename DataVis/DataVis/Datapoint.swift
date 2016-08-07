//
//  Datapoint.swift
//  DataVis
//
//  Created by Matthew Prockup on 8/1/16.
//  Copyright © 2016 Matthew Prockup. All rights reserved.
//

import Foundation
import UIKit

public enum DataType {
    case categorical
    case continuous
    case binary
    case ignore
}

public class Datapoint{
    var data:[Float] = []
    var dataTypes:[DataType] = []
    var mediaAudioURL = ""
    var mediaImageURL = ""
    
    //MARK: _______________________
    //MARK:INIT
    public init(data:[Float] = [], audioURL:String = "", imageURL:String=""){
        self.data = data
        mediaAudioURL = audioURL
        mediaImageURL = imageURL
    }
    
    //MARK: _______________________
    //MARK: Add Data to Dataset
    func addData(data:[Float]){
        self.data = data
    }
    
    func addAudioExample(url:String){
        mediaAudioURL = url
    }
    
    func addImageExample(url:String){
        mediaImageURL = url
    }
    
    //MARK: _______________________
    //MARK: Retrieve Information
    
    func getImage() -> UIImage {
        return UIImage()
    }
    
    func getAudioExample() -> String{
        return mediaAudioURL
    }
    
}