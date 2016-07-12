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

class Castle: GKEntity {
  
  init(imageName: String) {
    super.init()
    let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
    addComponent(spriteComponent)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
