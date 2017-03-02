//
//  Constants.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 12/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import Foundation

struct Const {
    struct Physics {
        struct Category {
            static let citizens: UInt32 =   0x0000F000
            static let cars: UInt32 =       0x00000F00
            static let houses: UInt32 =     0x000000F0
            static let bounds: UInt32 =     0x0000000F
            static let none: UInt32 =       0x00000000
        }
        struct Collision {
            static let all: UInt32 = Category.citizens | Category.cars | Category.houses | Category.bounds
            static let cars: UInt32 = Category.citizens | Category.cars
            static let none: UInt32 = 0x00000000
        }
    }
    struct Nodes {
        static let healthBar = "health bar"
        struct Houses {
            static let door = "door"
        }
    }
}
