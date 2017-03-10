//
//  UpgradeComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 09/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

struct Upgrade: Equatable {
    let money: Double
    let factor: Double
    let spriteName: String
    
    static func ==(lhs: Upgrade, rhs: Upgrade) -> Bool {
        return lhs.money == rhs.money && lhs.factor == rhs.factor && lhs.spriteName == rhs.spriteName
    }
}

class UpgradeComponent: GKComponent {
    let upgrades: [Upgrade]
    let levelManager: LevelManager
    
    var currentUpgrade: Upgrade
    
    init(levelManager: LevelManager, upgrades: [Upgrade]) {
        self.upgrades = upgrades
        self.currentUpgrade = upgrades.first!
        self.levelManager = levelManager
        
        super.init()
        
        applyCurrentUpgrade()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tryToUpgrade() {
        for (i, upgrade) in upgrades.enumerated() {
            if upgrade == currentUpgrade, i != upgrades.count - 1 {
                let possibleUpgrade = upgrades[i + 1]
                if levelManager.money >= possibleUpgrade.money {
                    currentUpgrade = possibleUpgrade
                    applyCurrentUpgrade()
                    SoundManager.sharedInstance.playSound(.click)
                }
                return
            }
        }
    }
    
    private func applyCurrentUpgrade() {
        levelManager.money -= currentUpgrade.money
        if let contaminator = entity?.component(ofType: ContaminatorComponent.self) {
            contaminator.factor = currentUpgrade.factor
        }
        if let sprite = entity?.component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode {
            if currentUpgrade.spriteName.isEmpty {
                sprite.color = UIColor(white: CGFloat(currentUpgrade.factor), alpha: 1.0)
            } else {
                sprite.texture = SKTexture(imageNamed: currentUpgrade.spriteName)
            }
        }
        if let event = entity?.component(ofType: EventComponent.self) {
            event.nextEventToTrigger = .upgrade(currentUpgrade.money)
        }
    }
}
