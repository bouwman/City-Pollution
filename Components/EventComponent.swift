//
//  EventComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 09/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

enum GameEvent {
    case earnMoney(Double)
    case looseMoney(Double)
    case citizenDied(Double)
    case reachHealth(HealthLevel)
    case upgrade(Double)
}

class EventComponent: GKComponent {
    var scene: SKScene
    var nextEventToTrigger: GameEvent?
    
    init(scene: SKScene) {
        self.scene = scene
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let event = nextEventToTrigger else { return }
        
        switch event {
        case .earnMoney(let money):
            break
        case .looseMoney(let money):
            break
        case .citizenDied(let money):
            break
        case .reachHealth(let healthLevel):
            break
        case .upgrade(let money):
            break
        }

    }
}
