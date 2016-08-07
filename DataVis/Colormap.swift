//
//  Colormap.swift
//  DataVis
//
//  Created by Matthew Prockup on 8/3/16.
//  Copyright © 2016 Matthew Prockup. All rights reserved.
//

import Foundation
import UIKit


class Colormap{
    
    var colormap:[String:[CGFloat]] = [:]
    
    //MARK: Initializers
    //init default map
    init(){
        self.colormap["r"] = []
        self.colormap["g"] = []
        self.colormap["b"] = []
        var colors:[UIColor] = []
        colors.append(FlatUIColor.wetasphaltColor())
        colors.append(FlatUIColor.belizeholeColor())
        colors.append(FlatUIColor.belizeholeColor())
        colors.append(FlatUIColor.amethystColor())
        colors.append(FlatUIColor.pomegranateColor())
        colors.append(FlatUIColor.carrotColor())
        colors.append(FlatUIColor.sunflowerColor())
        colors.append(FlatUIColor.cloudsColor())
        self.createColormap(colors)
    }
    
    //init custom map with even steps
    init(colors:[UIColor],steps:Int=20){
        self.colormap["r"] = []
        self.colormap["g"] = []
        self.colormap["b"] = []
        self.createColormap(colors)
    }
    
    //init custom map with custom steps
    init(colors:[UIColor],steps:[Int]){
        self.colormap["r"] = []
        self.colormap["g"] = []
        self.colormap["b"] = []
        self.createColormap(colors,steps: steps)
    }
    
    
    
    //MARK: Colormap Creation
    //Create colormap with even steps
    func createColormap(colors:[UIColor], steps:Int=50){
        var colorSteps:[Int] = []
        for i in 0..<(colors.count-1){
            colorSteps.append(steps)
        }
        createColormap(colors, steps:colorSteps)
    }
    
    //Create colormap with defined steps
    func createColormap(colors:[UIColor], steps:[Int]){
        if colors.count-1 != steps.count{
            print("Error: the array steps.count must be colors.count-1, defaulting to 50 steps")
            self.createColormap(colors,steps: 50)
            return
        }
        
        for i in 0..<(colors.count-1){
            var colormapPiece:[String:[CGFloat]] = self.blendColors(colors[i], c2: colors[i+1], steps: steps[i])
            colormap["r"]?.appendContentsOf(colormapPiece["r"]!)
            colormap["g"]?.appendContentsOf(colormapPiece["g"]!)
            colormap["b"]?.appendContentsOf(colormapPiece["b"]!)
        }
    }
    
    
    //MARK: Color Computation
    func blendColors(c1:UIColor, c2:UIColor, steps:Int) -> [String:[CGFloat]]{
        let r1 = c1.components.red
        let g1 = c1.components.green
        let b1 = c1.components.blue
        
        let r2 = c2.components.red
        let g2 = c2.components.green
        let b2 = c2.components.blue
        
        var blendedColors:[String:[CGFloat]] = [:]
        blendedColors["r"] = []
        blendedColors["g"] = []
        blendedColors["b"] = []
        
        for i in 0..<steps{
            let rStep:CGFloat = r1 + (r2-r1)/CGFloat(steps) * CGFloat(i)
            let gStep:CGFloat = g1 + (g2-g1)/CGFloat(steps) * CGFloat(i)
            let bStep:CGFloat = b1 + (b2-b1)/CGFloat(steps) * CGFloat(i)
            blendedColors["r"]?.append(rStep)
            blendedColors["g"]?.append(gStep)
            blendedColors["b"]?.append(bStep)
        }
        
        return blendedColors
    }
    
    
    //Map the color, given a min and max rage of data, assuming 0-1
    func getMappedColor(value:Float, var min:Float = 0, var max:Float = 1) -> UIColor{
        
        if max<min{
            var temp = min
            min = max
            max = temp
            print("Value Error: colormap min > max, swapping values")
        }
        
        let mapSize:Int = colormap["r"]!.count
        let mapPositionAbsolute:Float = (value-min)/(max-min)*Float(mapSize)
        let mapPosition:Int = Int(round(mapPositionAbsolute))
        
        if value >= max{
            print("Value Error: colormap value > max, outside range, assigning to max color")
            return UIColor(red: colormap["r"]![mapSize-1], green: colormap["g"]![mapSize-1], blue: colormap["b"]![mapSize-1], alpha: 1)
        }else if value <= min{
            print("Value Error: colormap value < min, outside range, assigning to min color")
            return UIColor(red: colormap["r"]![0], green: colormap["g"]![0], blue: colormap["b"]![0], alpha: 1)
        }
        return UIColor(red: colormap["r"]![mapPosition], green: colormap["g"]![mapPosition], blue: colormap["b"]![mapPosition], alpha: 1)
    }
}




extension UIColor {
    var components:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r,g,b,a)
    }
}
