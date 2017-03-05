//
//  LevelSceneOverlayState.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 05/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class LevelSceneOverlayState: GKState {

    unowned let levelScene: LevelScene
    
    /// The `SceneOverlay` to display when the state is entered.
    var overlay: SceneOverlay!
    
    /// Overridden by subclasses to provide the name of the .sks file to load to show as an overlay.
    var overlaySceneFileName: String { fatalError("Unimplemented overlaySceneName") }
    
    
    init(levelScene: LevelScene) {
        self.levelScene = levelScene
        
        super.init()
        
        overlay = SceneOverlay(overlaySceneFileName: overlaySceneFileName, zPosition: WorldLayer.top.rawValue)
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        // Provide the levelScene with a reference to the overlay node.
        levelScene.overlay = overlay
        
        levelScene.pause(true)
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        levelScene.overlay = nil
    }
}
