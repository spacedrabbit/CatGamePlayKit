//
//  Munch.swift
//  MonsterWars
//
//  Created by Louis Tur on 7/14/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

internal class Munch: GKEntity, Spawn {
  typealias MonsterType = Munch
  static var spawnCost: Int = 50
  
  init(team: Team, entityManager: EntityManager) {
    super.init()
    
    let spriteTextureName: String = team == .team1 ? "munch1" : "munch2"
    let spriteTexture: SKTexture = SKTexture(imageNamed: spriteTextureName)
    
    addComponent(SpriteComponent(texture: spriteTexture))
    addComponent(TeamComponent(team: team))
    addComponent(MoveComponent(maxSpeed: 75, maxAcceleration: 8, radius: Float(spriteTexture.size().width * 0.3), entityManager: entityManager))
  }
  
  static func spawn(_ team: Team, entityManager: EntityManager) -> MonsterType {
    return Munch(team: team, entityManager: entityManager)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) not implemented")
  }
  
}
