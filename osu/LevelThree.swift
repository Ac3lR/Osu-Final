//
//  GameScene.swift
//  osu
//
//  Created by Jiajun Ma on 11/9/18.
//  Copyright © 2018 Jiajun Ma. All rights reserved.
//

import AVFoundation
import SpriteKit

extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
        
    }
    
}

extension Range {
    
    var randomInt: Int {
        
        get {
            
            var offset = 0
            
            // allow negative ranges
            if (self.lowerBound as! Int) < 0 {
                offset = abs(lowerBound as! Int)
            }
            
            let mini = UInt32(lowerBound as! Int + offset)
            let maxi = UInt32(upperBound   as! Int + offset)
            
            return Int(mini + arc4random_uniform(maxi - mini)) - offset
        }
    }
}

class LevelThree: SKScene {
    
    // Controls number of circles on screen at the same time
    let maxCircles = 5
    
    var zPositionMain = -1
    
    // Counter of circle numbers, cycles 1-maxCircles
    var circleCountLableValue: Int = 1
    
    // Pulse timer for animations and actions
    var timer: Timer?
    
     // Time since start in 100ths of seconds
    var totalTime: Int = 0
    
    // Pulse timer for animations and actions
    var circleTimer: Timer?
    var circleSpawnTime: Int = 0
    
    // Array of times when circles were spawned
    var spawnArray = Array(repeating: 0, count: 5)
    
    // Player's score
    var score = 0;
    var totalScore: Int = 0;
    
    let ScoreLabel = SKLabelNode(text: "Score: 0")
    let screenWidth = Int(UIScreen.main.bounds.width)
    let screenHeight = Int(UIScreen.main.bounds.height)
    
    var Player: AVAudioPlayer?
    
    var MusicPath = Bundle.main.url(forResource: "level-music-3", withExtension: ".mp3")
    
    var levelBackground: SKSpriteNode?
    var levelTexture: SKTexture?
    
    //Manage the overall animations and actions
    override func didMove(to view: SKView) {
        
        levelTexture = SKTexture(imageNamed: "level-background-3")
        levelBackground = SKSpriteNode(texture: levelTexture)
        levelBackground!.position = CGPoint(x: 0, y: 0)
        levelBackground!.size = CGSize(width: 750, height: 430)
        levelBackground!.zPosition = -10000000000000000
        addChild(levelBackground!)
        
        do {
            
            Player = try AVAudioPlayer(contentsOf: MusicPath!)
            Player!.volume = 20
            Player!.play()
            
        }
            
        catch {
            
            let theError = error as NSError
            print("Could not play song \(theError)")
            
        }
        
        // Create the control timer, repeating every 100th of a second
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (theTimer) in
            self.totalTime += 1
        })

        circleTimer = Timer.scheduledTimer(withTimeInterval: 0.2703, repeats: true, block: { (theTimer) in
            
            let heightScreen = Range((-(self.screenHeight/2) ... self.screenHeight/2)).randomInt
            let widthScreen = Range((-(self.screenWidth/2) ... self.screenWidth/2)).randomInt
            
            self.spawnCircle(xPoint: widthScreen, yPoint: heightScreen)
            
            // Add spawn time to array of spawn times.
            self.spawnArray[self.circleCountLableValue-1] = self.totalTime
            
            // Increment the counter.
            self.circleCountLableValue += 1
            
            if self.circleCountLableValue > self.maxCircles {
                self.circleCountLableValue = 1
            }
            
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        
        // Constant assigned to clicked node
        let touchedNode = atPoint(touchLocation)
        
        // Runs code if the inside circle was clicked
        if touchedNode is SKShapeNode && touchedNode.name != "notTarget" || touchedNode is SKLabelNode {
            
            // Creates an integer equal to the Time taken to click the circle after it spawns
            let circleRefNumber: Int = Int(touchedNode.name!)!
            let timeToTouch = totalTime - spawnArray[circleRefNumber-1]
            
            score = 150 - timeToTouch;
            
            totalScore = totalScore + score
            
            self.ScoreLabel.text = "Score: \(totalScore)"
            
            print(score)
            touchedNode.removeAllActions()
            touchedNode.removeFromParent()
        }
    }
    
    func spawnCircle(xPoint: Int, yPoint: Int) {
        
        // Create the shape.
        let circleMaster = SKShapeNode(circleOfRadius: 55)
        circleMaster.position = CGPoint(x: xPoint, y: yPoint)
        circleMaster.zPosition = CGFloat(zPositionMain + 100)
        circleMaster.name = "\(circleCountLableValue)"
        circleMaster.glowWidth = 0
        circleMaster.strokeColor = UIColor.clear
        self.addChild(circleMaster)
        
        // Add the outer circle to the shape.
        let Circle = SKShapeNode(circleOfRadius: 110 ) // Size of Circle
        Circle.position = CGPoint(x: 0, y: 0)
        Circle.strokeColor = UIColor.white
        Circle.glowWidth = 2
        Circle.zPosition = CGFloat(zPositionMain - 99)
        Circle.name = "notTarget"
        circleMaster.addChild(Circle)
        
        // Add label inside inner circle
        let CircleCounterLabel = SKLabelNode(text: "\(circleCountLableValue)")
        CircleCounterLabel.fontName = "AvenirNext-DemiBold"
        CircleCounterLabel.fontSize = 75
        CircleCounterLabel.fontColor = UIColor(hex: 0xedf0f2)
        CircleCounterLabel.zPosition = CGFloat(zPositionMain - 10)
        CircleCounterLabel.position = CGPoint(x: 0, y: -30)
        CircleCounterLabel.name = "\(circleCountLableValue)"
        circleMaster.addChild(CircleCounterLabel)
        
        // Add the inner circle to the shape.
        let transparentCenterMask = SKShapeNode(circleOfRadius: 55)
        transparentCenterMask.lineWidth = 7
        transparentCenterMask.fillColor = UIColor.purple
        let transparentCenterCrop = SKCropNode()
        transparentCenterCrop.maskNode = transparentCenterMask
        let Circle2 = SKShapeNode(circleOfRadius: 55) // Size of Circle
        Circle2.position = CGPoint(x: 0, y: 0)
        Circle2.fillColor = UIColor.black
        Circle2.zPosition = CGFloat(zPositionMain - 100)
        Circle2.name = "\(circleCountLableValue)"
        Circle2.addChild(transparentCenterMask)
        circleMaster.addChild(Circle2)
        
        // Animate the outer circle.
        let pulseDown = SKAction.scale(to: 1/2, duration: 1/2)
        let wait = SKAction.wait(forDuration: 0.08)
        let pulse = SKAction.sequence([pulseDown, wait])
        
        zPositionMain -= 1
        
        Circle.run(pulse, completion: {
            circleMaster.removeFromParent()
        })
    }
}
