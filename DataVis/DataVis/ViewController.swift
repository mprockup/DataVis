///Users/mprockup/Documents/HamrPhilly2/DataVis/DataVis/DataVis/ViewController.swift
//  ViewController.swift
//  DataVis
//
//  Created by Matthew Prockup on 1/31/16.
//  Copyright (c) 2016 Matthew Prockup. All rights reserved.
//

import UIKit
import SceneKit
import MediaPlayer

class ViewController: UIViewController,UIPopoverPresentationControllerDelegate, SCNSceneRendererDelegate, UIGestureRecognizerDelegate, LoadViewDelegate {

    var dataset: Dataset!
    var sceneTapRec:UITapGestureRecognizer!
    
    var hasFirstPointOfView:Bool = false
    var origPointOfView:SCNNode!
    
    //Preview View
    @IBOutlet weak var scnView: SCNView!
    var previewScene:SCNScene!
    var updateTimer:NSTimer = NSTimer()
    var renderStoppedTimer:NSTimer = NSTimer()
    
    
    var pCamNode:SCNNode!
    
    @IBOutlet weak var previewView: SCNView!
    var squareNode:SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadDataFile()
//        setupScene()
        
        sceneTapRec = UITapGestureRecognizer(target:self, action:#selector(ViewController.sceneTapped(_:)))
        scnView.addGestureRecognizer(sceneTapRec)
    }
    

    
    func sceneTapped(gr:UITapGestureRecognizer){
        print("Scene Tapped:")
        let loc:CGPoint = gr.locationInView(scnView)
        let results:[SCNHitTestResult] = scnView.hitTest(loc, options: nil)
        
        
        if (results.count > 0) {
            let node:SCNNode = results[0].node
            let index:Int = (scnView.scene as! DataScene).nodeToIndex[node]!
            print("Tapped Index: \(index)")
            
            displayPointInfo(loc, node:node)
            
        }
    }
    
