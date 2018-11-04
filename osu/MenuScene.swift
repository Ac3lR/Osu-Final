//
//  GameScene.swift
//  osu
//
//  Created by Jiajun Ma on 11/9/18.
//  Copyright © 2018 Jiajun Ma. All rights reserved.
//


// TODOs for this scene:
// 1. Make a profile page, and prepare the page for NSUserdefults implement
// 2. Make a level bar, and prepare it for NSUserdefults implement

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
// Central Main Menu Variables: Start
    var circle = SKShapeNode(circleOfRadius: 130)
    
    // node to darken background when circle is touched
    var backgroundDampen: SKSpriteNode?
    
    var menuAdded: Bool = false
    var circleClicked: Bool = false
    
    var deleteMenu: Bool = false
    
    var touchEndedOnCircle: Bool = false
// Central Main Menu Variables: End
    
    
    // variable to check if a feature is available
    var featureAvailability: Bool = true
    
    
// Sound Option Variables: Start
    var soundOptions: SKSpriteNode?
    
    var soundOptionsOpen: Bool = false
    var graphicalOptionsOpen: Bool = false
    
    var closeSoundOptions: Bool = false
    var closeGraphicalOptions: Bool = false
    
    var masterVolume: SKSpriteNode?
    var masterVolumeUp: SKSpriteNode?
    var masterVolumeDown: SKSpriteNode?
    var masterVolumeLabelDisplay: SKSpriteNode?
    var masterVolumeValueLabel: SKLabelNode?
    var masterVolumeValue: Int = 5
    
    var musicVolume: SKSpriteNode?
    var musicVolumeUp: SKSpriteNode?
    var musicVolumeDown: SKSpriteNode?
    var musicVolumeLabelDisplay: SKSpriteNode?
    var musicVolumeValueLabel: SKLabelNode?
    var musicVolumeValue: Int = 5
    
    var exitSoundOptions: SKSpriteNode?
// Sound Option Variables: End
    
    
// Graphical Option Variables: Start
    var graphicalOptions: SKSpriteNode?
    
    var dynamicBackgroundOptions: SKSpriteNode?
    var dynamicBackgroundLabel: SKLabelNode?
    var dynamicBackgroundOn: String = "ON"
    var checkDynamicBackgroundOn: Bool = true
    
    var alternateBackgroundOptions: SKSpriteNode?
    var alternatebackgroundLabel: SKLabelNode?
    var alternateBackgroundOn: String = "ON"
    var checkAlternateBackgroundOn: Bool = true
    
    var exitGraphicalOptions: SKSpriteNode?
// Graphical Option Variables: End
    
    
// Option Variables: Start
    var optionDisplayNode: SKSpriteNode?
    var backGroundCustomisatonNode: SKLabelNode?
    var optionsDisplayed: Bool = false
    var exitOptions: SKSpriteNode?
// Option Variables: End
    
    
// Song / Musicplayer Variables: Start
    let numberOfMenuSongs: Int = 3
    var songPlaying: Bool = false
    
    var Player: AVAudioPlayer?
    var mainMenuMusic = Int(UInt32(arc4random_uniform(3) + 1))
    var menuBackgroundMusic = SKAudioNode(fileNamed: "menu-music-1")
    var MusicPath = Bundle.main.url(forResource: "menu-music-1", withExtension: ".mp3")
    
    var previousSongNode: SKSpriteNode?
    var playSongNode: SKSpriteNode?
    var pauseSongNode: SKSpriteNode?
    var stopSongNode: SKSpriteNode?
    var nextSongNode: SKSpriteNode?
    
    var songNameDisplayNode: SKSpriteNode?
    var songNameNode: SKLabelNode?
// Song / Musicplayer Variables: End
    
    
// osu! Top Menu Variables: Start
    var topBarLayout: SKSpriteNode?
    
    var gametimeTimer: Timer?
    var realtimeTimer: Timer?
    
    var secondsRunning = 0
    var minutesRunning = 0
    var hoursRunning = 0
    
    var beatMapsAvailable = 3
    var currentTime = Date()
// osu! Top Menu Variables: End
    
    
// osu! Bottom Menu Variables: Start
    var bottomBarLayout: SKSpriteNode?
    
    let uselessTips = ["Make sure to take breaks every so often, your hands has other uses too!", "You can customise your experience by going into the options", "Create a profile and start competing with your friends!", "You can customise your character profile by clicking your profile picture!", "Change the menu song by pressing the music player in the main menu"]
// osu! Bottom Menu Variables: End
    
    
// Profile Variables: Start
    var profileNode: SKSpriteNode?
    
    var playerName = "Guest"
    var playerNameNode: SKLabelNode?
    
    var playerLevel = String(1)
    var playerLevelNode: SKLabelNode?
    
    var playerExperience: Int = 0
    
    // checks if the profile was touched
    var profileEditDisplayed: Bool = false
    
    var editProfileName: SKSpriteNode?
    var resetProgress: SKSpriteNode?
    var exitProfileOptions: SKSpriteNode?
    var profileOptionDisplayNode: SKSpriteNode?
// Profile Variables: End
    
    
// Menu Node Variables: Start
    // checks if the user's finger is currently on the circle
    var circleExpanded: Bool = false

    var arNode: SKSpriteNode?
    var playGameNode: SKSpriteNode?
    var exitNode: SKSpriteNode?
    var optionNode: SKSpriteNode?
    
    var playSingleplayer: SKSpriteNode?
    var playMultiplayer: SKSpriteNode?
    var backButton: SKSpriteNode?
    
    // checks if the user tapped the playSinglePlayer node
    var playButtonTapped: Bool = false
// Menu Node Variables: End
    
    
    // randomly selects a number for the background
    let backgroundSelection: Int = Int(UInt32(arc4random_uniform(4) + 1))
    
    var userDefaults = UserDefaults.standard
    
