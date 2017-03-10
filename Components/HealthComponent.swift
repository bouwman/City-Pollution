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
    var healthBar: HealthBar?
    
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
                let upgradeFactor = upgradeComponent?.currentUpgrade.factor ?? 1.0
                curHealth += 1 / levelManager.cityPollution * increaseFactor * upgradeFactor
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
            if let sprite = renderComponent.node as? CitizenNode {
                let percent = curHealth / maxHealth
                sprite.updateSpriteWith(healthLevel: percent)
                updateHealthBarWith(healthLevel: percent, forNode: sprite)
            }
        }
    }
    
    private  func updateHealthColorWith(healthLevel: Double, forNode node: SKSpriteNode) {
        node.colorBlendFactor = 1.0
        node.color = UIColor(hue: 0.0, saturation: CGFloat(1 - curHealth / maxHealth), brightness: 1.0, alpha: 1.0)
    }
    
    private func updateHealthBarWith(healthLevel: Double, forNode node: SKSpriteNode) {
        if let healthBar = healthBar {
            healthBar.curPercent = healthLevel
            healthBar.position.x = node.position.x
            healthBar.position.y = node.position.y + node.size.height / 2 + Const.Citizens.healthBarDistance
        } else {
            let height: CGFloat = Const.Citizens.healthBarHeight
            let width = node.size.width
            healthBar = HealthBar(color: UIColor.darkGray, size: CGSize(width: width, height: height))
            healthBar!.healthBarColor = Const.Citizens.healthBarColor
            healthBar!.maxWidth = width
            healthBar!.curPercent = healthLevel
            healthBar!.position.x = node.position.x
            healthBar!.position.y = node.position.y + node.size.height / 2 + Const.Citizens.healthBarDistance
            healthBar!.zPosition = 2
            healthBar!.name = String(describing: self)
            node.parent?.addChild(healthBar!)
        }
    }
    
    private var isInRegenerationZone: Bool {
        guard let node = entity?.component(ofType: GKSKNodeComponent.self)?.node else { return false }
        guard let regenerationZone = node.scene?.childNode(withName: Const.Nodes.Layers.board)?.childNode(withName: Const.Nodes.regenerationZone) else { return false }
        
        return regenerationZone.contains(node.position)
    }
    
    private var upgradeComponent: UpgradeComponent?  {
        guard let node = entity?.component(ofType: GKSKNodeComponent.self)?.node else { return nil }
        guard let regenerationZone = node.scene?.childNode(withName: Const.Nodes.Layers.board)?.childNode(withName: Const.Nodes.regenerationZone) else { return nil }
        
        return regenerationZone.entity?.component(ofType: UpgradeComponent.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