    func displayPointInfo(loc:CGPoint, node:SCNNode){
        
        let index:Int = (scnView.scene as! DataScene).nodeToIndex[node]!
        
        let header:[String] = (scnView.scene as! DataScene).plotData.header
        let keys = (scnView.scene as! DataScene).plotData.dataset.keys
        let dataset = (scnView.scene as! DataScene).plotData.dataset
        var infoStr:String = ""
        
        for h in header{
            if keys.contains(h){
                infoStr+="\n\(h)\n\t"
                infoStr+="\(dataset[h]![index])\n"
            }
        }
        
        print(infoStr)
        
        let vc = InfoPopoverViewController()
        vc.modalPresentationStyle = .Popover
        vc.popoverPresentationController?.delegate = self
        presentViewController(vc, animated: true, completion: nil)
        vc.popoverPresentationController?.sourceView = scnView
        vc.popoverPresentationController?.sourceRect = CGRectMake(loc.x, loc.y, 1, 1)
        vc.textView.text = infoStr
        
        let documentsPath:String = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString as String
        
        if (scnView.scene as! DataScene).plotData.datasetAudioPaths[index] != ""{
            vc.addPlaybackControls(documentsPath + "/" + (scnView.scene as! DataScene).plotData.datasetAudioPaths[index])
        }
        
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: EVENTS CODE
    

    
    //MARK: DRAWING CODE
    func updatePreview(){
        
        if !sceneRendered{
            return
        }
        let rX = scnView.pointOfView!.rotation.x
        let rY = scnView.pointOfView!.rotation.y
        let rZ = scnView.pointOfView!.rotation.z
        let rW = scnView.pointOfView!.rotation.w
        
//        print(scnView.pointOfView)
        if !hasFirstPointOfView{
            hasFirstPointOfView = true
            origPointOfView = scnView.pointOfView
        }
        
        
        let rotationVec:SCNVector4 = SCNVector4Make(-1*rX, -1*rY, -1*rZ, rW)
        squareNode.rotation = rotationVec
    }
    
    
    //MARK: SETUP THE SCENE
    
    
    func setupScene(){
        
        updateTimer.invalidate()
        
        scnView.delegate = self
        scnView.scene = DataScene(data: dataset)
        getDimsFromUser()

    }
    
    func finishSetupScene(){
        (scnView.scene as! DataScene).showData(userDims,labelDim: userLabelDim)
        scnView.backgroundColor = UIColor.blackColor()
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        
        previewScene = SCNScene()
        let squareGeometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        
        //Give the cube a face
        let cubeF = SCNMaterial()
        cubeF.diffuse.contents = UIImage(named: "cubeF")
        cubeF.locksAmbientWithDiffuse = true;
        
        let cubeL = SCNMaterial()
        cubeL.diffuse.contents = UIImage(named: "cubeL")
        cubeL.locksAmbientWithDiffuse = true;
        
        let cubeB = SCNMaterial()
        cubeB.diffuse.contents = UIImage(named: "cubeB")
        cubeB.locksAmbientWithDiffuse = true;
        
        let cubeR = SCNMaterial()
        cubeR.diffuse.contents = UIImage(named: "cubeR")
        cubeR.locksAmbientWithDiffuse = true;
        
        let cubeU = SCNMaterial()
        cubeU.diffuse.contents = UIImage(named: "cubeU")
        cubeU.locksAmbientWithDiffuse = true;
        
        let cubeA = SCNMaterial()
        cubeA.diffuse.contents = UIImage(named: "cubeA")
        cubeA.locksAmbientWithDiffuse = true;
        
        squareGeometry.materials = [cubeF, cubeL, cubeB, cubeR, cubeA, cubeU]
        
        squareNode = SCNNode(geometry: squareGeometry)
        squareNode.position = SCNVector3(x:0, y: 0, z:0)
        previewScene.rootNode.addChildNode(squareNode)
        
        //add preview to scene
        previewView.scene = previewScene
        previewView.backgroundColor = UIColor.clearColor()
        previewView.autoenablesDefaultLighting = true
        previewView.allowsCameraControl = false
        let pCamNode = SCNNode()
        pCamNode.camera = SCNCamera()
        pCamNode.position = SCNVector3Make(0, 0, 2)
        previewScene.rootNode.addChildNode(pCamNode)
        
        //create a timer to update the preview
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: #selector(ViewController.updatePreview), userInfo: nil, repeats: true)
    }
    
    
    
    var getDimsView:UIView!
    var userDims:[String]!
    var dimSwitches:[UISwitch] = []
    var dimLabels:[UILabel] = []
    func getDimsFromUser(){
        getDimsView = UIView(frame: view.frame)
       
        //Crate Blurred Background
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            getDimsView.backgroundColor = UIColor.clearColor()
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            getDimsView.addSubview(blurEffectView)
        } else {
            getDimsView.backgroundColor = UIColor.blackColor()
        }
        
        self.view.addSubview(getDimsView)
        
        //Add a view for selection
        var selectorView = UIView()
        selectorView.frame = CGRectMake((self.view.frame.width-300)/2, (self.view.frame.height-400)/2, 300, 400)
        selectorView.backgroundColor = FlatUIColor.cloudsColor(0.8)
        selectorView.layer.cornerRadius = 10
        getDimsView.addSubview(selectorView)
        
        //Add a scrollview for dim selection
        var scrollingSelector:UIScrollView = UIScrollView()
        scrollingSelector.frame = selectorView.frame
        scrollingSelector.frame.origin = CGPoint(x: 0,y: 50)
        scrollingSelector.frame.size.height = selectorView.frame.height - 100
        selectorView.addSubview(scrollingSelector)
        
        
        //add switches for selecting dims to show
        let rowHeight:CGFloat = 50
        let switchWidth:CGFloat = 75
        let viewWidth:CGFloat = scrollingSelector.frame.width
        for i in 0..<(scnView.scene as! DataScene).plotData.header.count{
            var s:UISwitch = UISwitch(frame:CGRectMake(20,CGFloat(i)*rowHeight + 10,75,rowHeight))
            var l:UILabel = UILabel(frame:CGRectMake(switchWidth + 30 ,CGFloat(i)*rowHeight,viewWidth-switchWidth-40,rowHeight))
            l.text = (scnView.scene as! DataScene).plotData.header[i]
            l.textAlignment = .Left
            scrollingSelector.addSubview(s)
            scrollingSelector.addSubview(l)
            dimSwitches.append(s)
            dimLabels.append(l)
        }
        
        var contentRect:CGRect = CGRectMake(0,0,0,0)
        for view in scrollingSelector.subviews {
            contentRect = CGRectUnion(contentRect, view.frame);
        }
        scrollingSelector.contentSize = contentRect.size
        
        //Add a title
        var titleLabel = UILabel()
        titleLabel.text = "Select Dimensions"
        titleLabel.frame = CGRectMake(0, 0, selectorView.frame.width, 50)
        titleLabel.font = UIFont(name: "Helvetica",size: 24)
        titleLabel.textColor = FlatUIColor.wetasphaltColor()
        titleLabel.textAlignment = .Center
        selectorView.addSubview(titleLabel)
        
        //Add a select UIButton
        var selectButton = UIButton()
        selectButton.setTitle("Select", forState: .Normal)
        selectButton.titleLabel!.font = UIFont(name: "Helvetica", size: 18)
        selectButton.titleLabel!.textAlignment = .Left
        selectButton.frame = CGRectMake(0,selectorView.frame.height-50,selectorView.frame.width,50)
        selectButton.setTitleColor(FlatUIColor.belizeholeColor(), forState: UIControlState.Normal)
        selectButton.addTarget(self, action: "selectDimsPressed", forControlEvents: .TouchUpInside)
        selectButton.backgroundColor = UIColor.clearColor()
        selectorView.addSubview(selectButton)
        
        
        
        
    }
    
    
    func selectDimsPressed(){
        getDimsView.removeFromSuperview()
        userDims = ["Feature 1", "Feature 2", "Feature 3"]
        getLabelsFromUser()
    }
    
