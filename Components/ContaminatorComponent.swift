//
//  ContaminatorComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 12/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class ContaminatorComponent: GKComponent {
    var input: Double
    var factor: Double = 1.0
    
    init(input: Double) {
        self.input = input
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if let pollutionComponent = entity?.component(ofType: PollutionComponent.self) {
            pollutionComponent.addToPollution(input: input * factor)
        }
        
        if let node = entity?.component(ofType: GKSKNodeComponent.self)?.node {
            if let emitter = node.childNode(withName: Const.Nodes.contaminatorEmitter) as? SKEmitterNode {
                if factor > 0.5 {
                    emitter.particleColorBlendFactor = factor < 0.8 ? 0.0 : 1.0
                } else {
                    emitter.removeFromParent()
                }
            }
        }
    }
}
