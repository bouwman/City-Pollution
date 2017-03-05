//
//  SoundManager.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 05/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import SpriteKit

enum Sound {
    case coin, overrun, click
}

class SoundManager {
    private let playCoin = SKAction.playSoundFileNamed("coins.caf", waitForCompletion: false)
    private let playOverrun = SKAction.playSoundFileNamed("overrun.caf", waitForCompletion: false)
    private let playClick = SKAction.playSoundFileNamed("click.caf", waitForCompletion: false)
    
    weak var currentScene: BaseScene?
    
    static let sharedInstance = SoundManager()
    
    private init() {}
    
    func playSound(_ sound: Sound, inScene scene: SKScene) {
        
        switch sound {
        case .coin:
            scene.run(playCoin)
        case .overrun:
            scene.run(playOverrun)
        case .click:
            scene.run(playClick)
        }
    }
    
    func playSound(_ sound: Sound) {
        guard let currentScene = self.currentScene else { return }
        playSound(sound, inScene: currentScene)
    }
}
