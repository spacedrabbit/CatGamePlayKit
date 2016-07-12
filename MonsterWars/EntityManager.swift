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
  let scene: SKScene

  init(scene: SKScene) {
    self.scene = scene
  }

  func add(entity: GKEntity) {
    entities.insert(entity)
    
    if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
      scene.addChild(spriteNode)
    }
  }
  
  func remove(entity: GKEntity) {
    if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
      spriteNode.removeFromParent()
    }
    
    entities.remove(entity)
  }
}
