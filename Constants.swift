//
//  Constants.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 12/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import UIKit

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
            static let capacity = "capacity"
        }
    }
}

enum WorldLayer: CGFloat {
    case board = -100, debug = -75, shadows = -50, obstacles = -25, characters = 0, aboveCharacters = 1000, top = 1100
}
