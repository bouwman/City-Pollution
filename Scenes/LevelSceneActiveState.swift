//
//  LevelSceneActiveState.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 05/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class LevelSceneActiveState: GKState {

    unowned let levelScene: LevelScene
    
    init(levelScene: LevelScene) {
        self.levelScene = levelScene
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is LevelScenePauseState.Type, is LevelSceneFailState.Type, is LevelSceneSuccessState.Type:
            return true
            
        default:
            return false
        }
    }
}
