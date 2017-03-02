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
    
    var node: HouseNode {
        return renderComponent.node as! HouseNode
    }
    
    init(player: Player, node: SKNode, maxCapacity: Int) {
        super.init()
                
        let render = GKSKNodeComponent(node: node)
        let collision = CollisionComponent(node: node, category: Const.Physics.Category.houses, pinned: true)
        let input = InputComponent()
        let capacity = CapacityComponent(maxCapacity: maxCapacity)
        let pollution = PollutionComponent(player: player)
        let contaminator = ContaminatorComponent(input: 20)
        let houseNode = render.node as! HouseNode
        let lights = LightComponent(maxLightCount: houseNode.windows.count, turnOnTimeRange: 10...25)
        
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
