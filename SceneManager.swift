//
//  SceneManager.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 15/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import SpriteKit

enum SceneIdentifier {
    case home
    case currentLevel, nextLevel
    case level(Int)
}

class SceneManager {
    let presentingView: SKView

    init(presentingView: SKView) {
        self.presentingView = presentingView
    }
    
    lazy var firstLevelConfig = LevelConfiguration(pollutionIndustry: 500, pollutionLight: 480, pollutionTransport: 500, citizenCount: 12, citizenSpawnInterval: 10, pollutionWinLevel: 0.35, supportLoseLevel: -1500)
    
    func present(scene identifier: SceneIdentifier) {
        switch identifier {
        case .level(_), .currentLevel:
            guard let scene = SKScene(fileNamed: "LevelScene") as? LevelScene else { break }
            scene.sceneManager = self
            
            scene.entityManager = EntityManager(scene: scene)
            scene.levelManager = LevelManager(scene: scene, configuration: firstLevelConfig)
            
            scene.scaleMode = .aspectFit
            
            let transition = SKTransition.fade(withDuration: 1.0)
            presentingView.presentScene(scene, transition: transition)
            
            SoundManager.sharedInstance.currentScene = scene
        case .home:
            guard let scene = SKScene(fileNamed: "WorldScene") as? WorldScene else { break }
            scene.sceneManager = self
            
            scene.scaleMode = .aspectFit
            
            let transition = SKTransition.fade(withDuration: 1.0)
            presentingView.presentScene(scene, transition: transition)
            
            SoundManager.sharedInstance.currentScene = scene
            
            // TODO: Temporary solution
            SoundManager.sharedInstance.playMusic(music: .level, inScene: scene)
        default:
            break
        }
    }
}
