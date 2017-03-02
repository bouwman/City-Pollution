//
//  Nodes.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 12/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import SpriteKit

class CitizenNode: SKSpriteNode {
}

class BuildingNode: SKSpriteNode {
}

class WallNode: SKSpriteNode {
}

class DoorNode: SKSpriteNode {
}

class HouseNode: SKSpriteNode {
    var door: SKSpriteNode {
        return childNode(withName: Const.Nodes.Houses.door) as! SKSpriteNode
    }
    var doorPosition: CGPoint {
        return convert(self.door.position, to: self.parent!)
    }
    var windows: [WindowNode] {
        var windowNodes = [WindowNode]()
        enumerateChildNodes(withName: "CityPollution.\(String(describing: WindowNode.self))", using: { (node, stop) in
            windowNodes.append(node as! WindowNode)
        })
        
        return windowNodes
    }
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
