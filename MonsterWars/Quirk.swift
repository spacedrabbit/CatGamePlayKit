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

/** 
 `associatedtype` allows for classes implementing this protocol to define the type it will be using.
 This is necessary in the case where a protocol's implementation intends on using its
 conforming class's .Type as either a parameter type or return value.
 In this case, the `associatedtype`, `MonsterType` is returned on `spawn(team:entityManager:)`. I also
 ensure that this `associatedtype` is of type `GKEntity` or a subclass
*/
internal protocol Spawn: class {
  associatedtype MonsterType: GKEntity
  // these are made to be static as they are intended to be used on class types, not an instance of one
  static var spawnCost: Int { get }
  static func spawn(_ team: Team, entityManager: EntityManager) -> MonsterType
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
  
  static func spawn(_ team: Team, entityManager: EntityManager) -> MonsterType {
    return Quirk(team: team, entityManager: entityManager)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not implemented")
  }
}
