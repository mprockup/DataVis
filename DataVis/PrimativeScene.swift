//
//  PrimativeScene.swift
//  DataVis
//
//  Created by Matthew Prockup on 1/31/16.
//  Copyright © 2016 Matthew Prockup. All rights reserved.
//

import UIKit
import SceneKit

class PrimativeScene: SCNScene {
    
    
    let camera = SCNCamera()
    let cameraNode = SCNNode()
    
    override init() {
        super.init()
        let sphereGeometry = SCNSphere(radius: 1.0)
        let sphereNode = SCNNode(geometry: sphereGeometry)
        self.rootNode.addChildNode(sphereNode)
        
        let secondSphereGeometry = SCNSphere(radius: 0.5)
        let secondSphereNode = SCNNode(geometry: secondSphereGeometry)
        secondSphereNode.position = SCNVector3(x: 40.0, y: 0.0, z: 0.0)
        self.rootNode.addChildNode(secondSphereNode)
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
