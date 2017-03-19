//
//  BaseScene.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 15/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import SpriteKit

class BaseScene: SKScene {
    // MARK: Properties
    
    /**
     The native size for this scene. This is the height at which the scene
     would be rendered if it did not need to be scaled to fit a window or device.
     Defaults to `zeroSize`; the actual value to use is set in `createCamera()`.
     */
    var nativeSize = CGSize.zero
    
    /**
     The background node for this `BaseScene` if needed. Provided by those subclasses
     that use a background scene in their SKS file to center the scene on screen.
     */
    var backgroundNode: SKSpriteNode? {
        return nil
    }
    
    lazy var worldNode: SKNode = self.childNode(withName: "world")!
    
    /// All buttons currently in the scene. Updated by assigning the result of `findAllButtonsInScene()`.
    var buttons = [ButtonNode]()
    
    /// The current scene overlay (if any) that is displayed over this scene.
    var overlay: SceneOverlay? {
        didSet {
            // Clear the `buttons` in preparation for new buttons in the overlay.
            buttons = []
            
            self.createCamera()
            
            if let overlay = overlay, let camera = camera {
                overlay.backgroundNode.removeFromParent()
                overlay.backgroundNode.alpha = 1.0
                
                camera.addChild(overlay.backgroundNode)
                
                // Animate the overlay in.
                // TODO: Fix fade in
                overlay.backgroundNode.run(SKAction.fadeIn(withDuration: 0.25))
                overlay.updateScale()
                
                buttons = findAllButtonsInScene()
            }
            
            // Animate the old overlay out.
            oldValue?.backgroundNode.run(SKAction.fadeOut(withDuration: 0.25)) {
                oldValue?.backgroundNode.removeFromParent()
            }
        }
    }
    
    /// A reference to the scene manager for scene progression.
    weak var sceneManager: SceneManager!
    
    // MARK: SKScene Life Cycle
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        updateCameraScale()
        overlay?.updateScale()
        
        // Find all the buttons and set the initial focus.
        buttons = findAllButtonsInScene()
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        
        updateCameraScale()
        overlay?.updateScale()
    }
    
    // MARK: Camera Actions
    
    /**
     Creates a camera for the scene, and updates its scale.
     This method should be called when initializing an instance of a `BaseScene` subclass.
     */
    func createCamera() {
        if let backgroundNode = backgroundNode {
            // If the scene has a background node, use its size as the native size of the scene.
            nativeSize = backgroundNode.size
        } else {
            // Otherwise, use the scene's own size as the native size of the scene.
            nativeSize = size
        }
        
        if self.camera == nil {
            let camera = SKCameraNode()
            self.camera = camera
            addChild(camera)
        }
        
        let width = size.width
        let height = size.height
        let xRange = SKRange(lowerLimit: -width, upperLimit: width)
        let yRange = SKRange(lowerLimit: -height, upperLimit: height)
        let constraint = SKConstraint.positionX(xRange, y: yRange)
        
        camera!.constraints = [constraint]
        
        updateCameraScale()
    }
    
    /// Centers the scene's camera on a given point.
    func centerCameraOnPoint(point: CGPoint) {
        if let camera = camera {
            camera.position = point
        }
    }
    
    /// Scales the scene's camera.
    func updateCameraScale() {
        /*
         Because the game is normally playing in landscape, use the scene's current and
         original heights to calculate the camera scale.
         */
        if let camera = camera {
            camera.setScale(nativeSize.height / size.height)
        }
    }
}

/// Extends `BaseScene` to respond to ButtonNode events.
extension BaseScene: ButtonNodeResponderType {
    
    /// Searches the scene for all `ButtonNode`s.
    func findAllButtonsInScene() -> [ButtonNode] {
        return ButtonIdentifier.allButtonIdentifiers.flatMap { buttonIdentifier in
            childNode(withName: "//\(buttonIdentifier.rawValue)") as? ButtonNode
        }
    }
    
    // MARK: ButtonNodeResponderType
    
    func buttonTriggered(button: ButtonNode) {
        SoundManager.sharedInstance.playSound(.click, inScene: self)
        switch button.buttonIdentifier! {
        case .home:
            sceneManager.present(scene: .home)
        case .retry:
            sceneManager.present(scene: .currentLevel)
        default:
            fatalError("Unsupported ButtonNode type in Scene.")
        }
    }
}
