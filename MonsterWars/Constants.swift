//
//  Constants.swift
//  MonsterWars
//
//  Created by Main Account on 11/3/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation

internal struct Cost {
  static let quirk = 10
  static let zap = 25
  static let munch = 50
}

internal enum Monster {
  case quirk
  case zap
  case munch
  
  static func costForMonster(monster: Monster) -> Int {
    switch monster {
    case .quirk: return Cost.quirk
    case .zap: return Cost.zap
    case .munch: return Cost.munch
    }
  }
}
