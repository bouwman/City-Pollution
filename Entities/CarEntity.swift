//
//  CarEntity.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 01.03.17.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class CarEntity: GKEntity {
    init(node: SKNode, movePoints: [CGPoint]) {
        super.init()
        
        let render = GKSKNodeComponent(node: node)
        let collision = CollisionComponent(node: node, category: Const.Physics.Category.cars, pinned: false, collideWith: Const.Physics.Collision.cars)
        let movement = InfiniteMovementComponent(movePoints: movePoints, maxSpeed: 40, maxAcceleration: 40, maxPredictionTime: 1.0, radius: 0)
        
        movement.delegate = render
        
        addComponent(collision)
        addComponent(render)
        addComponent(movement)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
