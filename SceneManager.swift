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
        case .level(_):
            if let scene = SKScene(fileNamed: "LevelScene") as? BaseScene {
                scene.sceneManager = self
                scene.scaleMode = .aspectFill
                                
                presentingView.presentScene(scene)
            }
        default:
            break
        }
        
        
        
    }
}
