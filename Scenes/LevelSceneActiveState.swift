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
        
        let config = levelScene.levelManager.configuration
        
        if levelScene.levelManager.citizenCount == 0 {
            levelScene.stateMachine.enter(LevelSceneFailState.self)
        } else if levelScene.levelManager.money < config.supportLoseLevel {
            levelScene.stateMachine.enter(LevelSceneFailState.self)
        } else if levelScene.levelManager.cityPollutionRel < config.pollutionWinLevel {
            levelScene.stateMachine.enter(LevelSceneSuccessState.self)
        }
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
