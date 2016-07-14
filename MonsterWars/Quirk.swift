//
//  Quirk.swift
//  MonsterWars
//
//  Created by Louis Tur on 7/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

internal protocol MonsterSpawn: class {
  var monsterType: AnyObject {get set}
  func spawn<monsterType>(team: Team, entityManager: EntityManager) -> monsterType
}

internal class Quirk: GKEntity {
  var monsterType: AnyObject = Quirk.self
  
  internal init(team: Team, entityManager: EntityManager) {
    super.init()
    let texture = SKTexture(imageNamed: "quirk\(team.rawValue)")
    addComponent(SpriteComponent(texture: texture))
    addComponent(TeamComponent(team: team))
    addComponent(MoveComponent(maxSpeed: 150, maxAcceleration: 5, radius: Float(texture.size().width * 0.3), entityManager: entityManager))
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not implemented")
  }
}
