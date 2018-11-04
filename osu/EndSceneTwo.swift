//
//  EndScene.swift
//  osu
//
//  Created by Jiajun Ma on 2/11/18.
//  Copyright © 2018 Jiajun Ma. All rights reserved.
//

import SpriteKit

class EndSceneOne: SKScene {
    
    var userNotification: SKSpriteNode?
    
    var backButton: SKSpriteNode?
    
    var bottomBar: SKSpriteNode?
    var topBar: SKSpriteNode?
    
    var score: SKSpriteNode?
    var scoreValue: Int = 0
    
    var rankTexture: SKTexture?
    var rank: SKSpriteNode?
    var rankCheck: String = "S"
    
    var levelTexture: SKTexture?
    var levelBackground: SKSpriteNode?

    override func didMove(to view: SKView) {
        
        levelTexture = SKTexture(imageNamed: "level-background-1")
        levelBackground = SKSpriteNode(texture: levelTexture)
        levelBackground!.position = CGPoint(x: 0, y: 0)
        levelBackground!.size = CGSize(width: 750, height: 430)
        levelBackground!.zPosition = -10
        addChild(levelBackground!)
        
        userNotification = SKSpriteNode(color: UIColor(red: 134/255, green: 182/255, blue: 48/255, alpha: 1), size: CGSize(width: 300, height: 50))
        userNotification!.position = CGPoint(x: 0, y: 180)
        userNotification!.name = "userNotification"
        userNotification!.zPosition = 10
        userNotification!.alpha = 1
        addChild(userNotification!)
        
        let userNotificationLabel = SKLabelNode(text: "Congratulations, you got:")
        userNotificationLabel.position = CGPoint(x: 0, y: -6)
        userNotificationLabel.fontName = "Arial Bold"
        userNotificationLabel.fontSize = 20
        userNotificationLabel.fontColor = SKColor.white
        userNotificationLabel.name = "userNotificationLabel"
        userNotification!.addChild(userNotificationLabel)
        
        topBar = SKSpriteNode(color: .black, size: CGSize(width: 1334, height: 75))
        topBar!.position = CGPoint(x: 0, y: 182)
        topBar!.name = "topBar"
        topBar!.zPosition = -9
        topBar!.alpha = 0.6
        addChild(topBar!)
        
        score = SKSpriteNode(color: .black, size: CGSize(width: 300, height: 75))
        score!.position = CGPoint(x: 0, y: 50)
        score!.name = "score"
        score!.zPosition = 10
        addChild(score!)
        
        let scoreLabel = SKLabelNode(text: "\(scoreValue)")
        scoreLabel.position = CGPoint(x: 0, y: -7)
        scoreLabel.fontName = "Arial Bold"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor.white
        scoreLabel.name = "scoreLabel"
        score!.addChild(scoreLabel)
        
        bottomBar = SKSpriteNode(color: .black, size: CGSize(width: 1334, height: 75))
        bottomBar!.position = CGPoint(x: 0, y: -182)
        bottomBar!.name = "bottomBar"
        bottomBar!.zPosition = -9
        bottomBar!.alpha = 0.75
        addChild(bottomBar!)
        
        backButton = SKSpriteNode(color: UIColor(red: 186/255, green: 107/255, blue: 192/255, alpha: 1), size: CGSize(width: 150, height: 50))
        backButton!.position = CGPoint(x: -290, y: -180)
        backButton!.name = "backButton"
        backButton!.zPosition = 10
        addChild(backButton!)
        
        let backButtonLabel = SKLabelNode(text: "Back")
        backButtonLabel.position = CGPoint(x: 0, y: -6)
        backButtonLabel.fontName = "Arial Bold"
        backButtonLabel.fontSize = 20
        backButtonLabel.fontColor = SKColor.white
        backButtonLabel.name = "backButtonLabel"
        backButton!.addChild(backButtonLabel)
    
        rankTexture = SKTexture(imageNamed: "grade\(rankCheck)")
        
        rank = SKSpriteNode(texture: rankTexture)
        rank!.position = CGPoint(x: 0, y: -50)
        rank!.size = CGSize(width: 150, height: 100)
        addChild(rank!)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        if touchedNode.name == "backButton" || touchedNode.name == "backButtonLabel" {
            
            let gameScene = SKScene(fileNamed: "GameScene")
            gameScene!.scaleMode = .aspectFill
            scene!.view!.presentScene(gameScene!)
            
        }
        
    }
    
}


