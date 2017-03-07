//
//  PollutionEntity.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 12/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class PollutionEntity: GKEntity {
    var pollutionComponent: PollutionComponent {
        return component(ofType: PollutionComponent.self)!
    }
    
    init(levelManager: LevelManager, node: SKNode) {
        super.init()
        
        let render = GKSKNodeComponent(node: node)
        let pollution = PollutionComponent(levelManager: levelManager)
        
        addComponent(render)
        addComponent(pollution)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
