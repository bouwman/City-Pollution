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
    
    init(node: SKNode, movePoints: [CGPoint]) {
        self.movePoints = movePoints
        
        super.init()
        
        let render = GKSKNodeComponent(node: node)
        let collision = CollisionComponent(node: node, category: Const.Physics.Category.cars, pinned: false, collideWith: Const.Physics.Collision.cars)
        let movement = createMovementComponentWith(movePoints: movePoints)
        
        movement.delegate = render
        
        addComponent(collision)
        addComponent(render)
        addComponent(movement)
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
        return InfiniteMovementComponent(movePoints: movePoints, maxSpeed: 40, maxAcceleration: 40, maxPredictionTime: 1.0, radius: 0)
    }
}
