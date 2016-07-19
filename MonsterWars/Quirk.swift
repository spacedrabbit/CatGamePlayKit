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

internal protocol Spawn: class {
  associatedtype MonsterType: GKEntity
  static var spawnCost: Int { get }
  static func spawn(team: Team, entityManager: EntityManager) -> MonsterType
}

internal class Quirk: GKEntity, Spawn {
  typealias MonsterType = Quirk
  static var spawnCost: Int = 10
  
  internal required init(team: Team, entityManager: EntityManager) {
    super.init()
    let texture = SKTexture(imageNamed: "quirk\(team.rawValue)")
    addComponent(SpriteComponent(texture: texture))
    addComponent(TeamComponent(team: team))
    addComponent(MoveComponent(maxSpeed: 150, maxAcceleration: 5, radius: Float(texture.size().width * 0.3), entityManager: entityManager))
  }
  
  static func spawn(team: Team, entityManager: EntityManager) -> MonsterType {
    return Quirk(team: team, entityManager: entityManager)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not implemented")
  }
}
