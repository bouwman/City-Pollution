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
    
    private var textBackground: SKSpriteNode {
        return self.overlay.contentNode.childNode(withName: Const.Nodes.instructionsBackground)! as! SKSpriteNode
    }
    
    private lazy var textNode: SKMultilineLabel = {
        let width = Int(self.textBackground.size.width / 2 + 30)
        let label = SKMultilineLabel(text: "", labelWidth: width, pos: CGPoint.zero)
        let background = self.textBackground
        
        label.fontSize = 20
        label.alignment = .left
        label.leading = 21
        label.fontColor = UIColor.black
        label.position.y = background.size.height / 2.0 - 15
        label.zPosition = 1000
        
        background.addChild(label)
        
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
