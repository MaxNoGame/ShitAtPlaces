//
//  ViewController.swift
//  GestureRecognizer
//
//  Created by Maksym Ponomarchuk on 17.05.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var muteMusic: UIButton!
    @IBOutlet weak var timeSeconds: UILabel!
    @IBOutlet weak var movesCount: UILabel!
    @IBOutlet weak var goalsCount: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    
    var person = PersonModel()
    var level = Level()
    var goalsLeft = 0
    var movesLeft = 0
    var player = AVAudioPlayer()
    var playerSfx = AVAudioPlayer()
    var playerJingle = AVAudioPlayer()
    var musicPlay = true
    var timer = Timer()
    var countSeconds = 0
    var direction: PersonModel.Directions = .up
    var countdownTimer = Timer()
    var seconds = 30
    

    override func viewDidLoad() {
        super.viewDidLoad()
        playJingle(jingle: "jingle")
        playMusic(sound: "music1")
        clearBtn.layer.zPosition = 1
        centerLabel.layer.zPosition = 2
        centerLabel.text = "Level 1"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.centerLabel.text = ""
        }
        view.backgroundColor = .lightGray
        installMap()
        person.startPosition()
        swipeObserver()
        tapObserver()
        updScreenInfo()
        view.addSubview(person.personImage)
        rules()
    }
    
    func rules(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: "1. For start, swipe and hold in some direction. \n2. Double tap for make some shit. \n3. You should put the shit in right places! Run faster, time is running out...", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Got it!", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
        
    }
    
    @IBAction func clear(_ sender: UIButton) {
        newGame()
    }
    
    @IBAction func muteMusAction(_ sender: UIButton) {
        if musicPlay {
            muteMusicFunc()
            musicPlay = false
        } else {
            playMusic(sound: "music1")
            musicPlay = true
        }
    }
    
    
    func newGame(){
        if musicPlay{
            playMusic(sound: "music1")
        } else {
            muteMusicFunc()
        }
        
        person.startPosition()
        clearAllShit()
        person.shitArray.removeAll()
        installMap()
        updScreenInfo()
    }
    
    //MARK: UISwipeGestureRecognizer
    /*
     func swipeObserver() {
     
     //MARK: свайп вправо:
     swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
     //определим какой свайп:
     swipeRight.direction = .right
     //добавим свайп:
     self.view.addGestureRecognizer(swipeRight)
     
     //MARK: свайп влево:
     swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
     swipeLeft.direction = .left
     self.view.addGestureRecognizer(swipeLeft)
     
     //MARK: свайп вверх:
     swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
     swipeUp.direction = .up
     self.view.addGestureRecognizer(swipeUp)
     
     //MARK: свайп вниз:
     swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes))
     swipeDown.direction = .down
     self.view.addGestureRecognizer(swipeDown)
     }
     */
    
    
    
    //MARK: UIPanGestureRecognizer
    func swipeObserver() {
        
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes))
        self.view.addGestureRecognizer(swipe)
    }
    
    
    func tapObserver() {
        //MARK: экземпляры класса Tap:
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction))
        doubleTap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(doubleTap)
        
        //одинарный:
        let oneTap = UITapGestureRecognizer(target: self, action: #selector(oneTapAction))
        oneTap.require(toFail: doubleTap) //игнорировать один тап если тапаем дважды
        oneTap.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(oneTap)
    }
    
    @objc func handleSwipes(gester: UIPanGestureRecognizer) {
        let point = gester.translation(in: self.view)
        var currentPoint = CGPoint(x: 0, y: 0)
        
        switch gester.state {
        case .began: countSeconds = 0; timerStart()
            //case .changed: timerStart()
        case .ended: timerStop()
        default: break
        }
        
        //up
        if abs(point.y - currentPoint.y) > abs(point.x - currentPoint.x) && point.y < 0 {
            direction = .up
            currentPoint = point
        }
        //down
        else if abs(point.y - currentPoint.y) > abs(point.x - currentPoint.x) && point.y > 0 {
            direction = .down
            currentPoint = point
        }
        //left
        else if abs(point.x - currentPoint.x) > abs(point.y - currentPoint.y) && point.x < 0 {
            direction = .left
            currentPoint = point
        }
        //right
        else if abs(point.x - currentPoint.x) > abs(point.y - currentPoint.y) && point.x > 0 {
            direction = .right
            currentPoint = point
        }
    }
    
    
    func timerStart(){
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.28, target: self, selector: #selector(timerCount), userInfo: nil, repeats: true)
    }
    
    @objc func timerCount(){
        countSeconds += 1
        movePerson(direction: direction)
    }
    
    func timerStop(){
        timer.invalidate()
        countSeconds = 0
    }
    
    func movePerson(direction: PersonModel.Directions){
        centerLabel.text = ""
        let portalImage = level.map[level.levelCount - 1].portal
        
        switch direction {
        case .left: if person.xPerson > 0 && moveCheck() {person.xPerson -= (personSides / 2)
            playSound(sound: "smile")
        } else {
            person.xPerson += (personSides / 2)
            playSound(sound: "wrong")
        }
        case .right: if person.xPerson < (screen_width - personSides) && moveCheck() {person.xPerson += (personSides / 2)
            playSound(sound: "smile")
        }
            else {
                person.xPerson -= (personSides / 2)
                playSound(sound: "wrong")
            }
        case .up: if person.yPerson > personSides * 2 && moveCheck() {person.yPerson -= (personSides / 2)
            playSound(sound: "smile")
        }
            else {
                person.yPerson += (personSides / 2)
                playSound(sound: "wrong")
            }
        case .down: if person.yPerson < (screen_height - personSides * 2) && moveCheck() {person.yPerson += (personSides / 2)
            playSound(sound: "smile")
        }
            else {
                person.yPerson -= (personSides / 2)
                playSound(sound: "wrong")
            }
        case .oneTap: break
        case .doubleTap: person.putShit(x: Int(person.xPerson), y: Int(person.yPerson)); goalsCountCheck()
            playSound(sound: "shit1")
        }
        
        if !moveCountCheck(){
            
            playSound(sound: "wrong")
            newGame()
        }
        updScreenInfo()
        
        // MARK: Check for Portals intersects
        
        for i in portalImage {
            if i != nil {
                if person.personImage.frame.intersects(i!.portalImage.frame){
                    playJingle(jingle: "flushing")
                    randomPlacePerson()
                    person.personImage.fadeOut()
                }
            }
        }
        person.personImage.frame = .init(x: person.xPerson, y: person.yPerson, width: personSides, height: personSides)
        person.personImage.fadeIn()
    }
    
    
    func randomPlacePerson(){
        let randomX = CGFloat.random(in: 0...(screen_width - personSides))
        let randomY = CGFloat.random(in: 0...(screen_height - personSides))
        //let outCG = CGRect(x: randomX, y: randomY, width: personSides, height: personSides)
        person.xPerson = randomX
        person.yPerson = randomY
    }
    
    
    
    func moveCheck() -> Bool {
        let personPoint = CGRect(x: person.xPerson, y: person.yPerson, width: personSides, height: personSides)
        let currentBlocksV = level.map[level.levelCount - 1]
        for i in currentBlocksV.blocksV {
            if personPoint.intersects(CGRect(x: i.xBlockVertical, y: i.yBlockVertival, width: i.widthBlockVertival, height: i.heightBlockVertival)) {
                return false
            }
        }
        return true
    }
    
    func goalsCountCheck() {
        let personPoint = CGRect(x: person.xPerson, y: person.yPerson, width: personSides, height: personSides)
        let currentPlace = level.map[level.levelCount - 1]
        for i in currentPlace.places {
            if personPoint.intersects(CGRect(x: i.xPlace, y: i.yPlace, width: Int(personSides), height: Int(personSides))){
                goalsLeft -= 1
                if goalsLeft == 0 {
                    playJingle(jingle: "jingle")
                    if level.levelCount == level.map.count {
                        muteMusicFunc()
                        playJingle(jingle: "win")
                        playMusic(sound: "1")
                        timerStop()
                        performSegue(withIdentifier: "win", sender: nil)
                    } else {
                        clearAllShit()
                        showInfoCenterScreen()
                        level.levelCount += 1
                        timerStop()
                        newGame()
                    }
                }
            }
        }
    }
    
    
    @objc func doubleTapAction() {
        movePerson(direction: .doubleTap)
        updShitScreen()
    }
    
    @objc func oneTapAction() {
        timerStop()
        updShitScreen()
    }
    
    func updShitScreen(){
        
        if !person.shitArray.isEmpty {
            for i in person.shitArray {
                view.addSubview(i.shitImage)
            }
        }
    }
    
    func installMap(){
        
        countdown()
        let currentBlocksV = level.map[level.levelCount - 1]
        for i in currentBlocksV.blocksV {
            view.addSubview(i.blockVertivalImage)
        }
        for j in currentBlocksV.places {
            view.addSubview(j.placesImage)
        }
        for y in currentBlocksV.portal {
            if y != nil {
                view.addSubview(y!.portalImage)
            }
            
        }
        movesLeft = level.map[level.levelCount - 1].moves
        goalsLeft = level.map[level.levelCount - 1].goals
        
    }
    
    func clearAllShit(){
        if !person.shitArray.isEmpty {
            for i in person.shitArray {
                i.shitImage.removeFromSuperview()
            }
            for j in level.map[level.levelCount - 1].blocksV {
                j.blockVertivalImage.removeFromSuperview()
            }
            for j in level.map[level.levelCount - 1].places {
                j.placesImage.removeFromSuperview()
            }
            for y in level.map[level.levelCount - 1].portal {
                y?.portalImage.removeFromSuperview()
            }
        }
    }
    
    func updScreenInfo(){
        movesCount.text = String(movesLeft)
        goalsCount.text = String(goalsLeft)
    }
    
    func moveCountCheck() -> Bool {
        guard movesLeft > 1 else {return false}
        movesLeft -= 1
        return true
    }
    
    func showInfoCenterScreen(){
        centerLabel.text = "Level \(level.levelCount + 1)"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.centerLabel.text = ""
        }
    }
    
    func playMusic (sound: String){
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {return}
        do {
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("error")
        }
        player.volume = 0.6
        player.numberOfLoops = 2
        player.play()
    }
    
    func muteMusicFunc() {
        player.stop()
    }
    
    
    func playJingle(jingle: String){
        guard let url = Bundle.main.url(forResource: jingle, withExtension: "mp3") else {return}
        do {
            playerJingle = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("error")
        }
        playerJingle.numberOfLoops = 0
        playerJingle.play()
    }
    
    func playSound (sound: String){
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {return}
        do {
            playerSfx = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("error")
        }
    
        playerSfx.numberOfLoops = 0
        playerSfx.play()
    }
    
    func randomLaught() -> String {
        let outString = String(Int.random(in: 1...12))
        return outString
    }
    
    func countdown() {
        seconds = 30
        countdownTimer.invalidate()
        timeSeconds.text = String(seconds)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(upd), userInfo: nil, repeats: true)
    }
    
    @objc func upd() {
        seconds -= 1
        self.timeSeconds.text = String(seconds)
        if seconds == -1 {
            countdownTimer.invalidate()
            alertText(text: "Time is over...")
        }
    }
    
    func alertText(text: String) {
        playJingle(jingle: "wrong")
        let alert = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Once again", style: .default) { action in
            self.newGame()
        }
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}

