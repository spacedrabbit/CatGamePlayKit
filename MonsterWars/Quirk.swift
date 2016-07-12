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

class Quirk: GKEntity {
  
  init(team: Team) {
    super.init()
    let texture = SKTexture(imageNamed: "quirk\(team.rawValue)")
    let spriteComponent = SpriteComponent(texture: texture)
    addComponent(spriteComponent)
    addComponent(TeamComponent(team: team))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) is not implemented")
  }
}
