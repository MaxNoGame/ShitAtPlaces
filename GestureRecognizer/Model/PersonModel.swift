//
//  PersonModel.swift
//  GestureRecognizer
//
//  Created by Maksym Ponomarchuk on 17.05.2022.
//

import Foundation
import UIKit

let screenBounds = UIScreen.main.bounds
let screen_width = screenBounds.width
let screen_height = screenBounds.height
let personSides = screenBounds.width / 8
let xStartPerson = (screen_width / 2) - (personSides / 2)
let yStartPerson = screen_height - (personSides * 2)


//MARK: Fades alpha of smile
public extension UIImageView {
    //parameter duration: custom animation duration
    func fadeIn(duration: TimeInterval = 2.5) {
        UIView.animate(withDuration: duration, animations: {self.alpha = 1.0})
    }
    //Fade out a view with a duration
    //parameter duration: custom animation duration
    func fadeOut(duration: TimeInterval = 1.5) {
        UIView.animate(withDuration: duration, animations: {self.alpha = 0.0})
    }
}

class Shit {
    var xShit: Int
    var yShit: Int
    var shitSides = Int(screenBounds.width / 8)
    var shitImage = UIImageView(image: UIImage(named: "shit"))
    
    init(xShit: Int, yShit: Int){
        self.xShit = xShit
        self.yShit = yShit
        shitImage.frame = .init(x: self.xShit, y: self.yShit, width: self.shitSides, height: self.shitSides)
    }
}


class PersonModel {
    var personImage = UIImageView(image: UIImage(named: "smile"))
    var xPerson = (screen_width / 2) - (personSides / 2)
    var yPerson = screen_height - (screen_height / 10)
    var shitArray = [Shit]()
    
    enum Directions {
        case left
        case right
        case up
        case down
        case oneTap
        case doubleTap
    }
    
    func putShit(x: Int, y: Int){
        shitArray.append(Shit.init(xShit: x, yShit: y))
    }
    
    func startPosition(){
        //print(screen_width, screen_height)
        xPerson = xStartPerson
        yPerson = yStartPerson
        personImage.frame = .init(x: xPerson, y: yPerson, width: personSides, height: personSides)
        personImage.layer.zPosition = 1
    }
}

