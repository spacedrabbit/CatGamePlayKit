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
  case team1 = 1
  case team2 = 2
  
  static let allValues = [team1, team2]
  
  func oppositeTeam() -> Team {
    switch self {
    case .team1:
      return .team2
    case .team2:
      return .team1
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
