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
    return [castleSystem]
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
  
  
  // MARK: - Spawn
  func spawnQuirk(team: Team) {

    guard let teamEntity = castle(for: team),
      teamCastleComponent = teamEntity.componentForClass(CastleComponent.self),
      teamSpriteComponent = teamEntity.componentForClass(SpriteComponent.self) else {
        return
    }
    
    if teamCastleComponent.coins < Cost.quirk { return }
    teamCastleComponent.coins -= Cost.quirk
    scene.run(SoundManager.sharedInstance.soundSpawn)
    
    let monster = Quirk(team: team)
    if let spriteComponent = monster.componentForClass(SpriteComponent.self) {
      spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
      spriteComponent.node.zPosition = 2
    }
    
    self.add(entity: monster)
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
        _ = entity.componentForClass(CastleComponent.self) {
        if teamComponent.team == team {
          return entity
        }
      }
    }
    return nil
  }
}
