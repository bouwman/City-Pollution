//
//  PollutionComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 12/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class PollutionComponent: GKComponent {
    let levelManager: LevelManager
    
    init(levelManager: LevelManager) {
        self.levelManager = levelManager
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addToPollution(input: Double) {
        levelManager.cityPollution += input
        // TODO: Add delegate to inform about max pollution reached = game over
    }
}
