//
//  MoveComponent.swift
//  MonsterWars
//
//  Created by Louis Tur on 7/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class MoveComponent : GKAgent2D, GKAgentDelegate {
  let entityManager: EntityManager
  
  init(maxSpeed: Float, maxAcceleration: Float, radius: Float, entityManager: EntityManager) {
    self.entityManager = entityManager
    super.init()
    delegate = self
    self.maxSpeed = maxSpeed
    self.maxAcceleration = maxAcceleration
    self.radius = radius
    print(self.mass)
    self.mass = 0.01
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) not implemented")
  }
  
  // calculates the closest move component for a particular team, used to find closest enemy
  func closestMoveComponent(for team: Team) -> GKAgent2D? {
    
    var closestMoveComponent: MoveComponent? = nil
    var closestDistance = CGFloat(0)
    
    let enemyMoveComponents = entityManager.moveComponents(for: team)
    for enemyMoveComponent in enemyMoveComponents {
      let distance = (CGPoint(enemyMoveComponent.position) - CGPoint(position)).length()
      if closestMoveComponent == nil || distance < closestDistance {
        closestMoveComponent = enemyMoveComponent
        closestDistance = distance
      }
    }
    return closestMoveComponent
    
  }
  

  // MARK: Update Override
  override func update(withDeltaTime: TimeInterval) {
    super.update(withDeltaTime: withDeltaTime)
    
    guard
      let entity = entity,
      let teamComponent = entity.componentForClass(TeamComponent.self)
    else { return }
    
    guard
      let enemyMoveComponent = closestMoveComponent(for: teamComponent.team.oppositeTeam())
    else { return }

    let alliedMoveComponents = entityManager.moveComponents(for: teamComponent.team)
    behavior = MoveBehavior(targetSpeed: maxSpeed, seek: enemyMoveComponent, avoid: alliedMoveComponents)
  }
  
  // MARK: - GKAgentDelegate
  private func agentWillUpdate(agent: GKAgent) {
    guard let spriteComponent = entity?.componentForClass(SpriteComponent.self) else {
      return
    }
    
    position = float2(spriteComponent.node.position)
  }
  
  private func agentDidUpdate(agent: GKAgent) {
    guard let spriteComponent = entity?.componentForClass(SpriteComponent.self) else {
      return
    }
    
    spriteComponent.node.position = CGPoint(position)
  }
}