    var getLabelView:UIView!
    var userLabelDim:String!
    var labelSwitches:[UISwitch] = []
    var labelLabels:[UILabel] = []
    
    func getLabelsFromUser(){
        getLabelView = UIView(frame: view.frame)
        
        //Crate Blurred Background
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            getLabelView.backgroundColor = UIColor.clearColor()
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            getLabelView.addSubview(blurEffectView)
        } else {
            getLabelView.backgroundColor = UIColor.blackColor()
        }
        
        self.view.addSubview(getLabelView)
        
        //Add a view for selection
        var selectorView = UIView()
        selectorView.frame = CGRectMake((self.view.frame.width-300)/2, (self.view.frame.height-400)/2, 300, 400)
        selectorView.backgroundColor = FlatUIColor.cloudsColor(0.8)
        selectorView.layer.cornerRadius = 10
        getLabelView.addSubview(selectorView)
        
        //Add a scrollview for dim selection
        var scrollingSelector:UIScrollView = UIScrollView()
        scrollingSelector.frame = selectorView.frame
        scrollingSelector.frame.origin = CGPoint(x: 0,y: 50)
        scrollingSelector.frame.size.height = selectorView.frame.height - 100
        selectorView.addSubview(scrollingSelector)
        
        //add switches for selecting dims to show
        let rowHeight:CGFloat = 50
        let switchWidth:CGFloat = 75
        let viewWidth:CGFloat = scrollingSelector.frame.width
        for i in 0..<(scnView.scene as! DataScene).plotData.header.count{
            var s:UISwitch = UISwitch(frame:CGRectMake(20,CGFloat(i)*rowHeight + 10,75,rowHeight))
            var l:UILabel = UILabel(frame:CGRectMake(switchWidth + 30 ,CGFloat(i)*rowHeight,viewWidth-switchWidth-40,rowHeight))
            l.text = (scnView.scene as! DataScene).plotData.header[i]
            l.textAlignment = .Left
            scrollingSelector.addSubview(s)
            scrollingSelector.addSubview(l)
            labelSwitches.append(s)
            labelLabels.append(l)
        }
        
