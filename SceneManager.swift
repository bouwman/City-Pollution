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
    
    func present(scene identifier: SceneIdentifier) {
        switch identifier {
        case .level(_), .currentLevel:
            if let scene = SKScene(fileNamed: "LevelScene") as? BaseScene {
                scene.sceneManager = self
                scene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 1.0)
                presentingView.presentScene(scene, transition: transition)
            }
        default:
            break
        }
        
        
        
    }
}
