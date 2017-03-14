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
    
    init(houses: [HouseEntity], spawnInterval: TimeInterval) {
        self.houses = houses
        self.spawnInterval = spawnInterval
    }
    
    func update(totalTime: TimeInterval) {
        let deltaTime = totalTime - lastSpawnTime
        if deltaTime > spawnInterval {
            let freeHouses = houses.filter({ (house) -> Bool in
                return house.capacityComponent.isNotEmpty
            })
            
            guard freeHouses.count > 0 else { return }

            let randomGen = GKRandomDistribution(lowestValue: 0, highestValue: freeHouses.count - 1)
            let houseToSpawnFrom = freeHouses[randomGen.nextInt()]
            let newCitizen = dataSource.housesManager(self, citizenForHouse: houseToSpawnFrom)
            
            houseToSpawnFrom.capacityComponent.curCapacity -= 1
            
            lastSpawnTime = totalTime
            
            NotificationCenter.default.post(.spawnCitizen)
            delegate.housesManager(self, didSpawnCitizen: newCitizen)
        }
    }
}
