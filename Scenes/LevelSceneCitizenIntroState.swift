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
    
    private lazy var titleTextNode: SKMultilineLabel = {
        let size = self.overlay.nativeContentSize
        let label = SKMultilineLabel.defaultStyle(backgroundSize: size)
        let normalY = label.position.y
        
        label.position.y = normalY + 30
        label.fontSize = 24
        self.overlay.contentNode.addChild(label)
        
        return label
    }()
    
    private lazy var textNode: SKMultilineLabel = {
        let size = self.overlay.nativeContentSize
        let label = SKMultilineLabel.defaultStyle(backgroundSize: size)
        
        label.labelWidth = Int(size.width - 220)
        label.position.y = size.height / 2 - 120
        
        self.overlay.contentNode.addChild(label)
        
        return label
    }()
    
    override var overlaySceneFileName: String {
        return "IntroCitizenScene"
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        titleTextNode.text = "Now that the pollution levels are lower, high risk citizens can leave their homes for a short time."
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
