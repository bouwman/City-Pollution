//
//  LightComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 26/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class LightComponent: GKComponent {
    let maxLightCount: Int
    let turnOnTimeRange: ClosedRange<Int>
    
    var curLightCount: Int = 0 {
        didSet {
            if curLightCount > maxLightCount {
                curLightCount = maxLightCount
            } else if curLightCount < 0 {
                curLightCount = 0
            }
        }
    }
    
    private var totalTime: TimeInterval = 0
    private var lastLightTurnOn: TimeInterval = 0
    private var nextTurnOn: TimeInterval = 0
    
    init(maxLightCount: Int, turnOnTimeRange: ClosedRange<Int>) {
        self.maxLightCount = maxLightCount
        self.turnOnTimeRange = turnOnTimeRange
        
        super.init()
        
        self.nextTurnOn = TimeInterval(randomGen.nextInt())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var randomGen: GKRandomDistribution = GKRandomDistribution(lowestValue: self.turnOnTimeRange.lowerBound, highestValue: self.turnOnTimeRange.upperBound)
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        // !!!: ios bug?
        guard seconds < 141900.0 else { return }
        
        guard curLightCount < maxLightCount else { return }
        guard let contaminator = entity!.component(ofType: ContaminatorComponent.self) else { return }
        guard let houseNode = entity!.component(ofType: GKSKNodeComponent.self)?.node as? HouseNode else { return }
        
        totalTime += seconds
        
        let deltaTime = totalTime - lastLightTurnOn
        if deltaTime > nextTurnOn {
            lastLightTurnOn = totalTime
            nextTurnOn = TimeInterval(randomGen.nextInt())
            curLightCount += 1
        }
        
        var displayedLights = 0
        for window in houseNode.windows {
            if displayedLights < curLightCount {
                window.lightOn = true
                displayedLights += 1
            } else {
                window.lightOn = false
            }
        }
        
        contaminator.factor = Double(curLightCount)
    }
}
