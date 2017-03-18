//
//  WorldScene.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 07/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import SpriteKit

class WorldScene: BaseScene {
    
    var pan: UIPanGestureRecognizer!
    var pinch: UIPinchGestureRecognizer!
    
    lazy var mapNode: SKSpriteNode = self.childNode(withName: "map") as! SKSpriteNode
    
    lazy var textNode: SKMultilineLabel = SKMultilineLabel.defaultStyle(backgroundSize: self.size)
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // make one city blink
        let cityNode = mapNode.childNode(withName: "city") as! SKSpriteNode
        let fadeIn = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1.0, duration: 1.5)
        let fadeOut = SKAction.colorize(with: UIColor.lightGray, colorBlendFactor: 1.0, duration: 1.5)
        
        cityNode.run(SKAction.repeatForever(SKAction.sequence([fadeIn, fadeOut])))
        
        // add gestuers
        pan = UIPanGestureRecognizer(target: self, action: #selector(WorldScene.handlePan(_:)))
//        pinch = UIPinchGestureRecognizer(target: self, action: #selector(WorldScene.handlePinch(_:)))
        
        view.addGestureRecognizer(pan)
        
        // create camera for gestures
        createCamera()
        
        // Show intro
        presentIntro()
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        view.removeGestureRecognizer(pan)
    }
    
    func presentIntro() {
        let textScene = SKScene(fileNamed: "TextScene")!
        
        overlay = SceneOverlay(scene: textScene, zPosition: WorldLayer.aboveCharacters.rawValue)
        overlay?.contentNode.addChild(textNode)
        
        textNode.text = Const.Intros.global
    }
    
    // MARK: ButtonNodeResponderType
    
    override func buttonTriggered(button: ButtonNode) {
        switch button.buttonIdentifier! {
        case .city:
            sceneManager.present(scene: .level(1))
            SoundManager.sharedInstance.playSound(.click, inScene: self)
        case .resume:
            overlay = nil
            SoundManager.sharedInstance.playSound(.click, inScene: self)
        default:
            super.buttonTriggered(button: button)
        }
    }
    
    func handlePan(_ sender: UIPanGestureRecognizer) {
        // Scroll on scene
        let translation = sender.translation(in: view)
        
        camera?.position.y += translation.y
        camera?.position.x -= translation.x
        
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func handlePinch(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else { return }
        
        let locationInView = sender.location(in: self.view)
        let location = self.convertPoint(fromView: locationInView)
        if sender.state == .changed {
            let deltaScale = (sender.scale - 1.0) * 2
            let convertedScale = sender.scale - deltaScale
            let newScale = camera.xScale * convertedScale
            camera.setScale(newScale)
            
            let locationAfterScale = self.convertPoint(fromView: locationInView)
            let locationDelta = location - locationAfterScale
            let newPoint = camera.position + locationDelta
            camera.position = newPoint
            sender.scale = 1.0
        }
    }
}

