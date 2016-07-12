//
//  TeamComponent.swift
//  MonsterWars
//
//  Created by Louis Tur on 7/12/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

enum Team: Int {
  case Team1 = 1
  case Team2 = 2
  
  static let allValues = [Team1, Team2]
  
  func oppositeTeam() -> Team {
    switch self {
    case .Team1:
      return .Team2
    case .Team2:
      return .Team1
    }
  }
}

class TeamComponent: GKComponent {
  let team: Team
  
  init(team: Team) {
    self.team = team
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
