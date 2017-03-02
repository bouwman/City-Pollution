//
//  HousesManager.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 02/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

protocol HousesManagerDataSource {
    func housesManager(_ housesManager: HousesManager, citizenForHouse house: HouseEntity) -> CitizenEntity
}

protocol HousesManagerDelegate {
    func housesManager(_ housesManager: HousesManager, didSpawnCitizen citizen: CitizenEntity)
}

class HousesManager {
    var houses: [HouseEntity]
    var spawnInterval: TimeInterval
    var dataSource: HousesManagerDataSource!
    var delegate: HousesManagerDelegate!
    
    private var lastSpawnTime: TimeInterval = 0
    private lazy var randomGen: GKRandomDistribution = GKRandomDistribution(lowestValue: 0, highestValue: self.houses.count - 1)
    
    init(houses: [HouseEntity], spawnInterval: TimeInterval) {
        self.houses = houses
        self.spawnInterval = spawnInterval
    }
    
    func update(totalTime: TimeInterval) {
        let deltaTime = totalTime - lastSpawnTime
        if deltaTime > spawnInterval {
            lastSpawnTime = totalTime
            
            // Pick a random house
            let house = houses[randomGen.nextInt()]
            
            let newCitizen = dataSource.housesManager(self, citizenForHouse: house)
            delegate.housesManager(self, didSpawnCitizen: newCitizen)
        }
    }
}
