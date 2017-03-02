//
//  CapacityComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 10/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class CapacityComponent: GKComponent {
    var isNotFull: Bool {
        return curCapacity < maxCapacity
    }
    
    var curCapacity: Int = 0
    var maxCapacity: Int
    
    init(maxCapacity: Int) {
        self.maxCapacity = maxCapacity
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
