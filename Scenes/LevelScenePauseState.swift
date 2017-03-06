//
//  LevelScenePauseState.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 05/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class LevelScenePauseState: LevelSceneOverlayState {
    // MARK: Properties
    
    override var overlaySceneFileName: String {
        return "PauseScene"
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is LevelSceneActiveState.Type
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        levelScene.pause(false)
    }
}
