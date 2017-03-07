//
//  HealthComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 12/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit
import SpriteKit

enum HealthLevel {
    case dead
    case critical
    case normal
    case best
}

protocol HealthComponentDelegate {
    func healthComponentens(entity: GKEntity, didReachHealthLevel healthLevel: HealthLevel)
}

class HealthComponent: GKComponent {
    let maxHealth: Double
    var decreaseFactor: Double
    var increaseFactor: Double
    var isRegenerating: Bool
    var delegate: HealthComponentDelegate?
    
    private(set) var curHealth: Double {
        didSet {
            if curHealth < 0 {
                curHealth = 0
            } else if curHealth > maxHealth {
                curHealth = maxHealth
            }
        }
    }
    
    var curHealthPercent: Double {
        return curHealth / maxHealth
    }
    
    private var oldHealth: Double
    
    init(maxHealth: Double, decreaseFactor: Double, startHealthPercent: Double, increaseFactor: Double) {
        self.maxHealth = maxHealth
        self.decreaseFactor = decreaseFactor
        self.curHealth = maxHealth * startHealthPercent
        self.oldHealth = curHealth
        self.isRegenerating = true
        self.increaseFactor = increaseFactor
        
        super.init()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        oldHealth = curHealth
        
        if let pollutionComponent = entity?.component(ofType: PollutionComponent.self) {
            let levelManager = pollutionComponent.levelManager
            if isRegenerating && isInRegenerationZone {
                curHealth += 1 / levelManager.cityPollution * increaseFactor
            } else {
                curHealth -= levelManager.cityPollution * decreaseFactor
            }
        }
        switch curHealth {
        case 0:
            delegate?.healthComponentens(entity: entity!, didReachHealthLevel: .dead)
        case maxHealth:
            isRegenerating = false
            delegate?.healthComponentens(entity: entity!, didReachHealthLevel: .best)
        default:
            break
        }
        
        if let renderComponent = entity?.component(ofType: GKSKNodeComponent.self) {
            if let sprite = renderComponent.node as? SKSpriteNode {
                updateHealthColorFor(node: sprite)
//                updateHealthBarFor(node: sprite)
            }
        }
    }
    
    private  func updateHealthColorFor(node: SKSpriteNode) {
        node.colorBlendFactor = 1.0
        node.color = UIColor(hue: 0.0, saturation: CGFloat(1 - curHealth / maxHealth), brightness: 1.0, alpha: 1.0)
    }
    
    private func updateHealthBarFor(node: SKSpriteNode) {
        let width = node.size.width * CGFloat(curHealth / maxHealth)
        
        if let existingHealthBar = node.childNode(withName: Const.Nodes.healthBar) as? SKSpriteNode {
            existingHealthBar.size.width = width
            existingHealthBar.zRotation = -node.zRotation
        } else {
            let height: CGFloat = 5.0
            let healthBar = SKSpriteNode(color: UIColor.red, size: CGSize(width: width, height: height))
            healthBar.position.y = node.size.height / 2.0 + height
            healthBar.zPosition = 2
            healthBar.name = Const.Nodes.healthBar
            healthBar.zRotation = -node.zRotation
            node.addChild(healthBar)
        }
    }
    
    private var isInRegenerationZone: Bool {
        guard let node = entity?.component(ofType: GKSKNodeComponent.self)?.node else { return false }
        guard let regenerationZone = node.scene?.childNode(withName: Const.Nodes.Layers.board)?.childNode(withName: Const.Nodes.regenerationZone) else { return false }
        
        return regenerationZone.contains(node.position)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
