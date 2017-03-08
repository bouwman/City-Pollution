//
//  ButtonNode.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 15/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import SpriteKit

/// A type that can respond to `ButtonNode` button press events.
protocol ButtonNodeResponderType: class {
    /// Responds to a button press.
    func buttonTriggered(button: ButtonNode)
}

/// The complete set of button identifiers supported in the app.
enum ButtonIdentifier: String {
    case city
    case pause
    case resume
    case home
    case retry
    case cancel
    
    /// Convenience array of all available button identifiers.
    static let allButtonIdentifiers: [ButtonIdentifier] = [.city, .pause, .resume, .home, .retry, .cancel]
    
    /// The name of the texture to use for a button when the button is selected.
    var selectedTextureName: String? {
        return nil
    }
}

/// A custom sprite node that represents a press able and selectable button in a scene.
class ButtonNode: SKSpriteNode {
    // MARK: Properties
    
    /// The identifier for this button, deduced from its name in the scene.
    var buttonIdentifier: ButtonIdentifier!
    
    /**
     The scene that contains a `ButtonNode` must be a `ButtonNodeResponderType`
     so that touch events can be forwarded along through `buttonPressed()`.
     */
    var responder: ButtonNodeResponderType {
        guard let responder = scene as? ButtonNodeResponderType else {
            fatalError("ButtonNode may only be used within a `ButtonNodeResponderType` scene.")
        }
        return responder
    }
    
    /// Indicates whether the button is currently highlighted (pressed).
    var isHighlighted = false {
        // Animate to a pressed / unpressed state when the highlight state changes.
        didSet {
            // Guard against repeating the same action.
            guard oldValue != isHighlighted else { return }
            
            // Remove any existing animations that may be in progress.
            removeAllActions()
            
            // Create a scale action to make the button look like it is slightly depressed.
            let newScale: CGFloat = isHighlighted ? 0.99 : 1.01
            let scaleAction = SKAction.scale(by: newScale, duration: 0.15)
            
            // Create a color blend action to darken the button slightly when it is depressed.
            let newColorBlendFactor: CGFloat = isHighlighted ? 1.0 : 0.0
            let colorBlendAction = SKAction.colorize(withColorBlendFactor: newColorBlendFactor, duration: 0.15)
            
            // Run the two actions at the same time.
            run(SKAction.group([scaleAction, colorBlendAction]))
        }
    }
    
    /**
     Indicates whether the button is currently selected (on or off).
     Most buttons do not support or require selection. In DemoBots,
     selection is used by the screen recorder buttons to indicate whether
     screen recording is turned on or off.
     */
    var isSelected = false {
        didSet {
            // Change the texture based on the current selection state.
            texture = isSelected ? selectedTexture : defaultTexture
        }
    }
    
    /// The texture to use when the button is not selected.
    var defaultTexture: SKTexture?
    
    /// The texture to use when the button is selected.
    var selectedTexture: SKTexture?
    
    // MARK: Initializers
    
    /// Overridden to support `copy(with zone:)`.
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Ensure that the node has a supported button identifier as its name.
        guard let nodeName = name, let buttonIdentifier = ButtonIdentifier(rawValue: nodeName) else {
            fatalError("Unsupported button name found.")
        }
        self.buttonIdentifier = buttonIdentifier
        
        // Remember the button's default texture (taken from its texture in the scene).
        defaultTexture = texture
        
        if let textureName = buttonIdentifier.selectedTextureName {
            // Use a specific selected texture if one is specified for this identifier.
            selectedTexture = SKTexture(imageNamed: textureName)
        }
        else {
            // Otherwise, use the default `texture`.
            selectedTexture = texture
        }
        
        // Enable user interaction on the button node to detect tap and click events.
        isUserInteractionEnabled = true
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let newButton = super.copy(with: zone) as! ButtonNode
        
        // Copy the `ButtonNode` specific properties.
        newButton.buttonIdentifier = buttonIdentifier
        newButton.defaultTexture = defaultTexture?.copy() as? SKTexture
        newButton.selectedTexture = selectedTexture?.copy() as? SKTexture
        
        return newButton
    }
    
    func buttonTriggered() {
        if isUserInteractionEnabled {
            // Forward the button press event through to the responder.
            responder.buttonTriggered(button: self)
        }
    }
    
    // MARK: Responder
    
    /// UIResponder touch handling.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        isHighlighted = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        isHighlighted = false
        
        // Touch up inside behavior.
        if containsTouches(touches: touches) {
            buttonTriggered()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        super.touchesCancelled(touches!, with: event)
        
        isHighlighted = false
    }
    
    /// Determine if any of the touches are within the `ButtonNode`.
    private func containsTouches(touches: Set<UITouch>) -> Bool {
        guard let scene = scene else { fatalError("Button must be used within a scene.") }
        
        return touches.contains { touch in
            let touchPoint = touch.location(in: scene)
            let touchedNode = scene.atPoint(touchPoint)
            return touchedNode === self || touchedNode.inParentHierarchy(self)
        }
    }
}

