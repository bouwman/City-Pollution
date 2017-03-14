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
    var citizenSpawnInterval: TimeInterval
    var pollutionWinLevel: Double
    var supportLoseLevel: Double
}

class LevelManager: CitizenEntityDelegate {
    unowned let scene: LevelScene
    let configuration: LevelConfiguration
    
    var money: Double = 0
    var citizenCount: Int
    var cityPollutionAbs: Double = 0
    var cityPollutionMax: Double {
        return configuration.pollutionIndustry + configuration.pollutionLight + configuration.pollutionTransport
    }
    
    var cityPollutionRel: Double {
        return cityPollutionAbs / cityPollutionMax
    }
    
    init(scene: LevelScene, configuration: LevelConfiguration) {
        self.scene = scene
        self.configuration = configuration
        self.citizenCount = configuration.citizenCount
    }
    
    // MARK: - CitizenEntityDelegate
    
    func citizenEnitityDidArriveAtDestination(citizen: CitizenEntity) {
        if let healthComponent = citizen.component(ofType: HealthComponent.self) {
            let earnings = earningsOrLossFor(citizenHealth: healthComponent.curHealthPercent)
            money += earnings
            
            if let event = citizen.component(ofType: EventComponent.self) {
                event.nextEventToTrigger = .affectMoney(earnings)
            }
        }
        NotificationCenter.default.post(.arriveAtHouse)
        
        scene.entityManager.remove(citizen)
    }
    
    func citizenEnitityDidDie(citizen: CitizenEntity) {        
        let earnings = earningsOrLossFor(citizenHealth: 0)
        
        money += earnings
        citizenCount -= 1
        
        if let event = citizen.component(ofType: EventComponent.self) {
            event.nextEventToTrigger = .citizenDied(earnings)
        }
        
        scene.entityManager.remove(citizen)
    }
    
    func earningsOrLossFor(citizenHealth: Double) -> Double {
        switch citizenHealth {
        case 0:
            return -500
        case 0..<Const.Citizens.earnRangeNormal.lowerBound:
            return 0
        case Const.Citizens.earnRangeNormal:
            return 100
        case Const.Citizens.earnRangePerfect:
            return 200
        default:
            fatalError("health level out of bounce")
        }
    }
}
