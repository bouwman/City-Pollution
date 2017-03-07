//
//  LevelManager.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 06/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

struct LevelConfiguration {
    var pollutionIndustry: Double
    var pollutionLight: Double
    var pollutionTransport: Double
    var citizenCount: Int
}

class LevelManager: CitizenEntityDelegate {
    let scene: LevelScene
    let configuration: LevelConfiguration
    
    var money: Double = 0
    
    var cityPollution: Double = 1
    var cityPollutionMax: Double {
        return configuration.pollutionIndustry + configuration.pollutionLight + configuration.pollutionTransport
    }
    
    init(scene: LevelScene, configuration: LevelConfiguration) {
        self.scene = scene
        self.configuration = configuration
    }
    
    // MARK: - CitizenEntityDelegate
    
    func citizenEnitityDidArriveAtDestination(citizen: CitizenEntity) {
        if let healthComponent = citizen.component(ofType: HealthComponent.self) {
            money += earningsOrLossFor(citizenHealth: healthComponent.curHealthPercent)
            SoundManager.sharedInstance.playSound(.coin, inScene: scene)
        }
        
        scene.entityManager.remove(citizen)
    }
    
    func citizenEnitityDidDie(citizen: CitizenEntity) {
        SoundManager.sharedInstance.playSound(.overrun, inScene: scene)
        money += earningsOrLossFor(citizenHealth: 0)
        scene.entityManager.remove(citizen)
    }
    
    func earningsOrLossFor(citizenHealth: Double) -> Double {
        if citizenHealth > Const.Citizens.startHealthPercent {
            return pow((citizenHealth - Const.Citizens.startHealthPercent + 1) * Const.Citizens.minEarning, 2)
        } else {
            return -pow((Const.Citizens.startHealthPercent - citizenHealth + 1) * Const.Citizens.minEarning, 2)
        }
    }
}
