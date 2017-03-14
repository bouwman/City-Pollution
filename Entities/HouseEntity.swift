//
//  BuildingEntity.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 10/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit
import SpriteKit

class HouseEntity: GKEntity {
    var renderComponent: GKSKNodeComponent {
        return component(ofType: GKSKNodeComponent.self)!
    }
    
    var capacityComponent: CapacityComponent {
        return component(ofType: CapacityComponent.self)!
    }
    
    var node: HouseNode {
        return renderComponent.node as! HouseNode
    }
    
    init(levelManager: LevelManager, node: SKSpriteNode, maxCapacity: Int, pollutionInput: Double) {
        super.init()
                
        let render = GKSKNodeComponent(node: node)
        let collision = CollisionComponent(node: node, category: Const.Physics.Category.houses, pinned: true)
        let input = InputComponent()
        let capacity = CapacityComponent(maxCapacity: maxCapacity)
        let pollution = PollutionComponent(levelManager: levelManager)
        let contaminator = ContaminatorComponent(input: pollutionInput)
        let houseNode = render.node as! HouseNode
        let lights = LightComponent(maxLightCount: houseNode.windows.count, turnOnTimeRange: 11...20)
        
        addComponent(render)
        addComponent(collision)
        addComponent(input)
        addComponent(capacity)
        addComponent(pollution)
        addComponent(contaminator)
        addComponent(lights)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
