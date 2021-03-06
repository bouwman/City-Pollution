//
//  EntityManager.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 09/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit
import SpriteKit

class EntityManager {
    
    var entities = Set<GKEntity>()
    unowned let scene: BaseScene
    var toRemove = Set<GKEntity>()
        
    lazy var componentSystems: [GKComponentSystem] = {
        let lights = GKComponentSystem(componentClass: LightComponent.self)
        let contaminators = GKComponentSystem(componentClass: ContaminatorComponent.self)
        let health = GKComponentSystem(componentClass: HealthComponent.self)
        let movement = GKComponentSystem(componentClass: MovementComponent.self)
        let destination = GKComponentSystem(componentClass: DestinationComponent.self)
        let drawPath = GKComponentSystem(componentClass: DrawPathComponent.self)
        let capacity = GKComponentSystem(componentClass: CapacityComponent.self)
        let infiniteMovement = GKComponentSystem(componentClass: InfiniteMovementComponent.self)
        let upgrade = GKComponentSystem(componentClass: UpgradeComponent.self)
        let event = GKComponentSystem(componentClass: EventComponent.self)
        // !!!: Order matters!!
        return [lights, contaminators, health, movement, destination, drawPath, capacity, infiniteMovement, upgrade, event]
    }()
    
    init(scene: BaseScene) {
        self.scene = scene
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let node = entity.component(ofType: GKSKNodeComponent.self)?.node, node.parent == nil {
            scene.worldNode.addChild(node)
        }
        
        addComponentsOf(entity: entity)
        
        if let stateComponent = entity.component(ofType: StateComponent.self) {
            stateComponent.enterInitialState()
        }
    }
    
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: GKSKNodeComponent.self)?.node {
            if let _ = entity.component(ofType: PathComponent.self) {
                scene.enumerateChildNodes(withName: String(describing: entity), using: { (line, stop) in
                    line.removeFromParent()
                })
            }
            if let healthComponent = entity.component(ofType: HealthComponent.self) {
                healthComponent.healthBar?.removeFromParent()
            }
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
        toRemove.insert(entity)
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        for curRemove in toRemove {
            removeComponentsOf(entity: curRemove)
        }
        toRemove.removeAll()
    }
    
    private var isPaused = false
    
    func pause(_ pause: Bool) {
        guard pause != isPaused else { return }
        isPaused = pause
        for entity in entities {
            if let citizen = entity as? CitizenEntity {
                let moveComponent = citizen.disableMovementComponent(pause)
                for componentSystem in componentSystems {
                    guard componentSystem.componentClass === MovementComponent.self else { continue }
                    if pause {
                        componentSystem.removeComponent(moveComponent)
                    } else {
                        componentSystem.addComponent(moveComponent)
                    }
                }
            }
            if let car = entity as? CarEntity {
                let moveComponent = car.disableMovementComponent(pause)
                for componentSystem in componentSystems {
                    guard componentSystem.componentClass === InfiniteMovementComponent.self else { continue }
                    if pause {
                        componentSystem.removeComponent(moveComponent)
                    } else {
                        componentSystem.addComponent(moveComponent)
                    }
                }
            }
        }
    }
    
    private func addComponentsOf(entity: GKEntity) {
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    private func removeComponentsOf(entity: GKEntity) {
        for componentSystem in componentSystems {
            componentSystem.removeComponent(foundIn: entity)
        }
    }
}
