//
//  EventComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 09/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

enum GameEvent {
    case affectMoney(Double)
    case citizenDied(Double)
    case reachHealth(HealthLevel)
    case upgrade(Double)
}

class EventComponent: GKComponent {
    var scene: LevelScene
    var nextEventToTrigger: GameEvent?
    
    init(scene: LevelScene) {
        self.scene = scene
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let event = nextEventToTrigger else { return }
        guard let entityNode = entity?.component(ofType: GKSKNodeComponent.self)?.node else { return }
        let position = entityNode.position
        
        switch event {
        case .affectMoney(let money):
            animate(text: money.format(".0") + "$", startPosition:  position, isNegative: money < 0)
            SoundManager.sharedInstance.playSound(.coin, inScene: scene)
            
        case .citizenDied(let money):
            animate(text: money.format(".0") + "$", startPosition:  position, isNegative: true)
            SoundManager.sharedInstance.playSound(.overrun, inScene: scene)
            
        case .reachHealth(let healthLevel):
            animate(node: entityNode, healthLevel: healthLevel)
            
        case .upgrade(let money):
            animate(text: "-" + money.format(".0") + "$", startPosition:  position, isNegative: false)
            
        }
        nextEventToTrigger = nil
    }
    
    private func animate(text: String, startPosition position: CGPoint, isNegative: Bool) {
        let label = SKLabelNode(text: text)
        label.fontName = Const.Fonts.medium
        label.fontSize = Const.Fonts.Size.large
        label.color = isNegative ? UIColor.red : UIColor.white
        label.colorBlendFactor = 1.0
        label.position.x = position.x
        label.position.y = position.y + 10
        label.zPosition = WorldLayer.aboveCharacters.rawValue
        label.alpha = 0.0
        
        scene.addChild(label)
        
        let fadeIn = SKAction.fadeIn(withDuration: 0.3)
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 1.6)
        let fadeOut = SKAction.fadeOut(withDuration: 1.6)
        let moveUpAndFadeOut = SKAction.group([moveUp, fadeOut])
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeIn, moveUpAndFadeOut, remove])
        
        label.run(sequence)
    }
    
    private func animate(node: SKNode, healthLevel: HealthLevel) {
        
    }
}
