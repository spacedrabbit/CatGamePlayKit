//
//  Zap.swift
//  MonsterWars
//
//  Created by Louis Tur on 7/14/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

internal class Zap: GKEntity, Spawn {
  typealias MonsterType = Zap
  static var spawnCost: Int = 25
  
  init(team: Team, entityManager: EntityManager) {
    super.init()
    addComponent(TeamComponent(team: team))
    let spriteTextureName: String = team == .team1 ? "zap1" : "zap2"
    let zapSprite: SKTexture = SKTexture(imageNamed: spriteTextureName)
    addComponent(SpriteComponent(texture: zapSprite))
    addComponent(MoveComponent(maxSpeed: 100, maxAcceleration: 10, radius: Float(zapSprite.size().width * 0.3), entityManager: entityManager))
  }
  
  static func spawn(_ team: Team, entityManager: EntityManager) -> MonsterType {
    return Zap(team: team, entityManager: entityManager)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) not implemented")
  }
}
