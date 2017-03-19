//
//  DestinationComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 10/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

protocol DestinationComponentDelegate {
    func destinationComponentens(entity: GKEntity, didArriveAt destination: GKEntity)
}

class DestinationComponent: GKComponent {
    var possibleDestinations: [GKEntity]
    var destination: GKEntity?
    var delegate: DestinationComponentDelegate?
    
    init(possibleDestinations: [GKEntity]) {
        self.possibleDestinations = possibleDestinations
        
        super.init()
    }
    
    func setDestinationBasedOn(point: CGPoint) {
        for dest in possibleDestinations {
            guard let destNode = dest.component(ofType: GKSKNodeComponent.self)?.node else { fatalError("A DestinationComponent's destination must have a GKSKNodeComponent") }
            
            var destPoint = point
            var nodeToTest = destNode
            
            if let childNode = destNode.childNode(withName: Const.Nodes.destinationSetZone) {
                destPoint = destNode.parent!.convert(point, to: destNode)
                nodeToTest = childNode
            }
            
            if nodeToTest.contains(destPoint) {
                destination = dest
                
                if let pathComponent = entity?.component(ofType: PathComponent.self), let sprite = destNode as? SKSpriteNode {
                    let x = sprite.position.x
                    let y = sprite.position.y - sprite.size.height / 4
                    pathComponent.addMovingPoint(point: CGPoint(x: x, y: y))
                }
            }
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        checkArrival()
    }
    
    private func checkArrival() {
        guard let entity = entity else {
            return
        }
        guard let destination = destination else {
            return
        }
        guard let entityNode = entity.component(ofType: GKSKNodeComponent.self)?.node else { fatalError("A DestinationComponent's entity must have a GKSKNodeComponent") }
        guard var destNode = destination.component(ofType: GKSKNodeComponent.self)?.node else { fatalError("A DestinationComponent's destination must have a GKSKNodeComponent") }
        
        var destPoint = entityNode.position
        
        if let childNode = destNode.childNode(withName: Const.Nodes.destination) {
            destPoint = destNode.parent!.convert(destPoint, to: destNode)
            destNode = childNode
        }
        
        if destNode.contains(destPoint) {
            if let pathComponent = entity.component(ofType: PathComponent.self) {
                pathComponent.clearMovingPoints()
            }
            
            delegate?.destinationComponentens(entity: entity, didArriveAt: destination)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
