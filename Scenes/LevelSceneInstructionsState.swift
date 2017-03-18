//
//  LevelSceneInstructionsState.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 13/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class LevelSceneInstructionsState: LevelSceneOverlayState {
    // MARK: Properties
    
    private lazy var textNode: SKMultilineLabel = {
        let label = SKMultilineLabel.defaultStyle(backgroundSize: self.overlay.nativeContentSize)
        
        self.overlay.contentNode.addChild(label)
        
        return label
    }()
    
    override var overlaySceneFileName: String {
        return "TextScene"
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        if let currentStepText = levelScene.tutorialManager.currentStep {
            textNode.text = currentStepText
            
            if let currentStepImageName = levelScene.tutorialManager.currentStepImageName {
                addBackgroundImage(named: currentStepImageName)
            } else {
                overlay.contentNode.childNode(withName: Const.Nodes.cityIntroImage)?.removeFromParent()
            }
        } else {
            textNode.text = "no instructions"
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        switch stateClass {
        case is LevelSceneActiveState.Type, is LevelSceneTutorialState.Type:
            return true
            
        default:
            return false
        }
    }
    
    override func willExit(to nextState: GKState) {
        super.willExit(to: nextState)
        
        levelScene.pause(false)
    }
    
    private func addBackgroundImage(named: String) {
        let imageNode = SKSpriteNode(imageNamed: named)
        imageNode.name = Const.Nodes.cityIntroImage
        imageNode.zPosition = WorldLayer.aboveCharacters.rawValue
        
        overlay.contentNode.addChild(imageNode)
    }
}
