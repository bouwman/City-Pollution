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

enum Music {
    case level, world
}

class SoundManager {
    private let playCoin = SKAction.playSoundFileNamed("coins.caf", waitForCompletion: false)
    private let playOverrun = SKAction.playSoundFileNamed("overrun.caf", waitForCompletion: false)
    private let playClick = SKAction.playSoundFileNamed("click.caf", waitForCompletion: false)
    private lazy var levelMusicNode: SKAudioNode = {
        let node = SKAudioNode(fileNamed: "background.mp3")
        node.isPositional = false
        node.autoplayLooped = true
        
        return node
    }()
    
    weak var currentScene: SKScene?
    
    static let sharedInstance = SoundManager()
    
    private init() {}
    
    func playMusic(music: Music, inScene scene: SKScene) {
        switch music {
        case .level:
            if levelMusicNode.parent != nil {
                stopMusic()
            }
            scene.addChild(levelMusicNode)
        case .world:
            fatalError("no music yet")
        }
    }
    
    func stopMusic() {
        levelMusicNode.run(SKAction.stop())
        levelMusicNode.removeFromParent()
    }
    
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
