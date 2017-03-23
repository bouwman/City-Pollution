//
//  HousesManager.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 02/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

protocol HousesManagerDataSource {
    func housesManager(_ housesManager: HousesManager, citizenForHouse house: HouseEntity, type: CitizenType) -> CitizenEntity
}

protocol HousesManagerDelegate {
    func housesManager(_ housesManager: HousesManager, didSpawnCitizen citizen: CitizenEntity)
}

class HousesManager {
    var houses: [HouseEntity]
    var spawnInterval: TimeInterval
    var dataSource: HousesManagerDataSource!
    var delegate: HousesManagerDelegate!
    var spawnCountLevelUp: Int
    var lastSpawnedType: CitizenType
    
    private var lastSpawnTime: TimeInterval = 0
    private var citizenSpawnCount = 0
    private var currentLevel = 0
    private var levelTypes: [CitizenType] = [.normal, .old]
    private var waitToSpawnFirstCitizen = 3.0
    
    init(houses: [HouseEntity], spawnInterval: TimeInterval, spawnCountLevelUp: Int) {
        self.houses = houses
        self.spawnInterval = spawnInterval
        self.spawnCountLevelUp = spawnCountLevelUp
        self.lastSpawnedType = levelTypes.first!
    }
    
    func update(totalTime: TimeInterval) {
        let deltaTime = totalTime - lastSpawnTime
        let isAboveFirstSpawnTime = waitToSpawnFirstCitizen > 0 && deltaTime > waitToSpawnFirstCitizen
        let isAboveSpawnInterval = deltaTime > spawnInterval
        
        guard isAboveSpawnInterval || isAboveFirstSpawnTime else { return }
        let freeHouses = houses.filter({ (house) -> Bool in
            return house.capacityComponent.isNotEmpty
        })
        
        guard freeHouses.count > 0 else { return }
        
        var type = lastSpawnedType
        if citizenSpawnCount >= spawnCountLevelUp {
            citizenSpawnCount = 0
            currentLevel += 1
            type = nextType()
            NotificationCenter.default.post(.spawnNewCitizenType)
        }
        
        // Pick random house
        let randomGen = GKRandomDistribution(lowestValue: 0, highestValue: freeHouses.count - 1)
        let houseToSpawnFrom = freeHouses[randomGen.nextInt()]
        let newCitizen = dataSource.housesManager(self, citizenForHouse: houseToSpawnFrom, type: type)
        
        houseToSpawnFrom.capacityComponent.curCapacity -= 1
        
        citizenSpawnCount += 1
        lastSpawnTime = totalTime
        waitToSpawnFirstCitizen = -1
        
        NotificationCenter.default.post(.spawnCitizen)
        delegate.housesManager(self, didSpawnCitizen: newCitizen)
    }
    
    var wasFirst = true
    
    // TODO: Enhance
    private func nextType() -> CitizenType {
        let type: CitizenType
        if currentLevel > 0 {
            if wasFirst {
                type = levelTypes[1]
            } else {
                type = levelTypes[0]
            }
            wasFirst = !wasFirst
        } else {
            type = levelTypes.first!
        }
        lastSpawnedType = type
        
        return type
    }
}
