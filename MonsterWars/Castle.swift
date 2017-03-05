//
//  Castle.swift
//  MonsterWars
//
//  Created by Louis Tur on 7/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Castle: GKEntity, Spawn {
  typealias MonsterType = Castle
  static var spawnCost: Int = 0
  
  init(imageName: String, team: Team, entityManager: EntityManager) {
    super.init()
    let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
    addComponent(spriteComponent)
    addComponent(TeamComponent(team: team))
    addComponent(CastleComponent())
    addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(spriteComponent.node.size.width / 2), entityManager: entityManager))
  }
  
  static func spawn(_ team: Team, entityManager: EntityManager) -> MonsterType {
    var castleImageName: String
    switch team {
    case .team1: castleImageName = "castle1_atk"
    case .team2: castleImageName = "castle2_atk"
    }
    
    return Castle(imageName: castleImageName, team: team, entityManager: entityManager)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
