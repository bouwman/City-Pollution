//
//  DrawPathComponent.swift
//  DrawToMoveExamplee
//
//  Created by Tassilo Bouwman on 07/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class DrawPathComponent: GKComponent {
    
    var pathColor = SKColor(white: 0.9, alpha: 0.8)
    var pathColorDestination = SKColor(hue: 0.589, saturation: 0.68, brightness: 0.89, alpha: 1.0)

    var renderComponent: GKSKNodeComponent {
        guard let renderComponent = entity?.component(ofType: GKSKNodeComponent.self) else { fatalError("A DrawPathComponent entity must have a RenderComponent") }
        return renderComponent
    }

    var pathComponent: PathComponent {
        guard let pathComponent = entity?.component(ofType: PathComponent.self) else { fatalError("A DrawPathComponent entity must have a PathComponent") }
        return pathComponent
    }
    
    weak var lastParentNode: SKNode?
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let entity = self.entity else { return }
        
        if let scene = renderComponent.node.scene as? BaseScene {
            lastParentNode = scene.worldNode
        }
        
        guard let parentNode = lastParentNode else { return }

        parentNode.enumerateChildNodes(withName: String(describing: entity), using: { node, stop in
            node.removeFromParent()
        })
        
        if let path = convertPointsToDrawingPath(points: pathComponent.wayPoints) {
            let shapeNode = SKShapeNode()
            shapeNode.path = path
            shapeNode.name = String(describing: entity)
            shapeNode.strokeColor = hasDestination ? pathColorDestination : pathColor
            shapeNode.lineWidth = 2
            shapeNode.zPosition = -1
            
            parentNode.addChild(shapeNode)
        }
    }
    
    func convertPointsToDrawingPath(points: [CGPoint]) -> CGPath? {
        if points.count <= 1 { return nil }
        let ref = CGMutablePath()
        
        for i in 0 ..< points.count {
            let p = points[i]
            if i == 0 {
                ref.move(to: p)
            } else {
                ref.addLine(to: p)
            }
        }
        return ref
    }
    
    private var hasDestination: Bool {
        if let destinationComponent = entity?.component(ofType: DestinationComponent.self), destinationComponent.destination != nil {
            return true
        } else {
            return false
        }
    }
}

extension SKNode {
    static func findParentScene(node: SKNode) -> SKScene? {
        if let nodeIsScene = node as? SKScene {
            return nodeIsScene
        } else if let parentIsScene = node.parent as? SKScene {
            return parentIsScene
        } else if let hasParent = node.parent {
            return findParentScene(node: hasParent)
        } else { // has no parent node
            return nil
        }
    }
}