//------------------------------------------------------------------------------------------------------------------------------------------
    
    override func didMove(to view: SKView) {
        
        masterVolumeValue = userDefaults.value(forKey: "MasterVolumeValue") as? Int ?? 5
        musicVolumeValue = userDefaults.value(forKey: "MusicVolumeValue")  as? Int ?? 5
        
        // plays the randomly selected menu music
        MusicPath = Bundle.main.url(forResource: "menu-music-\(mainMenuMusic)", withExtension: ".mp3")
        
        do {
            Player = try AVAudioPlayer(contentsOf: MusicPath!)
            Player!.volume = Float(musicVolumeValue * 3)
            Player!.play()
        }
            
        catch {
            let theError = error as NSError
            print("Could not play song \(theError)")
        }

        songPlaying = true
        
        // adds the backgroundDampen node to the scene
        backgroundDampen = SKSpriteNode(color: .darkGray, size: CGSize(width: 750, height: 420))
        backgroundDampen!.zPosition = -9
        backgroundDampen!.alpha = 0.0
        
        addChild(backgroundDampen!)

        // sets the background of the menu
        let backgroundTexture = SKTexture(imageNamed: "menu-background-\(backgroundSelection)")
        let backgroundNode = SKSpriteNode(texture: backgroundTexture, size: CGSize(width: 750, height: 420))

        // makes sure the background is in the background
        backgroundNode.zPosition = -10

        addChild(backgroundNode)

        // adds the main circle to the scene
        let circleTexture = SKTexture(imageNamed: "osuTexture")
        
        circle.lineWidth = 0
        circle.position = CGPoint(x: 0, y: 0)
        circle.fillColor = UIColor.white
        circle.fillTexture = circleTexture
        circle.name = "circle"
        circle.zPosition = 11

        addChild(circle)
        
        // sets the circle to be 1.0 times its size
        circle.setScale(1)
        
        // adds a pulsing action to the circle
        let pulseUp = SKAction.scale(to: 1.11, duration: 0.25)
        let pulseDown = SKAction.scale(to: 1.0, duration: 0.25)
        let pulse = SKAction.sequence([pulseDown, pulseUp])
        let repeatPulse = SKAction.repeatForever(pulse)
        circle.run(SKAction.sequence([repeatPulse]))
        
        // adds the bottom bar to the scene
        bottomBarLayout = SKSpriteNode(color: .darkGray, size: CGSize(width: 1334, height: 60))
        bottomBarLayout!.position = CGPoint(x: 0, y: -182)
        bottomBarLayout!.name = "bottomBarDisplay"
        bottomBarLayout!.zPosition = -9
        bottomBarLayout!.alpha = 0.6
        
        // generates a random tip
        let uselessTipsGenerator: Int = Int(UInt32(arc4random_uniform(UInt32(uselessTips.count))))
        
        // adds the random tip to the scene
        let tipsLabelNode = SKLabelNode(text: "\(uselessTips[uselessTipsGenerator])")
        tipsLabelNode.fontName = "Arial Bold"
        tipsLabelNode.fontSize = 18
        tipsLabelNode.fontColor = SKColor.white
        tipsLabelNode.name = "text"
        tipsLabelNode.position = CGPoint(x: 0, y: -187)
        tipsLabelNode.alpha = 1
        
        addChild(bottomBarLayout!)
        addChild(tipsLabelNode)
        
        // adds the top bar to the scene
        topBarLayout = SKSpriteNode(color: .darkGray, size: CGSize(width: 1334, height: 60))
        topBarLayout!.position = CGPoint(x: 0, y: 182)
        topBarLayout!.name = "topBarDisplay"
        topBarLayout!.zPosition = -9
        topBarLayout!.alpha = 0.6
        addChild(topBarLayout!)
        
        // adds the user profile picture to the scene
        let profilePictureTexture = SKTexture(imageNamed: "profilePicture")
        
        profileNode = SKSpriteNode(texture: profilePictureTexture)
        profileNode!.size = CGSize(width: 50, height: 50)
        profileNode!.position = CGPoint(x: -345, y: 182)
        profileNode!.alpha = 1
        profileNode!.zPosition = 13
        profileNode!.name = "profileNode"
        addChild(profileNode!)
        
        // adds the user's profile name to the scene
        playerNameNode = SKLabelNode(text: "\(playerName)")
        playerNameNode!.fontName = "Arial Bold"
        playerNameNode!.position = CGPoint(x: -300, y: 192)
        playerNameNode!.fontSize = 12
        playerNameNode!.fontColor = SKColor.white
        playerNameNode!.name = "playerName"
        playerNameNode!.alpha = 1
        playerNameNode!.zPosition = 13
        addChild(playerNameNode!)
        
        // adds the user's profile level to the scene
        playerLevelNode = SKLabelNode(text: "Level \(playerLevel)")
        playerLevelNode!.fontName = "Arial Bold"
        playerLevelNode!.position = CGPoint(x: -300, y: 177)
        playerLevelNode!.fontSize = 10
        playerLevelNode!.fontColor = SKColor.white
        playerLevelNode!.name = "playerName"
        playerLevelNode!.alpha = 1
        playerLevelNode!.zPosition = 13
        addChild(playerLevelNode!)
        
        // gets the current date
        var formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        var realTime = formatter.string(from: currentTime)
        
        // adds the text for the top bar
        let gamemapInfomationNode = SKLabelNode(text: "You have \(beatMapsAvailable) beatmaps available!")
        gamemapInfomationNode.fontName = "Arial Bold"
        gamemapInfomationNode.fontSize = 10
        gamemapInfomationNode.fontColor = SKColor.white
        gamemapInfomationNode.name = "playerName"
        gamemapInfomationNode.alpha = 1
        gamemapInfomationNode.position = CGPoint(x: 0, y: 192)
        addChild(gamemapInfomationNode)
        
        // adds the ingame timer
        let gametimeInfomationNode = SKLabelNode(text: "osu! has been running for \(secondsRunning) seconds.")
        gametimeInfomationNode.fontName = "Arial Bold"
        gametimeInfomationNode.fontSize = 10
        gametimeInfomationNode.fontColor = SKColor.white
        gametimeInfomationNode.name = "playerName"
        gametimeInfomationNode.alpha = 1
        gametimeInfomationNode.position = CGPoint(x: 0, y: 177)
        addChild(gametimeInfomationNode)
        
        // adds the "clock"
        let realtimeInfomationNode = SKLabelNode(text: "It is currently \(realTime)")
        realtimeInfomationNode.fontName = "Arial Bold"
        realtimeInfomationNode.fontSize = 10
        realtimeInfomationNode.fontColor = SKColor.white
        realtimeInfomationNode.name = "playerName"
        realtimeInfomationNode.alpha = 1
        realtimeInfomationNode.position = CGPoint(x: 0, y: 162)
        addChild(realtimeInfomationNode)
        
        // runs a timer depending on how long the game has been running
        gametimeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            
            self.secondsRunning = self.secondsRunning + 1
            
            if self.secondsRunning < 60 {
                
                gametimeInfomationNode.text = "osu! has been running for \(self.secondsRunning) seconds."
                
            }
            
            if self.secondsRunning % 60 == 0 && self.secondsRunning > 1 {
                
                self.minutesRunning = self.minutesRunning + 1
                gametimeInfomationNode.text = "osu! has been running for \(self.minutesRunning) minutes."
                
            }
            
            if self.minutesRunning % 60 == 0 && self.minutesRunning > 1 {
                
                self.hoursRunning = self.hoursRunning + 1
                gametimeInfomationNode.text = "osu! has been running for \(self.hoursRunning) hours."
                
            }
            
            if self.hoursRunning > 24 {
                
                gametimeInfomationNode.text = "get a life"
                
            }
            
        })
        
        // determines the current time
        realtimeTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            
            self.currentTime = Date()
            
            formatter = DateFormatter()
            formatter.timeStyle = .short
            formatter.dateStyle = .none
            
            realTime = formatter.string(from: self.currentTime)
            realtimeInfomationNode.text = "It is currently \(realTime)"
            
        })
        
        // adds the music player
        songNameDisplayNode = SKSpriteNode(color: .black, size: CGSize(width: 146, height: 20))
        songNameDisplayNode!.position = CGPoint(x: 305, y: 194)
        songNameDisplayNode!.name = "songNameDisplay"
        songNameDisplayNode!.zPosition = 1
        songNameDisplayNode!.alpha = 0.5
        addChild(songNameDisplayNode!)
        
        // checks which song is currently playing
        if mainMenuMusic == 1 {
            
            songNameNode = SKLabelNode(text: "NCS - Circles")
            songNameNode!.position = CGPoint(x: 305, y: 190)
            songNameNode!.fontName = "Arial Bold"
            songNameNode!.fontSize = 10
            songNameNode!.fontColor = SKColor.white
            songNameNode!.name = "songName"
            songNameNode!.alpha = 11
            
            addChild(songNameNode!)
            
        }
        
        if mainMenuMusic == 2 {
            
            songNameNode = SKLabelNode(text: "F777 - Lets Stomp")
            songNameNode!.position = CGPoint(x: 305, y: 190)
            songNameNode!.fontName = "Arial Bold"
            songNameNode!.fontSize = 10
            songNameNode!.fontColor = SKColor.white
            songNameNode!.name = "songName"
            songNameNode!.alpha = 11
            
            addChild(songNameNode!)
            
        }
        
        if mainMenuMusic == 3 {
            
            songNameNode = SKLabelNode(text: "Camellia - Atmosphere")
            songNameNode!.position = CGPoint(x: 305, y: 190)
            songNameNode!.fontName = "Arial Bold"
            songNameNode!.fontSize = 10
            songNameNode!.fontColor = SKColor.white
            songNameNode!.name = "songName"
            songNameNode!.alpha = 11
            
            addChild(songNameNode!)
            
        }
        
        // adds the music player button to the scene
        let previousSongTexture = SKTexture(imageNamed: "previousSongTexture")
        let pauseSongTexture = SKTexture(imageNamed: "pauseSongTexture")
        let playSongTexture = SKTexture(imageNamed: "playSongTexture")
        let stopSongTexture = SKTexture(imageNamed: "stopSongTexture")
        let nextSongTexture = SKTexture(imageNamed: "nextSongTexture")
        
        previousSongNode = SKSpriteNode(texture: previousSongTexture)
        previousSongNode!.size = CGSize(width: 20, height: 20)
        previousSongNode!.position = CGPoint(x: 255, y: 167)
        previousSongNode!.name = "previousButton"
        previousSongNode!.zPosition = 1
        addChild(previousSongNode!)
        
        pauseSongNode = SKSpriteNode(texture: pauseSongTexture)
        pauseSongNode!.size = CGSize(width: 20, height: 20)
        pauseSongNode!.position = CGPoint(x: 280, y: 167)
        pauseSongNode!.name = "pauseButton"
        pauseSongNode!.zPosition = 1
        addChild(pauseSongNode!)
        
        playSongNode = SKSpriteNode(texture: playSongTexture)
        playSongNode!.size = CGSize(width: 20, height: 20)
        playSongNode!.position = CGPoint(x: 305, y: 167)
        playSongNode!.name = "playButton"
        pauseSongNode!.zPosition = 1
        addChild(playSongNode!)
        
        stopSongNode = SKSpriteNode(texture: stopSongTexture)
        stopSongNode!.size = CGSize(width: 20, height: 20)
        stopSongNode!.position = CGPoint(x: 330, y: 167)
        stopSongNode!.name = "stopButton"
        stopSongNode!.zPosition = 1
        addChild(stopSongNode!)
        
        nextSongNode = SKSpriteNode(texture: nextSongTexture)
        nextSongNode!.size = CGSize(width: 20, height: 20)
        nextSongNode!.position = CGPoint(x: 355, y: 167)
        nextSongNode!.name = "nextButton"
        nextSongNode!.zPosition = 1
        addChild(nextSongNode!)
        
    }
    
    
    //---------------------------------------------------------------------------------------------------------------------------------------
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
        // removes the pulsing action and expands the circle
        if touchedNode.name == "circle" {
            
            circle.removeAllActions()
            
            let circleExpand = SKAction.scale(by: 1.05, duration: 0.1)
            
            if circleExpanded == false {
                
                circleExpanded = true
                circle.run(circleExpand)
                
            }
            
            circleClicked = true
            
        }
        
        // goes to the previous song
        if touchedNode.name == "previousButton" {
            
            var newSongNumber = 0
            
            Player?.stop()
            
            if (mainMenuMusic - 1) >= 1 {
                newSongNumber = mainMenuMusic - 1
            }
                
            else {
                newSongNumber = 3
            }
            
            MusicPath = Bundle.main.url(forResource: "menu-music-\(newSongNumber)", withExtension: ".mp3")
            
            do {
                Player = try AVAudioPlayer(contentsOf: MusicPath!)
                Player!.volume = Float(musicVolumeValue * 3)
                Player!.play()
                
            }
                
            catch {
                let theError = error as NSError
                
                print("Could not play song \(theError)")
                
            }
            
            mainMenuMusic = newSongNumber
            
            if mainMenuMusic == 1 {
                songNameNode!.text = "NCS - Circles"
            }
            
            if mainMenuMusic == 2 {
                songNameNode!.text = "F777 - Lets Stomp"
            }
            
            if mainMenuMusic == 3 {
                songNameNode!.text = "Camellia - Atmosphere"
            }
            
        }
        
        // plays the song
        if touchedNode.name == "playButton" && songPlaying == false {
            
            Player?.play()
            
        }
        
        // pauses the song
        if touchedNode.name == "pauseButton" {
            
            songPlaying = false
            Player?.pause()
            
        }
        
        // stops the song
        if touchedNode.name == "stopButton" {
            
            songPlaying = false
            Player?.stop()
            Player?.currentTime = 0
            
        }
        
        // goes the the next song
        if touchedNode.name == "nextButton" {
            
            var newSongNumber = 0
            
            Player?.stop()
            
            if (mainMenuMusic + 1) <= 3 {
                newSongNumber = mainMenuMusic + 1
            }
                
            else {
                newSongNumber = 1
            }
            
            MusicPath = Bundle.main.url(forResource: "menu-music-\(newSongNumber)", withExtension: ".mp3")
            
            do {
                Player = try AVAudioPlayer(contentsOf: MusicPath!)
                Player!.volume = Float(musicVolumeValue * 3)
                Player!.play()
                
            }
                
            catch {
                let theError = error as NSError
                
                print("Could not play song \(theError)")
                
            }
            
            mainMenuMusic = newSongNumber
            
            if mainMenuMusic == 1 {
                songNameNode!.text = "NCS - Circles"
            }
            
            if mainMenuMusic == 2 {
                songNameNode!.text = "F777 - Lets Stomp"
            }
            
            if mainMenuMusic == 3 {
                songNameNode!.text = "Camellia - Atmosphere"
            }
            
        }
        
        // removes all the previous menu nodes and adds the solo/multi nodes
        if touchedNode.name == "playGame" || touchedNode.name == "playGameText" {
            
            songPlaying = false
            
            playGameNode!.removeFromParent()
            arNode!.removeFromParent()
            optionNode!.removeFromParent()
            exitNode!.removeFromParent()
            
            playSingleplayer = SKSpriteNode(color: UIColor(red: 101/255, green: 78/255, blue: 173/255, alpha: 1), size: CGSize(width: 240, height: 50))
            playSingleplayer!.position = CGPoint(x: 190, y: 30)
            playSingleplayer!.name = "playSingleGame"
            playSingleplayer!.zPosition = 10
            playSingleplayer!.alpha = 0.9
            
            let playSingleplayerLabel = SKLabelNode(text: "Solo")
            playSingleplayerLabel.fontName = "Arial Bold"
            playSingleplayerLabel.fontSize = 21
            playSingleplayerLabel.fontColor = SKColor.white
            playSingleplayerLabel.name = "playSingleText"
            playSingleplayerLabel.position = CGPoint(x: 3, y: -7)
            
            playMultiplayer = SKSpriteNode(color: UIColor(red: 101/255, green: 78/255, blue: 173/255, alpha: 1), size: CGSize(width: 240, height: 50))
            playMultiplayer!.position = CGPoint(x: 190, y: -30)
            playMultiplayer!.name = "playMultiGame"
            playMultiplayer!.zPosition = 10
            playMultiplayer!.alpha = 0.9
            
            let playMultiplayerLabel = SKLabelNode(text: "Multi")
            playMultiplayerLabel.fontName = "Arial Bold"
            playMultiplayerLabel.fontSize = 21
            playMultiplayerLabel.fontColor = SKColor.white
            playMultiplayerLabel.name = "playMultiText"
            playMultiplayerLabel.position = CGPoint(x: 3, y: -7)
            
            addChild(playMultiplayer!)
            playMultiplayer!.addChild(playMultiplayerLabel)
            
            addChild(playSingleplayer!)
            playSingleplayer!.addChild(playSingleplayerLabel)
            
            playButtonTapped = true
            
        }
        
        // goes to level selection scene
        if touchedNode.name == "playSingleGame" || touchedNode.name == "playSingleText" {
            
            songPlaying = false
            Player?.stop()
            
            let levelSelectionScene = SKScene(fileNamed: "LevelSelection")
            levelSelectionScene!.scaleMode = .aspectFill
            scene!.view!.presentScene(levelSelectionScene!)
            
        }
        
        // goes to not availble scene
        if touchedNode.name == "augmentedGame" || touchedNode.name == "augmentedGametext" {
            
            songPlaying = false
            Player?.stop()
            
            let notAvailableScene = SKScene(fileNamed: "NotAvailableScene")
            notAvailableScene!.scaleMode = .aspectFill
            scene!.view!.presentScene(notAvailableScene!)
            
        }
        
        // goes to not availble scene
        if touchedNode.name == "exitGame" || touchedNode.name == "exitGameText" {
            
            songPlaying = false
            Player?.stop()
            
            let notAvailableScene = SKScene(fileNamed: "NotAvailableScene")
            notAvailableScene!.scaleMode = .aspectFill
            scene!.view!.presentScene(notAvailableScene!)
            
        }
        
        // goes to not availble scene
        if touchedNode.name == "playMultiGame" || touchedNode.name == "playMultiText" {
            
            songPlaying = false
            Player?.stop()
            
            let notAvailableScene = SKScene(fileNamed: "NotAvailableScene")
            notAvailableScene!.scaleMode = .aspectFill
            scene!.view!.presentScene(notAvailableScene!)
            
            
        }
        
        // exits out of sound options
        if soundOptionsOpen == true && touchedNode.name == "exitSoundOptionsButton" || touchedNode.name == "ExitSoundOptionsLabel" {
            
            closeSoundOptions = true
            
        }
        
        // exits out of graphical options
        if graphicalOptionsOpen == true && touchedNode.name == "exitGraphicalOptionsButton" || touchedNode.name == "ExitGraphicOptionsLabel" {
            
            closeGraphicalOptions = true
            
        }
        
        // if options is pressed from the menu or if the user wants to return to the options:
        if touchedNode.name == "optionButton" || touchedNode.name == "optionButtonText" || touchedNode.name == "exitSoundOptionsButton" || touchedNode.name == "ExitSoundOptionsLabel" || touchedNode.name == "exitGraphicalOptionsButton" || touchedNode.name == "ExitGraphicOptionsLabel" {
            
            if soundOptionsOpen == false && graphicalOptionsOpen == false {

                // removes nodes circle and its nodes
                for child in (scene?.children)! {
                    if child.name == "playGame" || child.name == "augmentedGame" || child.name == "exitGame" || child.name == "optionButton" {
                        child.removeFromParent()
                    }
                }
                
                circle.removeAllActions()
                circle.removeFromParent()
                
                profileNode!.removeFromParent()
                playerNameNode!.removeFromParent()
                playerLevelNode!.removeFromParent()
                
                optionDisplayNode = SKSpriteNode(color: .black, size: CGSize(width: 800, height: 422))
                optionDisplayNode!.position = CGPoint(x: 0, y: 0)
                optionDisplayNode!.zPosition = 12
                optionDisplayNode!.name = "optionDispay"
                optionDisplayNode!.alpha = 0.6
                
                addChild(optionDisplayNode!)
                
            }
            
            // returns from sound options
            if closeSoundOptions == true {
                
                masterVolume!.removeFromParent()
                masterVolumeUp!.removeFromParent()
                masterVolumeDown!.removeFromParent()
                
                musicVolume!.removeFromParent()
                musicVolumeUp!.removeFromParent()
                musicVolumeDown!.removeFromParent()
                
                exitSoundOptions!.removeFromParent()
                
                backgroundDampen!.alpha = 0
                
                closeSoundOptions = false
                soundOptionsOpen = false
                
            }
            
            // returns from graphical options
            if closeGraphicalOptions == true {
                
                dynamicBackgroundOptions!.removeFromParent()
                alternateBackgroundOptions!.removeFromParent()
                
                exitGraphicalOptions!.removeFromParent()
                
                backgroundDampen!.alpha = 0
                
                closeGraphicalOptions = false
                graphicalOptionsOpen = false
                
            }
            
            // creates the nodes for options
            soundOptions = SKSpriteNode(color: UIColor(red: 134/255, green: 182/255, blue: 48/255, alpha: 1), size: CGSize(width: 300, height: 50))
            soundOptions!.position = CGPoint(x: 0, y: 80)
            soundOptions!.zPosition = 13
            soundOptions!.name = "soundOptionsButton"
            
            let soundOptionsLabel = SKLabelNode(text: "Sound Options")
            soundOptionsLabel.position = CGPoint(x: 0, y: -6)
            soundOptionsLabel.fontName = "Arial Bold"
            soundOptionsLabel.fontSize = 20
            soundOptionsLabel.fontColor = SKColor.white
            soundOptionsLabel.name = "soundOptionsLabel"
            
            addChild(soundOptions!)
            soundOptions!.addChild(soundOptionsLabel)
            
            graphicalOptions = SKSpriteNode(color: UIColor(red: 223/255, green: 49/255, blue: 24/255, alpha: 1), size: CGSize(width: 300, height: 50))
            graphicalOptions!.position = CGPoint(x: 0, y: 0)
            graphicalOptions!.zPosition = 13
            graphicalOptions!.name = "graphicalOptionsButton"
            
            let graphicalOptionsLabel = SKLabelNode(text: "Graphical Options")
            graphicalOptionsLabel.position = CGPoint(x: 0, y: -6)
            graphicalOptionsLabel.fontName = "Arial Bold"
            graphicalOptionsLabel.fontSize = 20
            graphicalOptionsLabel.fontColor = SKColor.white
            graphicalOptionsLabel.name = "graphicalOptionsLabel"
            
            addChild(graphicalOptions!)
            graphicalOptions!.addChild(graphicalOptionsLabel)
            
            exitOptions = SKSpriteNode(color: UIColor(red: 186/255, green: 107/255, blue: 192/255, alpha: 1), size: CGSize(width: 300, height: 50))
            exitOptions!.position = CGPoint(x: 0, y: -80)
            exitOptions!.zPosition = 13
            exitOptions!.name = "exitOptionsButton"
            
            let exitOptionsLabel = SKLabelNode(text: "Exit Options")
            exitOptionsLabel.position = CGPoint(x: 0, y: -6)
            exitOptionsLabel.fontName = "Arial Bold"
            exitOptionsLabel.fontSize = 20
            exitOptionsLabel.fontColor = SKColor.white
            exitOptionsLabel.name = "ExitOptionsLabel"
            
            addChild(exitOptions!)
            exitOptions!.addChild(exitOptionsLabel)
            
            optionsDisplayed = true
            
        }
        
        // exit out of options
        if  optionsDisplayed == true && touchedNode.name == "exitOptionsButton" || touchedNode.name == "ExitOptionsLabel" {
            
            optionsDisplayed = false
            
            optionDisplayNode!.removeFromParent()
            
            soundOptions!.removeFromParent()
            graphicalOptions!.removeFromParent()
            exitOptions!.removeFromParent()
            
            // re adds the circle node and runs its pusle action
            addChild(circle)
            
            //re adds the profile nodes
            addChild(profileNode!)
            addChild(playerNameNode!)
            addChild(playerLevelNode!)
            
            circle.setScale(1)
            
            let pulseUp = SKAction.scale(to: 1.11, duration: 0.25)
            let pulseDown = SKAction.scale(to: 1.0, duration: 0.25)
            let pulse = SKAction.sequence([pulseDown, pulseUp])
            let repeatPulse = SKAction.repeatForever(pulse)
            circle.run(SKAction.sequence([repeatPulse]))
            
        }
        
        // opens the sound options
        if optionsDisplayed == true && touchedNode.name == "soundOptionsButton" || touchedNode.name == "soundOptionsLabel" {
            
            soundOptionsOpen = true
            
            soundOptions!.removeFromParent()
            graphicalOptions!.removeFromParent()
            exitOptions!.removeFromParent()
            
            backgroundDampen!.alpha = 0.3
            
            masterVolume = SKSpriteNode(color: UIColor(red: 134/255, green: 182/255, blue: 48/255, alpha: 1), size: CGSize(width: 180, height: 50))
            masterVolume!.position = CGPoint(x: 0, y: 80)
            masterVolume!.name = "masterVolume"
            masterVolume!.zPosition = 13
            addChild(masterVolume!)
            
            masterVolumeValueLabel = SKLabelNode(text: "Master Volume: \(masterVolumeValue)")
            masterVolumeValueLabel!.position = CGPoint(x: 0, y: -6)
            masterVolumeValueLabel!.fontName = "Arial Bold"
            masterVolumeValueLabel!.fontSize = 20
            masterVolumeValueLabel!.fontColor = SKColor.white
            masterVolumeValueLabel!.name = "masterVolumeValueDisplay"
            masterVolume!.addChild(masterVolumeValueLabel!)
            
            masterVolumeUp = SKSpriteNode(color: .gray, size: CGSize(width: 50, height: 50))
            masterVolumeUp!.position = CGPoint(x: -120, y: 80)
            masterVolumeUp!.name = "masterVolumeDown"
            masterVolumeUp!.zPosition = 13
            addChild(masterVolumeUp!)
            
            masterVolumeDown = SKSpriteNode(color: .gray, size: CGSize(width: 50, height: 50))
            masterVolumeDown!.position = CGPoint(x: 120, y: 80)
            masterVolumeDown!.name = "masterVolumeUp"
            masterVolumeDown!.zPosition = 13
            addChild(masterVolumeDown!)
            
            musicVolume = SKSpriteNode(color: UIColor(red: 223/255, green: 49/255, blue: 24/255, alpha: 1), size: CGSize(width: 180, height: 50))
            musicVolume!.position = CGPoint(x: 0, y: 0)
            musicVolume!.name = "musicVolume"
            musicVolume!.zPosition = 13
            addChild(musicVolume!)
            
            musicVolumeValueLabel = SKLabelNode(text: "Music Volume: \(musicVolumeValue)")
            musicVolumeValueLabel!.position = CGPoint(x: 0, y: -6)
            musicVolumeValueLabel!.fontName = "Arial Bold"
            musicVolumeValueLabel!.fontSize = 20
            musicVolumeValueLabel!.fontColor = SKColor.white
            musicVolumeValueLabel!.name = "musicVolumeValueDisplay"
            musicVolume!.addChild(musicVolumeValueLabel!)
            
            musicVolumeUp = SKSpriteNode(color: .gray, size: CGSize(width: 50, height: 50))
            musicVolumeUp!.position = CGPoint(x: 120, y: 0)
            musicVolumeUp!.name = "musicVolumeUp"
            musicVolumeUp!.zPosition = 13
            addChild(musicVolumeUp!)
            
            musicVolumeDown = SKSpriteNode(color: .gray, size: CGSize(width: 50, height: 50))
            musicVolumeDown!.position = CGPoint(x: -120, y: 0)
            musicVolumeDown!.name = "musicVolumeDown"
            musicVolumeDown!.zPosition = 13
            addChild(musicVolumeDown!)
            
            exitSoundOptions = SKSpriteNode(color: UIColor(red: 186/255, green: 107/255, blue: 192/255, alpha: 1), size: CGSize(width: 300, height: 50))
            exitSoundOptions!.position = CGPoint(x: 0, y: -80)
            exitSoundOptions!.zPosition = 13
            exitSoundOptions!.name = "exitSoundOptionsButton"
            addChild(exitSoundOptions!)
            
            let exitSoundOptionsLabel = SKLabelNode(text: "Back")
            exitSoundOptionsLabel.position = CGPoint(x: 0, y: -6)
            exitSoundOptionsLabel.fontName = "Arial Bold"
            exitSoundOptionsLabel.fontSize = 20
            exitSoundOptionsLabel.fontColor = SKColor.white
            exitSoundOptionsLabel.name = "ExitSoundOptionsLabel"
            exitSoundOptions!.addChild(exitSoundOptionsLabel)
            
        }
        
        if soundOptionsOpen == true && touchedNode.name == "masterVolumeUp" || touchedNode.name == "masterVolumeDown" {
            
            if touchedNode.name == "masterVolumeUp" && masterVolumeValue + 1 <= 10 {
                
                masterVolumeValue = masterVolumeValue + 1
                masterVolumeValueLabel!.text = "Master Volume: \(masterVolumeValue)"
                
                userDefaults.setValue(masterVolumeValue, forKey: "MasterVolumeValue")
                
                Player!.volume = Float((musicVolumeValue * masterVolumeValue))
                
            }
            
            if touchedNode.name == "masterVolumeDown" && masterVolumeValue - 1 >= 0 {
                
                masterVolumeValue = masterVolumeValue - 1
                masterVolumeValueLabel!.text = "Master Volume: \(masterVolumeValue)"
                
                userDefaults.setValue(masterVolumeValue, forKey: "MasterVolumeValue")
                
                Player!.volume = Float((musicVolumeValue * masterVolumeValue))
                
            }
            
        }
        
        if soundOptionsOpen == true && touchedNode.name == "musicVolumeUp" || touchedNode.name == "musicVolumeDown" {
            
            if touchedNode.name == "musicVolumeUp" && musicVolumeValue + 1 <= 10 {
                
                musicVolumeValue = musicVolumeValue + 1
                musicVolumeValueLabel!.text = "Music Volume: \(musicVolumeValue)"
                
                userDefaults.setValue(musicVolumeValue, forKey: "MusicVolumeValue")

                Player!.volume = Float((musicVolumeValue * masterVolumeValue))
                
            }
            
            if touchedNode.name == "musicVolumeDown" && musicVolumeValue - 1 >= 0 {
                
                musicVolumeValue = musicVolumeValue - 1
                musicVolumeValueLabel!.text = "Music Volume: \(musicVolumeValue)"
                
                userDefaults.setValue(musicVolumeValue, forKey: "MusicVolumeValue")
                
                Player!.volume = Float((musicVolumeValue * masterVolumeValue))

                
            }
            
        }
        
        // opens the graphical options
        if optionsDisplayed == true && touchedNode.name == "graphicalOptionsButton" || touchedNode.name == "graphicalOptionsLabel" {
            
            graphicalOptionsOpen = true
            
            soundOptions!.removeFromParent()
            graphicalOptions!.removeFromParent()
            exitOptions!.removeFromParent()
            
            backgroundDampen!.alpha = 0.3
            
            dynamicBackgroundOptions = SKSpriteNode(color: UIColor(red: 134/255, green: 182/255, blue: 48/255, alpha: 1), size: CGSize(width: 300, height: 50))
            dynamicBackgroundOptions!.position = CGPoint(x: 0, y: 80)
            dynamicBackgroundOptions!.name = "dynamicBackgroundOptions"
            dynamicBackgroundOptions!.zPosition = 13
            addChild(dynamicBackgroundOptions!)
            
            dynamicBackgroundLabel = SKLabelNode(text: "Dynamic Background: \(dynamicBackgroundOn)")
            dynamicBackgroundLabel!.zPosition = 13
            dynamicBackgroundLabel!.position = CGPoint(x: 0, y: -6)
            dynamicBackgroundLabel!.fontName = "Arial Bold"
            dynamicBackgroundLabel!.fontSize = 20
            dynamicBackgroundLabel!.fontColor = SKColor.white
            dynamicBackgroundLabel!.name = "dynamicBackgroundLabel"
            dynamicBackgroundOptions!.addChild(dynamicBackgroundLabel!)
            
            alternateBackgroundOptions = SKSpriteNode(color: UIColor(red: 223/255, green: 49/255, blue: 24/255, alpha: 1), size: CGSize(width: 300, height: 50))
            alternateBackgroundOptions!.position = CGPoint(x: 0, y: 0)
            alternateBackgroundOptions!.name = "alternateBackgroundOptions"
            alternateBackgroundOptions!.zPosition = 13
            addChild(alternateBackgroundOptions!)
            
            alternatebackgroundLabel = SKLabelNode(text: "Alternate Background: \(alternateBackgroundOn)")
            alternatebackgroundLabel!.zPosition = 13
            alternatebackgroundLabel!.position = CGPoint(x: 0, y: -6)
            alternatebackgroundLabel!.fontName = "Arial Bold"
            alternatebackgroundLabel!.fontSize = 20
            alternatebackgroundLabel!.fontColor = SKColor.white
            alternatebackgroundLabel!.name = "alternatebackgroundLabel"
            alternateBackgroundOptions!.addChild(alternatebackgroundLabel!)
            
            exitGraphicalOptions = SKSpriteNode(color: UIColor(red: 186/255, green: 107/255, blue: 192/255, alpha: 1), size: CGSize(width: 300, height: 50))
            exitGraphicalOptions!.position = CGPoint(x: 0, y: -80)
            exitGraphicalOptions!.zPosition = 13
            exitGraphicalOptions!.name = "exitGraphicalOptionsButton"
            addChild(exitGraphicalOptions!)
            
            let exitGraphicalOptionsLabel = SKLabelNode(text: "Back")
            exitGraphicalOptionsLabel.zPosition = 13
            exitGraphicalOptionsLabel.position = CGPoint(x: 0, y: -6)
            exitGraphicalOptionsLabel.fontName = "Arial Bold"
            exitGraphicalOptionsLabel.fontSize = 20
            exitGraphicalOptionsLabel.fontColor = SKColor.white
            exitGraphicalOptionsLabel.name = "ExitGraphicOptionsLabel"
            exitGraphicalOptions!.addChild(exitGraphicalOptionsLabel)
            
        }
        
        // graphical option selection: Dynamic Background
        if graphicalOptionsOpen == true && touchedNode.name == "dynamicBackgroundOptions" || touchedNode.name == "dynamicBackgroundLabel" {
            
            if checkDynamicBackgroundOn == true {
                
            checkDynamicBackgroundOn = false
            dynamicBackgroundOn = "OFF"
            dynamicBackgroundLabel!.text = "Dynamic Background: \(dynamicBackgroundOn)"
                
            }
            
            else if checkDynamicBackgroundOn == false {
                
                checkDynamicBackgroundOn = true
                dynamicBackgroundOn = "ON"
                dynamicBackgroundLabel!.text = "Dynamic Background: \(dynamicBackgroundOn)"
                
            }
            
        }
        
        // graphical option selection: Alternate Background
        if graphicalOptionsOpen == true && touchedNode.name == "alternateBackgroundOptions" || touchedNode.name == "alternatebackgroundLabel" {
            
            if checkAlternateBackgroundOn == true {
                
                checkAlternateBackgroundOn = false
                alternateBackgroundOn = "OFF"
                alternatebackgroundLabel!.text = "Alternate Background: \(alternateBackgroundOn)"
                
            }
            
            else if checkAlternateBackgroundOn == false {
                
                checkAlternateBackgroundOn = true
                alternateBackgroundOn = "ON"
                alternatebackgroundLabel!.text = "Alternate Background: \(alternateBackgroundOn)"
                
            }
            
        }
        
        // runs of the user pressed the profile
        if touchedNode.name == "profileNode" {
            
            profileEditDisplayed = true
            
            circle.removeAllActions()
            circle.removeFromParent()
            
            profileNode!.removeFromParent()
            playerNameNode!.removeFromParent()
            playerLevelNode!.removeFromParent()
            
            profileOptionDisplayNode = SKSpriteNode(color: .black, size: CGSize(width: 800, height: 422))
            profileOptionDisplayNode!.position = CGPoint(x: 0, y: 0)
            profileOptionDisplayNode!.zPosition = 12
            profileOptionDisplayNode!.name = "optionDispay"
            profileOptionDisplayNode!.alpha = 0.6
            addChild(profileOptionDisplayNode!)
            
            editProfileName = SKSpriteNode(color: UIColor(red: 134/255, green: 182/255, blue: 48/255, alpha: 1), size: CGSize(width: 300, height: 50))
            editProfileName!.position = CGPoint(x: 0, y: 80)
            editProfileName!.name = "editProfileName"
            editProfileName!.zPosition = 13
            addChild(editProfileName!)
            
            let editProfileNameLabel = SKLabelNode(text: "Edit Profile Name")
            editProfileNameLabel.zPosition = 13
            editProfileNameLabel.position = CGPoint(x: 0, y: -6)
            editProfileNameLabel.fontName = "Arial Bold"
            editProfileNameLabel.fontSize = 20
            editProfileNameLabel.fontColor = SKColor.white
            editProfileNameLabel.name = "editProfileNameLabel"
            editProfileName!.addChild(editProfileNameLabel)
            
            resetProgress = SKSpriteNode(color: UIColor(red: 223/255, green: 49/255, blue: 24/255, alpha: 1), size: CGSize(width: 300, height: 50))
            resetProgress!.position = CGPoint(x: 0, y: 0)
            resetProgress!.name = "resetProgress"
            resetProgress!.zPosition = 13
            addChild(resetProgress!)
            
            let resetProgressLabel = SKLabelNode(text: "Reset Progress")
            resetProgressLabel.zPosition = 13
            resetProgressLabel.position = CGPoint(x: 0, y: -6)
            resetProgressLabel.fontName = "Arial Bold"
            resetProgressLabel.fontSize = 20
            resetProgressLabel.fontColor = SKColor.white
            resetProgressLabel.name = "resetProgressLabel"
            resetProgress!.addChild(resetProgressLabel)
            
            exitProfileOptions = SKSpriteNode(color: UIColor(red: 186/255, green: 107/255, blue: 192/255, alpha: 1), size: CGSize(width: 300, height: 50))
            exitProfileOptions!.position = CGPoint(x: 0, y: -80)
            exitProfileOptions!.zPosition = 13
            exitProfileOptions!.name = "exitProfileOptions"
            addChild(exitProfileOptions!)
            
            let exitProfileOptionsLabel = SKLabelNode(text: "Exit")
            exitProfileOptionsLabel.zPosition = 13
            exitProfileOptionsLabel.position = CGPoint(x: 0, y: -6)
            exitProfileOptionsLabel.fontName = "Arial Bold"
            exitProfileOptionsLabel.fontSize = 20
            exitProfileOptionsLabel.fontColor = SKColor.white
            exitProfileOptionsLabel.name = "exitProfileOptionsLabel"
            exitProfileOptions!.addChild(exitProfileOptionsLabel)
            
        }
        
        if touchedNode.name == "resetProgressLabel" || touchedNode.name == "resetProgress" {
            
            
            userDefaults.set(0, forKey: "levelOneHighscore")
            userDefaults.set(0, forKey: "levelTwoHighscore")
            userDefaults.set(0, forKey: "levelThreeHighscore")
            
            playerName = "Guest"
            
            playerNameNode = SKLabelNode(text: "\(playerName)")
            playerNameNode!.fontName = "Arial Bold"
            playerNameNode!.position = CGPoint(x: -300, y: 192)
            playerNameNode!.fontSize = 12
            playerNameNode!.fontColor = SKColor.white
            playerNameNode!.name = "playerName"
            playerNameNode!.alpha = 1
            playerNameNode!.zPosition = 999999999999
            
            profileOptionDisplayNode!.removeFromParent()
            
            editProfileName!.removeFromParent()
            resetProgress!.removeFromParent()
            exitProfileOptions!.removeFromParent()
            
            // re adds circle node
            addChild(circle)
            
            circle.setScale(1)
            
            let pulseUp = SKAction.scale(to: 1.11, duration: 0.25)
            let pulseDown = SKAction.scale(to: 1.0, duration: 0.25)
            let pulse = SKAction.sequence([pulseDown, pulseUp])
            let repeatPulse = SKAction.repeatForever(pulse)
            circle.run(SKAction.sequence([repeatPulse]))
            
            //re adds the profile nodes
            addChild(profileNode!)
            addChild(playerNameNode!)
            addChild(playerLevelNode!)
            
            
        }
        if touchedNode.name == "editProfileName" || touchedNode.name == "editProfileNameLabel" {
            
            playerName = "Matthew Purcell"
            
            playerNameNode = SKLabelNode(text: "\(playerName)")
            playerNameNode!.fontName = "Arial Bold"
            playerNameNode!.position = CGPoint(x: -270, y: 192)
            playerNameNode!.fontSize = 12
            playerNameNode!.fontColor = SKColor.white
            playerNameNode!.name = "playerName"
            playerNameNode!.alpha = 1
            playerNameNode!.zPosition = 999999999999

            
            userDefaults.set(999999999999, forKey: "levelOneHighscore")
            userDefaults.set(999999999999, forKey: "levelTwoHighscore")
            userDefaults.set(999999999999, forKey: "levelThreeHighscore")
            
            profileOptionDisplayNode!.removeFromParent()
            
            editProfileName!.removeFromParent()
            resetProgress!.removeFromParent()
            exitProfileOptions!.removeFromParent()
            
            // re adds circle node
            addChild(circle)
            
            circle.setScale(1)
            
            let pulseUp = SKAction.scale(to: 1.11, duration: 0.25)
            let pulseDown = SKAction.scale(to: 1.0, duration: 0.25)
            let pulse = SKAction.sequence([pulseDown, pulseUp])
            let repeatPulse = SKAction.repeatForever(pulse)
            circle.run(SKAction.sequence([repeatPulse]))
            
            //re adds the profile nodes
            addChild(profileNode!)
            addChild(playerNameNode!)
            addChild(playerLevelNode!)
            
    
        }
        
        // exits out of profile options
        if touchedNode.name == "exitProfileOptions" || touchedNode.name == "exitProfileOptionsLabel" {
            
            profileOptionDisplayNode!.removeFromParent()
            
            editProfileName!.removeFromParent()
            resetProgress!.removeFromParent()
            exitProfileOptions!.removeFromParent()
            
            // re adds circle node
            addChild(circle)
            
            circle.setScale(1)
            
            let pulseUp = SKAction.scale(to: 1.11, duration: 0.25)
            let pulseDown = SKAction.scale(to: 1.0, duration: 0.25)
            let pulse = SKAction.sequence([pulseDown, pulseUp])
            let repeatPulse = SKAction.repeatForever(pulse)
            circle.run(SKAction.sequence([repeatPulse]))
            
            //re adds the profile nodes
            addChild(profileNode!)
            addChild(playerNameNode!)
            addChild(playerLevelNode!)
            
        }
        
        // resets the circle when taps the background
        if menuAdded == true && touchedNode.name != "circle" && touchedNode.name != "playGame" && touchedNode.name != "augmentedGame" && touchedNode.name != "exitGame" && touchedNode.name != "optionButton" && touchedNode.name != "playGameText" && touchedNode.name != "augmentedGametext" && touchedNode.name != "exitGameText" && touchedNode.name != "optionButtonText" && touchedNode.name != "playSingleGame" && touchedNode.name != "playMultiGame" && touchedNode.name != "playSingleText" && touchedNode.name != "playMultiText" {
            
            menuAdded = false
            deleteMenu = true
            
            let pulseUp = SKAction.scale(to: 1.11, duration: 0.25)
            let pulseDown = SKAction.scale(to: 1.0, duration: 0.25)
            let pulse = SKAction.sequence([pulseDown, pulseUp])
            let repeatPulse = SKAction.repeatForever(pulse)
            circle.run(SKAction.sequence([repeatPulse]))
            
            if playButtonTapped == true {
                
                playSingleplayer!.removeFromParent()
                playMultiplayer!.removeFromParent()
                playButtonTapped = false
                
            }
            
        }
        
    }
    
    
    //---------------------------------------------------------------------------------------------------------------------------------------
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first!
        let touchLocation = touch.location(in: self)
        let touchedNode = atPoint(touchLocation)
        
