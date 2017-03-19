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
    
    private lazy var imageNode: SKSpriteNode = {
        let imageNode = SKSpriteNode(color: UIColor.red, size: CGSize(width: 50, height: 50))
        imageNode.name = Const.Nodes.cityIntroImage
        imageNode.zPosition = WorldLayer.aboveCharacters.rawValue
        imageNode.isHidden = true
        
        self.overlay.contentNode.addChild(imageNode)
        
        return imageNode
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
                let texture = SKTexture(imageNamed: currentStepImageName)
                imageNode.isHidden = false
                imageNode.texture = texture
                imageNode.size = texture.size()
            } else {
                imageNode.isHidden = true
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
}
