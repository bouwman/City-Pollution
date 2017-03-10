//
//  CitizenEntity.swift
//  DrawToMoveExamplee
//
//  Created by Tassilo Bouwman on 08/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

enum CitizenType {
    case normal, child, old, asthma
    
    var decreaseFactor: Double {
        switch self {
        case .normal:
            return Const.Citizens.TypesFactors.normal
        case .child:
            return Const.Citizens.TypesFactors.child
        case .old:
            return Const.Citizens.TypesFactors.old
        case .asthma:
            return Const.Citizens.TypesFactors.asthma
        }
    }
    
    var increaseFactor: Double {
        // TODO: Increase depending on decrease factor
        return Const.Citizens.increaseFactorFine
    }
}

protocol CitizenEntityDelegate {
    func citizenEnitityDidArriveAtDestination(citizen: CitizenEntity)
    func citizenEnitityDidDie(citizen: CitizenEntity)
}

class CitizenEntity: GKEntity, DestinationComponentDelegate, HealthComponentDelegate {
    var delegate: CitizenEntityDelegate?
    let levelManager: LevelManager
    
    var renderComponent: GKSKNodeComponent {
        return component(ofType: GKSKNodeComponent.self)!
    }
    
    lazy var sprite: CitizenNode = {
        let sprite = CitizenNode(imageNamed: "citizen yellow")
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.height / 2)
        sprite.xScale = 0.2
        sprite.yScale = 0.2
        
        return sprite
    }()
    
    init(type: CitizenType, levelManager: LevelManager, possibleDestinations: [GKEntity], obstacles: [GKEntity]) {
        self.levelManager = levelManager
        
        super.init()
        
        self.obstacles = obstacles
        
        let path = PathComponent()
        let render = GKSKNodeComponent(node: sprite)
        let collision = CollisionComponent(node: sprite, category: Const.Physics.Category.citizens, pinned: false)
        let drawPath = DrawPathComponent()
        let input = InputComponent()
        let destination = DestinationComponent(possibleDestinations: possibleDestinations)
        let movement = createMovementComponentWith(renderComponent: render)
        let pollution = PollutionComponent(levelManager: levelManager)
        let health = HealthComponent(maxHealth: Const.Citizens.maxHealth, decreaseFactor: type.decreaseFactor, startHealthPercent: Const.Citizens.startHealthPercent, increaseFactor: type.increaseFactor * Const.Citizens.increaseFactor)
        
        movement.delegate = render
        destination.delegate = self
        health.delegate = self
        
        addComponent(path)
        addComponent(render)
        addComponent(collision)
        addComponent(drawPath)
        addComponent(input)
        addComponent(destination)
        addComponent(movement)
        addComponent(pollution)
        addComponent(health)
    }
    
    private func obstaclesFor(entities: [GKEntity]) -> [GKPolygonObstacle] {
        var obstacles = [GKPolygonObstacle]()
        
        for entity in entities {
            guard let entityNode = entity.component(ofType: GKSKNodeComponent.self)?.node else { fatalError("An obstacle must have a GKSKNodeComponent") }
            
            let newObstacles: [GKPolygonObstacle]
            
            if entityNode.physicsBody != nil {
                newObstacles = SKNode.obstacles(fromNodePhysicsBodies: [entityNode])
            } else {
                newObstacles = SKNode.obstacles(fromNodeBounds: [entityNode])
            }
            obstacles.append(contentsOf: newObstacles)
        }
        
        return obstacles
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var obstacles: [GKEntity]!
    
    func disableMovementComponent(_ disable: Bool) -> MovementComponent {
        if disable {
            let component = self.component(ofType: MovementComponent.self)!
            removeComponent(ofType: MovementComponent.self)
            return component
        } else {
            let renderComponent = component(ofType: GKSKNodeComponent.self)!
            let newComponent = createMovementComponentWith(renderComponent: renderComponent)
            addComponent(newComponent)
            newComponent.delegate = renderComponent
            return newComponent
        }
    }
    
    private func createMovementComponentWith(renderComponent: GKSKNodeComponent) -> MovementComponent {
        let radius = Float(renderComponent.node.frame.width * 1.0) * 0.0
        return MovementComponent(maxSpeed: 30, maxAcceleration: 30, maxPredictionTime: 1.0, radius: radius, obstacles: obstaclesFor(entities: obstacles), wanderPoint: float2(renderComponent.node.position))
    }
    
    // MARK: - DestinationComponentDelegate
    
    func destinationComponentens(entity: GKEntity, didArriveAt destination: GKEntity) {
        if let capacityComponent = destination.component(ofType: CapacityComponent.self) {
            if capacityComponent.isNotFull {
                capacityComponent.curCapacity += 1
                delegate?.citizenEnitityDidArriveAtDestination(citizen: self)
            } else {
                // TODO: make the entity wait
            }
        }
    }
    
    // MARK: - HealthComponentDelegate
    
    func healthComponentens(entity: GKEntity, didReachHealthLevel healthLevel: HealthLevel) {
        switch healthLevel {
        case .best:
            break
        case .normal:
            break
        case .critical:
            break
        case .dead:
            delegate?.citizenEnitityDidDie(citizen: self)
        }
        
    }
}