//        let emitter = SKEmitterNode(fileNamed: "userTouchTrail")
//        emitter!.position = touchLocation
//        emitter!.zPosition = 100
//        addChild(emitter!)
//
//        let emitterDelayAction = SKAction.wait(forDuration: 2.0)
//        let emitterFadeAction = SKAction.fadeOut(withDuration: 1.0)
//        let emitterRemoveAction = SKAction.removeFromParent()
//
//        let emitterDisapperanceActions = [emitterDelayAction, emitterFadeAction, emitterRemoveAction]
//
//        emitter!.run(SKAction.sequence(emitterDisapperanceActions))
        
        if touchedNode.name == "circle" {
            
            circle.removeAllActions()
            circle.setScale(1.1)
            
            circleClicked = true
            
            let circleExpand = SKAction.scale(by: 1.1, duration: 0.1)
            
            if circleExpanded == false {
                
                circleExpanded = true
                circle.run(circleExpand, withKey: "userTouchedCircle")
                
            }

        }
        
        if touchedNode.name != "circle" && menuAdded == false {
            
            circle.setScale(1)
            
            let pulseUp = SKAction.scale(to: 1.11, duration: 0.25)
            let pulseDown = SKAction.scale(to: 1.0, duration: 0.25)
            let pulse = SKAction.sequence([pulseDown, pulseUp])
            let repeatPulse = SKAction.repeatForever(pulse)
            circle.run(SKAction.sequence([repeatPulse]))
            
        }
        
        if touchedNode.name != "circle" {
            circleClicked = false
        }
        
    }
    
    
    //--------------------------------------------------------------------------------------------------------------------------------------------
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if circleClicked == true && circleExpanded == true {
            
            circleExpanded = false
            circle.setScale(1)
            circle.removeAllActions()
            
        }
        
        if menuAdded == false && circleClicked == true {
            
            playGameNode = SKSpriteNode(color: UIColor(red: 101/255, green: 78/255, blue: 173/255, alpha: 1), size: CGSize(width: 240, height: 40))
            playGameNode!.position = CGPoint(x: 190, y: 75)
            playGameNode!.name = "playGame"
            playGameNode!.zPosition = 10
            playGameNode!.alpha = 0.9
            
            let labelNode1 = SKLabelNode(text: "Play Game")
            labelNode1.fontName = "Arial Bold"
            labelNode1.fontSize = 21
            labelNode1.fontColor = SKColor.white
            labelNode1.name = "playGameText"
            labelNode1.position = CGPoint(x: 0, y: -7)
            
            arNode = SKSpriteNode(color: UIColor(red: 101/255, green: 78/255, blue: 173/255, alpha: 1), size: CGSize(width: 240, height: 40))
            arNode!.position = CGPoint(x: 200, y: 25)
            arNode!.name = "augmentedGame"
            arNode!.zPosition = 10
            arNode!.alpha = 0.9
            
            let labelNode2 = SKLabelNode(text: "AR Version")
            labelNode2.fontName = "Arial Bold"
            labelNode2.fontSize = 21
            labelNode2.fontColor = SKColor.white
            labelNode2.name = "augmentedGametext"
            labelNode2.position = CGPoint(x: 0, y: -7)
            
            exitNode = SKSpriteNode(color: UIColor(red: 101/255, green: 78/255, blue: 173/255, alpha: 1), size: CGSize(width: 240, height: 40))
            exitNode!.position = CGPoint(x: 190, y: -75)
            exitNode!.name = "exitGame"
            exitNode!.zPosition = 10
            exitNode!.alpha = 0.9
            
            let labelNode3 = SKLabelNode(text: "Exit Game")
            labelNode3.fontName = "Arial Bold"
            labelNode3.fontSize = 21
            labelNode3.fontColor = SKColor.white
            labelNode3.name = "exitGameText"
            labelNode3.position = CGPoint(x: 0, y: -7)
            
            optionNode = SKSpriteNode(color: UIColor(red: 101/255, green: 78/255, blue: 173/255, alpha: 1), size: CGSize(width: 240, height: 40))
            optionNode!.position = CGPoint(x: 200, y: -25)
            optionNode!.name = "optionButton"
            optionNode!.zPosition = 10
            optionNode!.alpha = 0.9
            
            let labelNode4 = SKLabelNode(text: "Options")
            labelNode4.fontName = "Arial Bold"
            labelNode4.fontSize = 21
            labelNode4.fontColor = SKColor.white
            labelNode4.name = "optionButtonText"
            labelNode4.position = CGPoint(x: 0, y: -7)
            
            playGameNode!.addChild(labelNode1)
            arNode!.addChild(labelNode2)
            exitNode!.addChild(labelNode3)
            optionNode!.addChild(labelNode4)
            
            addChild(playGameNode!)
            addChild(arNode!)
            addChild(exitNode!)
            addChild(optionNode!)
            
            backgroundDampen!.alpha = 0.3
            
            topBarLayout!.alpha = 0.8
            bottomBarLayout!.alpha = 0.8
            
            menuAdded = true
            
        }
        
        if deleteMenu == true {
            
            backgroundDampen!.alpha = 0.0
            
            topBarLayout!.alpha = 0.6
            bottomBarLayout!.alpha = 0.6
            
            for child in (scene?.children)! {
                
                if child.name == "playGame" || child.name == "augmentedGame" || child.name == "exitGame" || child.name == "optionButton" {
                    child.removeFromParent()
                }
                
            }
            deleteMenu = false
        }
        circleClicked = false
    }
    
    
//-------------------------------------------------------------------------------------------------------------------------------------------
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
