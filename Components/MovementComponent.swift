//
//  MovementComponent.swift
//  DrawToMoveExamplee
//
//  Created by Tassilo Bouwman on 09/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class MovementComponent: GKAgent2D {
    
    var renderComponent: GKSKNodeComponent {
        guard let renderComponent = entity?.component(ofType: GKSKNodeComponent.self) else { fatalError("A MovementComponent's entity must have a GKSKNodeComponent") }
        return renderComponent
    }
    
    var pathComponent: PathComponent {
        guard let pathComponent = entity?.component(ofType: PathComponent.self) else { fatalError("A MovementComponent's entity must have a PathComponent") }
        return pathComponent
    }
    
    var maxPredictionTime: TimeInterval
    var obstacles: [GKObstacle]
    var wanderPoint = float2(0, 0)
    private var savedPath: GKPath?
    private var lastPointOld = CGPoint.zero
    
    init(maxSpeed: Float, maxAcceleration: Float, maxPredictionTime: TimeInterval, radius: Float, obstacles: [GKObstacle], wanderPoint: float2) {
        self.maxPredictionTime = maxPredictionTime
        self.obstacles = obstacles
        self.wanderPoint = wanderPoint
        
        super.init()
        
        self.position = float2(0, 0)
        self.mass = 0.01
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        let path = pathComponent.wayPoints
        
        if let lastPoint = path.last {
            self.wanderPoint = float2(lastPoint)
        }
        
        if path.count > 1 {
            let lastPoint = path.last!
            let movePath: GKPath
            if lastPoint == lastPointOld, let savedPath = self.savedPath {
                movePath = savedPath
            } else {
                let points = path.map { float2($0) }
                movePath = GKPath(points: points, radius: 1.0, cyclical: false)
                savedPath = movePath
                lastPointOld = lastPoint
            }
            self.behavior = PathBehaviour(path: movePath, maxPredictionTime: maxPredictionTime, targetSpeed: maxSpeed, obstacles: obstacles)
        } else {
            self.behavior = WanderBehavior(aroundPoint: wanderPoint, maxPredictionTime: maxPredictionTime, targetSpeed: maxSpeed, obstacles: obstacles)
        }
        
        for point in pathComponent.wayPoints {
            if renderComponent.node.contains(point) {
                pathComponent.wayPoints.removeFirst()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PathBehaviour: GKBehavior {
    init(path: GKPath, maxPredictionTime: TimeInterval, targetSpeed: Float, obstacles: [GKObstacle] = [GKObstacle]()) {
        super.init()
        
        setWeight(1.0, for: GKGoal(toReachTargetSpeed: targetSpeed))
        setWeight(1.0, for: GKGoal(toFollow: path, maxPredictionTime: maxPredictionTime, forward: true))
        setWeight(1.0, for: GKGoal(toStayOn: path, maxPredictionTime: maxPredictionTime))
        
        if obstacles.count != 0 {
            setWeight(50.0, for: GKGoal(toAvoid: obstacles, maxPredictionTime: 10))
        }
    }
}

class WanderBehavior: GKBehavior {
    init(aroundPoint: float2, maxPredictionTime: TimeInterval, targetSpeed: Float, obstacles: [GKObstacle]) {
        super.init()
        
        setWeight(50.0, for: GKGoal(toAvoid: obstacles, maxPredictionTime: 60))
        
        let agent = GKAgent2D()
        agent.position = aroundPoint
        
        setWeight(0.01, for: GKGoal(toSeekAgent: agent))
        setWeight(0.3, for: GKGoal(toWander: targetSpeed))
    }
}

class StopBehavior: GKBehavior {
    override init() {
        super.init()
        setWeight(1.0, for: GKGoal(toReachTargetSpeed: 0.0))
    }
}
