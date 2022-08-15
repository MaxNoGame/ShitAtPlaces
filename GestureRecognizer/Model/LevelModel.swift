//
//  LevelModel.swift
//  GestureRecognizer
//
//  Created by Maksym Ponomarchuk on 18.05.2022.
//

import Foundation
import UIKit

var widthBlockV = Int(screen_width/10)  //39
var heightBlockV = Int(screen_height/10) //84
// PersonSides and shitSides 48

class BlockVertical {
    var xBlockVertical: Int
    var yBlockVertival: Int
    var widthBlockVertival: Int
    var heightBlockVertival: Int
    var blockVertivalImage = UIImageView(image: UIImage(named: "blockV"))
    init(xBlockVertical: Int, yBlockVertival: Int, widthBlockVertival: Int, heightBlockVertival: Int){
        self.xBlockVertical = xBlockVertical
        self.yBlockVertival = yBlockVertival
        self.widthBlockVertival = widthBlockVertival
        self.heightBlockVertival = heightBlockVertival
        blockVertivalImage.frame = .init(x: self.xBlockVertical, y: self.yBlockVertival, width: self.widthBlockVertival, height: self.heightBlockVertival)
    }
    
}

class PlacesForShit {
    var xPlace: Int
    var yPlace: Int
    //var placeSide: Int
    var placesImage = UIImageView(image: UIImage(named: "circle2"))
    init(xPlace: Int, yPlace: Int){
        self.xPlace = xPlace
        self.yPlace = yPlace
        //self.placeSide = placeSide
        placesImage.frame = .init(x: self.xPlace, y: self.yPlace, width: Int(screenBounds.width) / 6, height: Int(screenBounds.width) / 6)
        placesImage.alpha = 0.6
    }
}

class Portals {
    var xPortal: Int
    var yPortal: Int
    var portalImage = UIImageView(image: UIImage(named: "portal"))
    init(xPortal: Int, yPortal: Int){
        self.xPortal = xPortal
        self.yPortal = yPortal
        portalImage.frame = .init(x: self.xPortal, y: self.yPortal, width: Int(screenBounds.width) / 6, height: Int(screenBounds.width) / 6)
        
    }
}

struct Builder {
    var blocksV: [BlockVertical]
    var places: [PlacesForShit]
    var portal: [Portals?]
    var moves: Int
    var goals: Int
}


class Level {
    var levelCount = 1
    var map = [Builder(blocksV: [BlockVertical(xBlockVertical: 150, yBlockVertival: 300, widthBlockVertival: widthBlockV, heightBlockVertival: heightBlockV),BlockVertical(xBlockVertical: 150, yBlockVertival: 216, widthBlockVertival: widthBlockV, heightBlockVertival: heightBlockV), BlockVertical(xBlockVertical: 50, yBlockVertival: 600, widthBlockVertival: widthBlockV, heightBlockVertival: heightBlockV), BlockVertical(xBlockVertical: 50, yBlockVertival: 516, widthBlockVertival: widthBlockV, heightBlockVertival: heightBlockV), BlockVertical(xBlockVertical: 89, yBlockVertival: 516, widthBlockVertival: widthBlockV, heightBlockVertival: widthBlockV), BlockVertical(xBlockVertical: 128, yBlockVertival: 516, widthBlockVertival: widthBlockV, heightBlockVertival: widthBlockV), BlockVertical(xBlockVertical: 167, yBlockVertival: 516, widthBlockVertival: widthBlockV*2, heightBlockVertival: widthBlockV)], places: [PlacesForShit(xPlace: 150, yPlace: 430)], portal: [nil], moves: 30, goals: 1),
               
               Builder(blocksV: [BlockVertical(xBlockVertical: 60, yBlockVertival: 650, widthBlockVertival: widthBlockV*2, heightBlockVertival: widthBlockV), BlockVertical(xBlockVertical: 138, yBlockVertival: 650, widthBlockVertival: widthBlockV*2, heightBlockVertival: widthBlockV), BlockVertical(xBlockVertical: 70, yBlockVertival: 300, widthBlockVertival: widthBlockV, heightBlockVertival: heightBlockV)], places: [PlacesForShit(xPlace: 80, yPlace: 200), PlacesForShit(xPlace: 50, yPlace: 550)], portal: [Portals(xPortal: 250, yPortal: 550)], moves: 43, goals: 2),
               
               Builder(blocksV: [BlockVertical(xBlockVertical: 111, yBlockVertival: 650, widthBlockVertival: heightBlockV, heightBlockVertival: widthBlockV), BlockVertical(xBlockVertical: 195, yBlockVertival: 650, widthBlockVertival: heightBlockV, heightBlockVertival: widthBlockV), BlockVertical(xBlockVertical: 250, yBlockVertival: 300, widthBlockVertival: widthBlockV, heightBlockVertival: heightBlockV), BlockVertical(xBlockVertical: 101, yBlockVertival: 300, widthBlockVertival: widthBlockV, heightBlockVertival: heightBlockV)], places: [PlacesForShit(xPlace: 300, yPlace: 300), PlacesForShit(xPlace: 26, yPlace: 300), PlacesForShit(xPlace: 162, yPlace: 550)], portal: [Portals(xPortal: 160, yPortal: 420)], moves: 57, goals: 3)
               
    ]
}



