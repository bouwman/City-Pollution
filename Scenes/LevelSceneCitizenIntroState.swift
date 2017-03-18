//
//  LevelSceneCitizenIntroState.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 16/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class LevelSceneCitizenIntroState: LevelSceneOverlayState {
    // MARK: Properties
    
    private lazy var textNode: SKMultilineLabel = {
        let size = self.overlay.nativeContentSize
        let label = SKMultilineLabel.defaultStyle(backgroundSize: size)
        
        label.labelWidth = Int(size.width - 220)
        label.position.y = size.height / 2 - 90
        
        self.overlay.contentNode.addChild(label)
        
        return label
    }()
    
    override var overlaySceneFileName: String {
        return "IntroCitizenScene"
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        textNode.text = levelScene.citizenSpawner.lastSpawnedType.intro
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is LevelSceneActiveState.Type || stateClass is LevelSceneTutorialState.Type
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        levelScene.pause(false)
    }    
}
