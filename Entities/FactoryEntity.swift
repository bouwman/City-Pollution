//
//  FactoryEntity.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 10/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class FactoryEntity: GKEntity {
    var renderComponent: GKSKNodeComponent {
        return component(ofType: GKSKNodeComponent.self)!
    }
    
    init(levelManager: LevelManager, node: SKNode, pollutionInput: Double, upgrades: Upgrade...) {
        super.init()
        
        let render = GKSKNodeComponent(node: node)
        let input = InputComponent()
        let contaminator = ContaminatorComponent(input: pollutionInput)
        let pollution = PollutionComponent(levelManager: levelManager)
        let upgrade = UpgradeComponent(levelManager: levelManager, upgrades: upgrades)
        let event = EventComponent(scene: levelManager.scene)
        
        addComponent(render)
        addComponent(input)
        addComponent(contaminator)
        addComponent(pollution)
        addComponent(upgrade)
        addComponent(event)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
