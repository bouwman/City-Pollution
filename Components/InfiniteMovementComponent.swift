//
//  InfiniteMovementComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 01.03.17.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class InfiniteMovementComponent: GKAgent2D {
    let movePoints: [CGPoint]
    let maxPredictionTime: TimeInterval
    let originalSpeed: Float
    
    private let movePath: GKPath
    
    var renderComponent: GKSKNodeComponent {
        return entity!.component(ofType: GKSKNodeComponent.self)!
    }
    
    init(movePoints: [CGPoint], maxSpeed: Float, maxAcceleration: Float, maxPredictionTime: TimeInterval, radius: Float) {
        self.movePoints = movePoints
        self.movePath = GKPath(points: movePoints.map { float2($0) }, radius: radius, cyclical: false)
        self.maxPredictionTime = maxPredictionTime
        self.originalSpeed = maxSpeed
        
        super.init()
        
        self.position = float2(0, 0)
        self.mass = 0.01
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard entity != nil else { return }
        
        let node = renderComponent.node
        
        if node.contains(movePoints.last!) {
            node.position = movePoints.first!
        }
        
        if let upgrade = entity?.component(ofType: UpgradeComponent.self) {
            self.maxSpeed = originalSpeed * Float(upgrade.currentUpgrade.factor)
        }
        
        self.behavior = PathBehaviour(path: movePath, maxPredictionTime: maxPredictionTime, targetSpeed: maxSpeed)
    }
}
