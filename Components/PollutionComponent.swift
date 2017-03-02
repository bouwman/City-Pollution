//
//  PollutionComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 12/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class PollutionComponent: GKComponent {
    let player: Player
    
    init(player: Player) {
        self.player = player
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addToPollution(input: Double) {
        player.cityPollution += input
        // TODO: Add delegate to inform about max pollution reached = game over
    }
}

class Player {
    var cityPollution: Double = 0
    var money: Int = 0
    
    var cityPollutionMax: Double
    
    init(cityPollutionMax: Double) {
        self.cityPollutionMax = cityPollutionMax
    }
}
