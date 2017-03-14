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
    
    private var textBackground: SKSpriteNode {
        return self.overlay.contentNode.childNode(withName: Const.Nodes.instructionsBackground)! as! SKSpriteNode
    }
    
    private lazy var textNode: SKMultilineLabel = {
        let width = Int(self.textBackground.size.width - 20.0)
        let label = SKMultilineLabel(text: "", labelWidth: width, pos: CGPoint.zero)
        let background = self.textBackground
        
        label.fontSize = 20
        label.alignment = .center
        label.leading = 21
        label.position.y = background.size.height / 2.0
        
        background.addChild(label)
        
        return label
    }()
    
    override var overlaySceneFileName: String {
        return "InstructionsScene"
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        if let currentStepText = levelScene.tutorialManager.currentStep {
            textNode.text = currentStepText
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
