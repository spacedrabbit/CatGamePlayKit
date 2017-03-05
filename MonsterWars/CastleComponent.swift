//
//  CastleComponent.swift
//  MonsterWars
//
//  Created by Louis Tur on 7/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class CastleComponent: GKComponent {
  var coins = 0
  var lastCoinDrop = TimeInterval(0)
  
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) not implemented")
  }
  
  override func update(deltaTime seconds: TimeInterval) {
    super.update(deltaTime: seconds)
    let coinDropInterval = TimeInterval(0.5)
    let coinsPerInterval = 10
    if (CACurrentMediaTime() - lastCoinDrop > coinDropInterval) {
      lastCoinDrop = CACurrentMediaTime()
      coins += coinsPerInterval
    }
  }
  
}
