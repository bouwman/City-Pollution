//
//  SceneOverlay.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 15/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import SpriteKit

class SceneOverlay {
    // MARK: Properties
    
    let backgroundNode: SKSpriteNode
    
    let contentNode: SKSpriteNode
    
    let nativeContentSize: CGSize
    
    // MARK: Intialization
    
    init(scene: SKScene, zPosition: CGFloat) {
        let contentTemplateNode = scene.childNode(withName: "Overlay") as! SKSpriteNode
        
        // Create a background node with the same color as the template.
        backgroundNode = SKSpriteNode(color: contentTemplateNode.color, size: contentTemplateNode.size)
        backgroundNode.zPosition = zPosition
        
        // Copy the template node into the background node.
        contentNode = contentTemplateNode.copy() as! SKSpriteNode
        contentNode.position = .zero
        backgroundNode.addChild(contentNode)
        
        // Set the content node to a clear color to allow the background node to be seen through it.
        contentNode.color = .clear
        
        // Store the current size of the content to allow it to be scaled correctly.
        nativeContentSize = contentNode.size
    }
    
    convenience init(overlaySceneFileName fileName: String, zPosition: CGFloat) {
        // Load the scene and get the overlay node from it.
        let overlayScene = SKScene(fileNamed: fileName)!
        
        self.init(scene: overlayScene, zPosition: zPosition)
    }
    
    func updateScale() {
        guard let viewSize = backgroundNode.scene?.view?.frame.size else {
            return
        }
        
        // TODO: Update for moving camera
        // Resize the background node.
        // backgroundNode.size = viewSize
        
        // Scale the content so that the height always fits.
        let scale = CGFloat(1.0) // viewSize.height / nativeContentSize.height
        contentNode.setScale(scale)
    }
}

