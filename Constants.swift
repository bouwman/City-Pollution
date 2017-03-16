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
        static let instructionsBackground = "resume"
        static let contaminatorEmitter = "contaminator emitter"
        
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
        static let healthDecreaseBase = 0.0005
        static let healthBarDistance = CGFloat(6.0)
        static let healthBarHeight = CGFloat(5.0)
        static let healthBarColor = UIColor.green
        static let greenRange = 0.8..<1.01
        static let yellowRange = 0.3..<0.8
        static let redRange = 0..<0.3
        static let earnRangeNormal = 0.5..<Citizens.greenRange.lowerBound
        static let earnRangePerfect = Citizens.greenRange
        
        struct Sprites {
            static let yellow = "citizen yellow"
            static let green = "citizen green"
            static let red = "citizen red"
        }
        
        struct TypesFactors {
            static let normal = 1.0
            static let child =  1.3
            static let old =    1.2
            static let asthma = 1.4
        }
        
        struct Intros {
            // TODO: Fix!!
            static let normal = "My wife passed away 5 years ago. After that I didn’t really leave the house.  Then one day I went to the park. That’s when I saw Lily. She was beautiful. I didn’t know what to say so I picked a flower and handed it to her.  She smiled. I’ve been meeting her with a flower in the park every day since."
            static let child = "My favorite player is Messi.  When I grow up I want to be just like him.  I can’t wear his jersey to school so mom bought me yellow tape and put 10’s on my shirts instead. I used to play forward like he does. I was really fast. But now i’m not allowed to because the air makes my asthma bad."
            static let old = "My wife passed away 5 years ago. After that I didn’t really leave the house.  Then one day I went to the park. That’s when I saw Lily. She was beautiful. I didn’t know what to say so I picked a flower and handed it to her.  She smiled. I’ve been meeting her with a flower in the park every day since."
            static let asthma = "no intro yet"
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
    struct Notifications {
        static let arriveAtPark = "arrive at park"
        static let reachMaxHealth = "reach max health"
        static let arriveAtHouse = "arrive at house"
    }
}

enum WorldLayer: CGFloat {
    case board = -100, buildings = -25, characters = 0, aboveCharacters = 1000, hud = 1100, top = 1200
}

enum NotificationType: String {
    case spawnCitizen
    case spawnNewCitizenType
    case arriveAtPark
    case turnOnLight
    case reachMaxHealth
    case arriveAtHouse
}

extension NotificationCenter {
    func post(_ notification: NotificationType) {
        self.post(name: Notification.Name(rawValue: notification.rawValue), object: nil)
    }
    
    func add(_ observer: Any, selector: Selector, notification: NotificationType) {
        self.addObserver(observer, selector: selector, name: Notification.Name(rawValue: notification.rawValue), object: nil)
    }
    
    func remove(_ observer: Any, forNotification notification: NotificationType) {
        self.removeObserver(observer, name: Notification.Name(rawValue: notification.rawValue), object: nil)
    }
}
