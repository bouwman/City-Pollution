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
    
    init(levelManager: LevelManager, node: SKSpriteNode, pollutionInput: Double, upgrades: Upgrade...) {
        super.init()
        
        let render = GKSKNodeComponent(node: node)
        let collision = CollisionComponent(node: node, category: Const.Physics.Category.houses, pinned: true)
        let input = InputComponent()
        let contaminator = ContaminatorComponent(input: pollutionInput)
        let pollution = PollutionComponent(levelManager: levelManager)
        let upgrade = UpgradeComponent(levelManager: levelManager, upgrades: upgrades)
        let event = EventComponent(scene: levelManager.scene)
        
        addComponent(render)
        addComponent(collision)
        addComponent(input)
        addComponent(contaminator)
        addComponent(pollution)
        addComponent(upgrade)
        addComponent(event)
        
        let smoke = SKEmitterNode(fileNamed: "Smoke")!
        
        smoke.position.y = node.size.height / 2 + 5
        smoke.position.x = -6
        smoke.name = Const.Nodes.contaminatorEmitter
        node.addChild(smoke)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
