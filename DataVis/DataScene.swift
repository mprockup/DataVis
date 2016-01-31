//
//  PrimativeScene.swift
//  DataVis
//
//  Created by Matthew Prockup on 1/31/16.
//  Copyright © 2016 Matthew Prockup. All rights reserved.
//

import UIKit
import SceneKit

class DataScene: SCNScene {
    
    
    let camera = SCNCamera()
    let cameraNode = SCNNode()
    var plotData:DataArray!
    
    override init() {
        super.init()
        let sphereGeometry = SCNSphere(radius: 0.1)
        let sphereNode = SCNNode(geometry: sphereGeometry)
        self.rootNode.addChildNode(sphereNode)
        
        let secondSphereGeometry = SCNSphere(radius: 0.5)
        let secondSphereNode = SCNNode(geometry: secondSphereGeometry)
        secondSphereNode.position = SCNVector3(x: 40.0, y: 0.0, z: 0.0)
        self.rootNode.addChildNode(secondSphereNode)
    }
    
    init(data:DataArray){
        super.init()
        plotData = data
        for d:Example in plotData.examples{
            let sphereGeometry = SCNSphere(radius: 0.1)
            let sphereNode = SCNNode(geometry: sphereGeometry)
            sphereNode.position = SCNVector3(x:d.x, y: d.y, z: d.z)
            self.rootNode.addChildNode(sphereNode)
        }
    }
    
    func setCameraPostion(pos:SCNVector3)
    {
//        rootNode.position = pos
//        cameraNode.position = pos
    }
    
    func resetCameraPostion(){
//        rootNode.position = SCNVector3(x: 0, y: 0, z: 0)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
