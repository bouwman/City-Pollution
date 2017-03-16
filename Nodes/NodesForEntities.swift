//
//  Nodes.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 12/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import SpriteKit

class CitizenNode: SKSpriteNode {
    private var oldRange = Const.Citizens.yellowRange
    func updateSpriteWith(healthLevel: Double, type: CitizenType) {
        switch healthLevel {
        case Const.Citizens.redRange:
            if oldRange != Const.Citizens.redRange {
                oldRange = Const.Citizens.redRange
                run(actionFor(citizenType: type, health: healthLevel))
            }
        case Const.Citizens.yellowRange:
            if oldRange != Const.Citizens.yellowRange {
                oldRange = Const.Citizens.yellowRange
                run(actionFor(citizenType: type, health: healthLevel))
            }
        case Const.Citizens.greenRange:
            if oldRange != Const.Citizens.greenRange {
                oldRange = Const.Citizens.greenRange
                run(actionFor(citizenType: type, health: healthLevel))
            }
        default:
            fatalError("health level out of bounce")
        }
    }
    
    private func actionFor(citizenType: CitizenType, health: Double) -> SKAction {
        return SKAction.setTexture(SKTexture(imageNamed: citizenType.spriteNameFor(health: health)))
    }
}

class BuildingNode: SKSpriteNode {
}

class WallNode: SKSpriteNode {
}

class DoorNode: SKSpriteNode {
}

class ParkNode: SKSpriteNode {
}

class HouseNode: SKSpriteNode {
    var entryArea: SKSpriteNode {
        return childNode(withName: Const.Nodes.destination) as! SKSpriteNode
    }
    var entryAreaPosition: CGPoint {
        return convert(self.entryArea.position, to: self.parent!)
    }
    var windows: [WindowNode] {
        var windowNodes = [WindowNode]()
        enumerateChildNodes(withName: "CityPollution.\(String(describing: WindowNode.self))", using: { (node, stop) in
            windowNodes.append(node as! WindowNode)
        })
        
        return windowNodes
    }
}

class HealthBar: SKSpriteNode {
    var curPercent: Double = 1.0 {
        didSet {
            let newWidth = maxWidth * CGFloat(curPercent)
            healthBarNode.size.width = newWidth
            healthBarNode.position.x = -(maxWidth - newWidth) / 2
            healthBarNode.color = healthBarColor
        }
    }
    
    private lazy var healthBarNode: SKSpriteNode = {
        let sprite = SKSpriteNode(color: self.healthBarColor, size: self.size)
        
        self.addChild(sprite)
        
        return sprite
    }()
    
    var maxWidth: CGFloat = 1.0
    var healthBarColor = UIColor.red
}

class WindowNode: SKSpriteNode {
    var lightOn: Bool = false {
        didSet {
            if lightOn {
                colorBlendFactor = 1.0
                color = UIColor.yellow
            } else {
                colorBlendFactor = 0.0
                color = UIColor.darkGray
            }
        }
    }
}
