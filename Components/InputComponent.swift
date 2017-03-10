//
//  InputComponent.swift
//  DrawToMoveExamplee
//
//  Created by Tassilo Bouwman on 07/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

protocol InputDelegate {
    func beginTouchAt(point: CGPoint)
    func moveTouchFrom(fromPoint: CGPoint, toPoint: CGPoint)
    func endTouchAt(point: CGPoint)
}

class InputComponent: GKComponent, InputDelegate {

    func beginTouchAt(point: CGPoint) {
        guard let entity = entity else { return }

        
        if let pathComponent = entity.component(ofType: PathComponent.self) {
            pathComponent.clearMovingPoints()
            pathComponent.addMovingPoint(point: point)
        }
        if let destinationComponent = entity.component(ofType: DestinationComponent.self) {
            destinationComponent.destination = nil
        }
        if let lightComponent = entity.component(ofType: LightComponent.self) {
            if lightComponent.curLightCount != 0 {
                lightComponent.curLightCount -= 1
                SoundManager.sharedInstance.playSound(.click)
            }
        }
        if let upgradeComponent = entity.component(ofType: UpgradeComponent.self) {
            upgradeComponent.tryToUpgrade()
        }
    }
    
    func moveTouchFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        if let destinationComponent = entity?.component(ofType: DestinationComponent.self) {
            if destinationComponent.destination == nil {
                if let pathComponent = entity?.component(ofType: PathComponent.self) {
                    pathComponent.addMovingPoint(point: toPoint)
                }
            }
            destinationComponent.setDestinationBasedOn(point: toPoint)
        }
    }
    
    func endTouchAt(point: CGPoint) {
        
    }
}
