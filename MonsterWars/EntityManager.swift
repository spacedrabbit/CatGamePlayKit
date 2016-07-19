//
//  EntityManager.swift
//  MonsterWars
//
//  Created by Louis Tur on 7/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
  
  var entities = Set<GKEntity>()
  var toRemove = Set<GKEntity>()
  let scene: SKScene
  
  lazy var componentSystems: [GKComponentSystem] = {
    let castleSystem = GKComponentSystem(componentClass: CastleComponent.self)
    let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
    return [castleSystem, moveSystem]
  }()
  
  init(scene: SKScene) {
    self.scene = scene
  }
  
  
  // MARK: - Entity Management
  func add(entity: GKEntity) {
    entities.insert(entity)
    
    if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
      scene.addChild(spriteNode)
    }
    
    for componentSystem in self.componentSystems {
      componentSystem.addComponent(with: entity)
    }
  }
  
  func remove(entity: GKEntity) {
    if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
      spriteNode.removeFromParent()
    }
    
    entities.remove(entity)
    toRemove.insert(entity)
  }
  
  
  // MARK: - Update
  func update(deltaTime: CFTimeInterval) {
    for componentSystem in componentSystems {
      componentSystem.update(withDeltaTime: deltaTime)
    }
    
    for curRemove in toRemove {
      for componentSystem in componentSystems {
        componentSystem.removeComponent(with: curRemove)
      }
    }
    toRemove.removeAll()
  }
  
  
  // MARK: - Spawn Generically
  /*
   Problem: Previously, there were separate "spawn" methods for each monster type (Quirk, Zap, Munch) that each performed 
    the same code except for one statement: the instantiation of the particular monster class:
      -> Quirk(team:entityManager:)
      -> Zap(team:entityManager:)
      -> Munch(team:entityManager:)
   
   Goal: Consolidate code using a protocol-based approach
   Solution: The following implementation of EntityManger.spawn(monster:team:) accomplishes the stated goal.
   
   Explanation:
    - spawn<T: GKEntity where T: Spawn> specifies that in addition to being of type GKEntity, T will also conform
      to the Spawn protocol. This is specifically needed to be able to call the Spawn.Protocol-specific function, 
      spawn(team:entityManager)
    - monster: T.Type specifies to use our generic's Type as the accepted parameter type
    - .spawnCost and .spawn(team:entityManager:) are both statically defined in the Spawn protocol, allowing them to be called
      without the need of an instance of our T class.
  */
  func spawn<T: GKEntity where T: Spawn>(monster: T.Type, team: Team) {
    guard
      let teamEntity = castle(for: team),
      let teamCastleComponent = teamEntity.componentForClass(CastleComponent.self),
      let teamSpriteComponent = teamEntity.componentForClass(SpriteComponent.self)
    else { return }
    
    if teamCastleComponent.coins < monster.spawnCost { return }
    teamCastleComponent.coins -= monster.spawnCost
    scene.run(SoundManager.sharedInstance.soundSpawn)
    
    let newMonster = monster.spawn(team: team, entityManager: self)
    if let spriteComponent = newMonster.componentForClass(SpriteComponent.self) {
      spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
      spriteComponent.node.zPosition = 2
    }
    
    self.add(entity: newMonster)
  }
  
  
  // MARK: - Entity Locating Helpers
  func entities(for team: Team) -> [GKEntity] {
    return entities.flatMap{ entity in
      if let teamComponent = entity.componentForClass(TeamComponent.self) {
        if teamComponent.team == team {
          return entity
        }
      }
      return nil
    }
  }
  
  func moveComponents(for team: Team) -> [MoveComponent] {
    let entities = self.entities(for: team)
    var moveComponents = [MoveComponent]()
    for entity in entities {
      if let moveComponent = entity.componentForClass(MoveComponent.self) {
        moveComponents.append(moveComponent)
      }
    }
    return moveComponents
  }
  
  
  // MARK: - Helpers
  func castle(for team: Team) -> GKEntity? {
    for entity in entities {
      if let teamComponent = entity.componentForClass(TeamComponent.self),
       let _ = entity.componentForClass(CastleComponent.self) {
        if teamComponent.team == team {
          return entity
        }
      }
    }
    return nil
  }
}
