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

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(WorldScene.handlePan(_:)))
//        pinch = UIPinchGestureRecognizer(target: self, action: #selector(WorldScene.handlePinch(_:)))
        
        view.addGestureRecognizer(pan)
//        view.addGestureRecognizer(pinch)
        
        createCamera()
    }
    
    override func willMove(from view: SKView) {
        super.willMove(from: view)
        
        view.removeGestureRecognizer(pan)
//        view.removeGestureRecognizer(pinch)
    }
    
    // MARK: ButtonNodeResponderType
    
    override func buttonTriggered(button: ButtonNode) {
        switch button.buttonIdentifier! {
        case .city:
            sceneManager.present(scene: .level(1))
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
