//
//  PrimativeScene.swift
//  DataVis
//
//  Created by Matthew Prockup on 1/31/16.
//  Copyright © 2016 Matthew Prockup. All rights reserved.
//

import UIKit
import SceneKit

class DataScene:SCNScene{
    
    var plotData:Dataset!
    var selectedDims:[String] = []
    var nodeToIndex:[SCNNode:Int] = [:]
    
    
    override init() {
        super.init()
    }
    
    init(data:Dataset){
        super.init()
        plotData = data
    }
    
    func setPlotData(d:Dataset, dims:[String]){
        plotData = d
        selectedDims = dims
        showData(selectedDims)
    }
    
    
    //Plot the data
    func showData(dims:[String]){
        selectedDims = dims
        var xVec:[Float] = []; var yVec:[Float] = []; var zVec:[Float] = []
        var xMin:Float = 0; var yMin:Float = 0; var zMin:Float = 0
        var xMax:Float = 0; var yMax:Float = 0; var zMax:Float = 0
        
        //get data and max/min for normalization
        if dims.count >= 1{
            xVec = (plotData.dataset)[dims[0]]!
            xMax = xVec.maxElement()!; xMin = xVec.minElement()!
        }
        if dims.count >= 2{
            yVec = (plotData.dataset)[dims[1]]!
            yMax = yVec.maxElement()!; yMin = yVec.minElement()!
        }
        if dims.count >= 3{
            zVec = (plotData.dataset)[dims[2]]!
            zMax = zVec.maxElement()!; zMin = zVec.minElement()!
        }
        
        
        for r in 0..<plotData.numRows{
            
            //Create square and normalize
            
            var geometry = SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0)
            if plotData.numRows < 300{
                geometry = SCNBox(width: 0.03, height: 0.03, length: 0.03, chamferRadius: 0)
            }
            
            let dataNode = SCNNode(geometry: geometry)
            var x:Float = 0; var y:Float = 0; var z:Float = 0
            if dims.count >= 1{
                x = (xVec[r]-xMin)/(xMax-xMin)
            }
            if dims.count >= 2{
                y = (yVec[r]-yMin)/(yMax-yMin)

            }
            if dims.count >= 3{
                z = (zVec[r]-zMin)/(zMax-zMin)

            }
            
            dataNode.position = SCNVector3(x:x, y: y, z: z)
            nodeToIndex[dataNode] = r
            self.rootNode.addChildNode(dataNode)
        }
    }
    
    //Plot data with label coloring
    func showData(dims:[String], labelDim:String, var binLabel:Bool=false){
        
        var colormap:Colormap = Colormap()
        
        var labelSet:Set = Set(plotData.dataset[labelDim]!)
        
        if labelSet.count == 2{
            binLabel = true
        }else if labelSet.count == 3{
            if labelSet.contains(0) && labelSet.contains(1) && labelSet.contains(-1){
                binLabel = true
            }
            
        }
        
        
        selectedDims = dims
                
        var xVec:[Float] = []; var yVec:[Float] = []; var zVec:[Float] = []
        var xMin:Float = 0; var yMin:Float = 0; var zMin:Float = 0
        var xMax:Float = 0; var yMax:Float = 0; var zMax:Float = 0
        
        if dims.count >= 1{
            xVec = (plotData.dataset)[dims[0]]!
            xMax = xVec.maxElement()!; xMin = xVec.minElement()!
        }
        if dims.count >= 2{
            yVec = (plotData.dataset)[dims[1]]!
            yMax = yVec.maxElement()!; yMin = yVec.minElement()!
        }
        if dims.count >= 3{
            zVec = (plotData.dataset)[dims[2]]!
            zMax = zVec.maxElement()!; zMin = zVec.minElement()!
        }
        
        
        for r in 0..<plotData.numRows{
            var geometry = SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0)
            
            if plotData.numRows < 300{
                geometry = SCNBox(width: 0.03, height: 0.03, length: 0.03, chamferRadius: 0)
            }
            var x:Float = 0; var y:Float = 0; var z:Float = 0
            if dims.count >= 1{
                x = (xVec[r]-xMin)/(xMax-xMin)
            }
            if dims.count >= 2{
                y = (yVec[r]-yMin)/(yMax-yMin)
            }
            if dims.count >= 3{
                z = (zVec[r]-zMin)/(zMax-zMin)
            }
            
            if binLabel && (((plotData.dataset)[labelDim]![r] == 1) || ((plotData.dataset)[labelDim]![r] == 0)){
                if (plotData.dataset)[labelDim]![r] == 1{
                    geometry.firstMaterial?.diffuse.contents = FlatUIColor.peterriverColor()
                 }
                else if (plotData.dataset)[labelDim]![r] == 0{
                    geometry.firstMaterial?.diffuse.contents  = FlatUIColor.sunflowerColor()
                }
                
                let dataNode = SCNNode(geometry: geometry)
                dataNode.position = SCNVector3(x:x, y: y, z: z)
                self.rootNode.addChildNode(dataNode)
                nodeToIndex[dataNode] = r
//                print("adding")
            }
            else{
                geometry.firstMaterial?.diffuse.contents  = colormap.getMappedColor((plotData.dataset)[labelDim]![r])
                let dataNode = SCNNode(geometry: geometry)
                dataNode.position = SCNVector3(x:x, y: y, z: z)
                self.rootNode.addChildNode(dataNode)
                nodeToIndex[dataNode] = r
//                print("adding")
            }
        }
    }
    
    func setCameraPostion(pos:SCNVector3)
    {
//        rootNode.position = pos
//        cameraNode.position = pos

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
