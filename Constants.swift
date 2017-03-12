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
        static let destination = "destination"
        static let destinationSetZone = "destination set zone"
        static let regenerationZone = "regeneration zone"
        static let house = "house"
        static let upgrade = "upgrade"
        
        struct Houses {
            static let capacity = "capacity"
        }
        struct Layers {
            static let top = "top"
            static let hud = "hud"
            static let aboveCharacters = "above characters"
            static let characters = "characters"
            static let buildings = "buildings"
            static let board = "board"
        }
    }
    struct Citizens {
        static let minEarning = 10.0
        static let yDistanceAfterSpawn = CGFloat(0.0)
        static let startHealthPercent = 0.5
        static let healthIncreaseBase = 0.001
        static let healthDecreaseBase = 0.0003
        static let healthBarDistance = CGFloat(6.0)
        static let healthBarHeight = CGFloat(5.0)
        static let healthBarColor = UIColor.green
        static let greenRange = 0.8...1.0
        static let yellowRange = 0.3..<0.8
        static let redRange = 0..<0.3
        static let earnRangeNormal = 0.5..<Citizens.greenRange.lowerBound
        static let earnRangePerfect = Citizens.greenRange
        
        struct TypesFactors {
            static let normal = 1.0
            static let child =  1.3
            static let old =    1.6
            static let asthma = 1.9
        }
    }
    struct Fonts {
        static let medium = "Helvetica Neue Medium"
        static let bold = "Helvetica Neue Bold"
        struct Size {
            static let small: CGFloat = 12.0
            static let medium: CGFloat = 18.0
            static let large: CGFloat = 30.0
        }
    }
}

enum WorldLayer: CGFloat {
    case board = -100, buildings = -25, characters = 0, aboveCharacters = 1000, hud = 1100, top = 1200
}
