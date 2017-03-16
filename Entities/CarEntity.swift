//
//  CarEntity.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 01.03.17.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class CarEntity: GKEntity {
    var movePoints: [CGPoint]
    
    init(levelManager: LevelManager, node: SKSpriteNode, movePoints: [CGPoint], upgrades: Upgrade...) {
        self.movePoints = movePoints
        
        super.init()
        
        let render = GKSKNodeComponent(node: node)
        let collision = CollisionComponent(node: node, category: Const.Physics.Category.cars, pinned: false, collideWith: Const.Physics.Collision.cars)
        let pollution = PollutionComponent(levelManager: levelManager)
        let contaminator = ContaminatorComponent(input: levelManager.configuration.pollutionTransport)
        let input = InputComponent()
        let movement = createMovementComponentWith(movePoints: movePoints)
        let upgrade = UpgradeComponent(levelManager: levelManager, upgrades: upgrades)
        
        movement.delegate = render
        
        addComponent(collision)
        addComponent(render)
        addComponent(pollution)
        addComponent(contaminator)
        addComponent(input)
        addComponent(movement)
        addComponent(upgrade)
        
        let fumes = SKEmitterNode(fileNamed: "Fumes")!
        
        fumes.name = Const.Nodes.contaminatorEmitter
        fumes.position.x = -node.size.width / 2 - 5
        fumes.position.y = -node.size.height / 2 + 10
        node.addChild(fumes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func disableMovementComponent(_ disable: Bool) -> InfiniteMovementComponent {
        if disable {
            let component = self.component(ofType: InfiniteMovementComponent.self)!
            removeComponent(ofType: InfiniteMovementComponent.self)
            return component
        } else {
            let renderComponent = component(ofType: GKSKNodeComponent.self)!
            let newComponent = createMovementComponentWith(movePoints: movePoints)
            newComponent.delegate = renderComponent
            addComponent(newComponent)
            return newComponent
        }
    }
    
    private func createMovementComponentWith(movePoints: [CGPoint]) -> InfiniteMovementComponent {
        return InfiniteMovementComponent(movePoints: movePoints, maxSpeed: 50, maxAcceleration: 50, maxPredictionTime: 1.0, radius: 0)
    }
}
