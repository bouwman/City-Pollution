//
//  PathComponent.swift
//  DrawToMoveExamplee
//
//  Created by Tassilo Bouwman on 08/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class PathComponent: GKComponent {

    var wayPoints: [CGPoint] = []
    
    func addMovingPoint(point: CGPoint) {
        wayPoints.append(point)
    }
    
    func clearMovingPoints() {
        wayPoints = []
    }
}
