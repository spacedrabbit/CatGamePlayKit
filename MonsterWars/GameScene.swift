//
//  GameScene.swift
//  MonsterWars
//
//  Created by Main Account on 11/3/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
  let margin = CGFloat(30)

  var quirkButton: ButtonNode!
  var zapButton: ButtonNode!
  var munchButton: ButtonNode!
  let coin1Label = SKLabelNode(fontNamed: "Courier-Bold")
  let coin2Label = SKLabelNode(fontNamed: "Courier-Bold")
  
  var lastUpdateTimeInterval: TimeInterval = 0
  var gameOver = false
  var entityManager: EntityManager!
  
  override func didMove(to view: SKView) {
    startBackgroundMusic()
    addBackground()
    addEntityButtons()
    addCoinLables()

    entityManager = EntityManager(scene: self)
    addCastleEntities(to: entityManager)
  }
  
  
  // MARK: - Setup
  func startBackgroundMusic() {
    // Start background music
    let bgMusic = SKAudioNode(fileNamed: "Latin_Industries.mp3")
    bgMusic.autoplayLooped = true
    addChild(bgMusic)
  }
  
  func addBackground() {
    // Add background
    let background = SKSpriteNode(imageNamed: "background")
    background.position = CGPoint(x: size.width/2, y: size.height/2)
    background.zPosition = -1
    addChild(background)
  }
  
  func addEntityButtons() {
    // Add quirk button
    quirkButton = ButtonNode(iconName: "quirk1", text: "10", onButtonPress: quirkPressed)
    quirkButton.position = CGPoint(x: size.width * 0.25, y: margin + quirkButton.size.height / 2)
    addChild(quirkButton)
    
    // Add zap button
    zapButton = ButtonNode(iconName: "zap1", text: "25", onButtonPress: zapPressed)
    zapButton.position = CGPoint(x: size.width * 0.5, y: margin + zapButton.size.height / 2)
    addChild(zapButton)
    
    // Add munch button
    munchButton = ButtonNode(iconName: "munch1", text: "50", onButtonPress: munchPressed)
    munchButton.position = CGPoint(x: size.width * 0.75, y: margin + munchButton.size.height / 2)
    addChild(munchButton)
  }
  
  func addCoinLables() {
    // Add coin 1 indicator
    let coin1 = SKSpriteNode(imageNamed: "coin")
    coin1.position = CGPoint(x: margin + coin1.size.width/2, y: size.height - margin - coin1.size.height/2)
    addChild(coin1)
    coin1Label.fontSize = 50
    coin1Label.fontColor = SKColor.black()
    coin1Label.position = CGPoint(x: coin1.position.x + coin1.size.width/2 + margin, y: coin1.position.y)
    coin1Label.zPosition = 1
    coin1Label.horizontalAlignmentMode = .left
    coin1Label.verticalAlignmentMode = .center
    coin1Label.text = "10"
    self.addChild(coin1Label)
    
    // Add coin 2 indicator
    let coin2 = SKSpriteNode(imageNamed: "coin")
    coin2.position = CGPoint(x: size.width - margin - coin1.size.width/2, y: size.height - margin - coin1.size.height/2)
    addChild(coin2)
    coin2Label.fontSize = 50
    coin2Label.fontColor = SKColor.black()
    coin2Label.position = CGPoint(x: coin2.position.x - coin2.size.width/2 - margin, y: coin1.position.y)
    coin2Label.zPosition = 1
    coin2Label.horizontalAlignmentMode = .right
    coin2Label.verticalAlignmentMode = .center
    coin2Label.text = "10"
    self.addChild(coin2Label)
  }
  
  
  // MARK: - Entity Management
  func addCastleEntities(to manager: EntityManager) {
    let humanCastle: Castle = Castle(imageName: "castle1_atk", team: .Team1, entityManager: entityManager)
    if let spriteComponent: SpriteComponent = humanCastle.componentForClass(SpriteComponent.self) {
      spriteComponent.node.position = CGPoint(x: spriteComponent.node.size.width/2, y: size.height/2)
    }
    manager.add(entity: humanCastle)
    
    let aiCastle: Castle = Castle(imageName: "castle2_atk", team: .Team2, entityManager: entityManager)
    if let spriteComponent: SpriteComponent = aiCastle.componentForClass(SpriteComponent.self) {
      spriteComponent.node.position = CGPoint(x: size.width - spriteComponent.node.size.width/2, y: size.height/2)
    }
    manager.add(entity: aiCastle)
  }
  
  
  // MARK: - Button Closures
  func quirkPressed() {
    entityManager.spawnQuirk(team: .Team1)
  }
  
  func zapPressed() {
    print("Zap pressed!")
    entityManager.spawnZap(team: .Team1)
  }
  
  func munchPressed() {
    print("Munch pressed!")
  }
  
  
  // MARK: - Touches Override
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    let touchLocation = touch.location(in: self)
    print("\(touchLocation)")
    
    if gameOver {
      let newScene = GameScene(size: size)
      newScene.scaleMode = scaleMode
      view?.presentScene(newScene, transition: SKTransition.flipHorizontal(withDuration: 0.5))
      return
    }
    
  }
  
  
  // MARK: - Restart Menu
  func showRestartMenu(_ won: Bool) {
    
    if gameOver { return }
    gameOver = true
    
    let message = won ? "You win" : "You lose"
    
    let label = SKLabelNode(fontNamed: "Courier-Bold")
    label.fontSize = 100
    label.fontColor = SKColor.black()
    label.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
    label.zPosition = 1
    label.verticalAlignmentMode = .center
    label.text = message
    label.setScale(0)
    addChild(label)
    
    let scaleAction = SKAction.scale(to: 1.0, duration: 0.5)
    scaleAction.timingMode = SKActionTimingMode.easeInEaseOut
    label.run(scaleAction)
    
  }
  
  
  // MARK: - Update
  override func update(_ currentTime: TimeInterval) {
    let deltaTime = currentTime - lastUpdateTimeInterval
    lastUpdateTimeInterval = currentTime
    
    if gameOver { return }
   
    entityManager.update(deltaTime: deltaTime)
    
    if let human = entityManager.castle(for: .Team1),
      humanCastle = human.componentForClass(CastleComponent.self) {
      coin1Label.text = "\(humanCastle.coins)"
    }
    
    if let ai = entityManager.castle(for: .Team2),
      aiCastle = ai.componentForClass(CastleComponent.self) {
      coin2Label.text = "\(aiCastle.coins)"
    }
  }
}