        var contentRect:CGRect = CGRectMake(0,0,0,0)
        for view in scrollingSelector.subviews {
            contentRect = CGRectUnion(contentRect, view.frame);
        }
        scrollingSelector.contentSize = contentRect.size
        
        
        var titleLabel = UILabel()
        titleLabel.text = "Select a Label (optional)"
        titleLabel.frame = CGRectMake(0, 0, selectorView.frame.width, 50)
        titleLabel.font = UIFont(
            name: "Helvetica",
            size: 24)
        titleLabel.textColor = FlatUIColor.wetasphaltColor()
        titleLabel.textAlignment = .Center
        selectorView.addSubview(titleLabel)
        
        var selectButton = UIButton()
        selectButton.setTitle("Select", forState: .Normal)
        selectButton.titleLabel!.font = UIFont(name: "Helvetica", size: 18)
        selectButton.titleLabel!.textAlignment = .Left
        selectButton.frame = CGRectMake(0,selectorView.frame.height-50,selectorView.frame.width,50)
        selectButton.setTitleColor(FlatUIColor.belizeholeColor(), forState: UIControlState.Normal)
        selectButton.addTarget(self, action: "selectLabelPressed", forControlEvents: .TouchUpInside)
        selectButton.backgroundColor = UIColor.clearColor()
        selectorView.addSubview(selectButton)
    }
    
    func selectLabelPressed(){
        getLabelView.removeFromSuperview()
        userLabelDim = "Label"
        finishSetupScene()
    }
    
    
    @IBAction func resetPressed(sender: AnyObject) {
        resetCamera()
    }
    
    @IBAction func loadPressed(sender: AnyObject) {
        showLoadView()
    }
    
    func resetCamera(){
        sceneRendered = false
        scnView.pointOfView  = origPointOfView
        scnView.setNeedsDisplay()
    }
    
    func showLoadView(){
        print("Show Load View")
        let loadFileView:LoadView = LoadView(frame: self.view.frame)
        loadFileView.delegate = self
        self.view.addSubview(loadFileView)
    }
    
    func fileSelected(sender: LoadView, filepath: String) {
        print("ViewController knows about the file: \(filepath)")
        sceneRendered = false
        hasFirstPointOfView = false
        
        let components:NSArray = filepath.componentsSeparatedByString(".")
        let suffix:String = components[components.count-1] as! String
        var d = ""
        if suffix.lowercaseString == "tsv"{
            d = "\t"
        }else if suffix.lowercaseString == "csv"{
            d = ","
        }
        loadDataFile(filepath, delimiter:d)
        setupScene()
    }
    
    
    func loadDataFile(filename:String, delimiter:String = "\t"){
        if NSFileManager.defaultManager().fileExistsAtPath(filename) {
            let delimiterCharSet = NSCharacterSet(charactersInString: delimiter)
            dataset = Dataset(fromSpreadsheet: NSURL(fileURLWithPath: filename),
                              delimiter: delimiterCharSet)
        }
    }
    
    //MARK: LOAD DATA FILE
    func loadDataFile(){
//        if let csvURL = NSBundle.mainBundle().URLForResource("default", withExtension: "tsv") {
//            loadDataFile(csvURL.path!)
//        }
        showLoadView()
    }
    
    func getMedia() {
        
  
    }
    
    var sceneRendered:Bool = false
    var renderCount:Int = 0
    func renderer(renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: NSTimeInterval){
        renderCount += 1
        print("RENDERED \(renderCount)")
        sceneRendered = true
    }
    
    //Update on rotate (avoid weird stretching)
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        scnView.setNeedsDisplay()
    }
}
















