//
//  GameScene.swift
//  DrawToMoveExamplee
//
//  Created by Tassilo Bouwman on 06/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import SpriteKit
import GameplayKit

class LevelScene: BaseScene {
    var lastUpdateTimeInterval: TimeInterval = 0
    var totalTimeInterval: TimeInterval = 0
    
    var entityManager: EntityManager!
    var citizenSpawner: HousesManager!
    
    var obstacles = [GKEntity]()
    var buildings = [GKEntity]()
    var houses = [HouseEntity]()
    let player = Player(cityPollutionMax: 200)
    
    var pollutionLabel: SKLabelNode {
        let hud = self.childNode(withName: "hud")
        return hud!.childNode(withName: "pollution") as! SKLabelNode
    }
    var moneyLabel: SKLabelNode {
        let hud = self.childNode(withName: "hud")
        return hud!.childNode(withName: "money") as! SKLabelNode
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        registerForPauseNotifications()
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody?.categoryBitMask = Const.Physics.Category.bounds
        physicsBody?.collisionBitMask = Const.Physics.Collision.none
        
        entityManager = EntityManager(scene: self)
        
        for child in children {
            if let house = child as? HouseNode {
                let entity = HouseEntity(player: player, node: house, maxCapacity: 5)
                houses.append(entity)
                buildings.append(entity)
                obstacles.append(entity)
                entityManager.add(entity)
            } else if let wall = child as? WallNode {
                let entity = WallEntity(node: wall)
                obstacles.append(entity)
            } else if child.name != "park", child.name != "street" {
                child.physicsBody = SKPhysicsBody(rectangleOf: child.frame.size)
                child.physicsBody?.categoryBitMask = Const.Physics.Category.houses
                child.physicsBody?.collisionBitMask = Const.Physics.Collision.all
                child.physicsBody?.allowsRotation = false
                child.physicsBody?.pinned = true
            }
        }
        
        citizenSpawner = HousesManager(houses: houses, spawnInterval: 15)
        citizenSpawner.dataSource = self
        citizenSpawner.delegate = self
        
        addCar()
    }
    
    var firstUpdateTime: TimeInterval = -1
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        // Don't perform any updates if the scene isn't in a view.
        guard view != nil else { return }
        
        if firstUpdateTime < 0 {
            firstUpdateTime = currentTime
        }
        
        let deltaTime = currentTime - lastUpdateTimeInterval
        
        lastUpdateTimeInterval = currentTime
        totalTimeInterval += deltaTime
        
        // spawn citizens
        citizenSpawner.update(totalTime: totalTimeInterval)
        
        // reset city pollution so it can be recalculated each time
        player.cityPollution = 0
        entityManager.update(deltaTime)
        
        // update hud
        pollutionLabel.text = "Pollution: " + player.cityPollution.format(".0")
        moneyLabel.text = "Money: " + player.money.format("00") + " $"
    }
    
    deinit {
        unregisterForPauseNotifications()
    }
    
    private func addCar() {
        let sprite = SKSpriteNode(color: UIColor.black, size: CGSize(width: 40, height: 20))
        let points = [CGPoint(x: -self.size.width / 2 - sprite.size.width, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: self.size.width / 2 + sprite.size.width, y: 0)]
        let car = CarEntity(node: sprite, movePoints: points)
        
        entityManager.add(car)
    }
    
    // MARK: Touches
    
    var movingNode: SKNode?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        if let node = scene?.atPoint(location) {
            if let input = node.entity?.component(ofType: InputComponent.self) {
                movingNode = node
                input.beginTouchAt(point: location)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        if let node = movingNode {
            if let input = node.entity?.component(ofType: InputComponent.self) {
                // TODO: Find old point
                input.moveTouchFrom(fromPoint: location, toPoint: location)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingNode = nil
    }
    
    func nodeAt(touches: Set<UITouch>) -> SKNode? {
        guard let touch = touches.first else {
            return nil
        }
        
        let viewTouchLocation = touch.location(in: self)
        let sceneTouchPoint = scene!.convertPoint(fromView: viewTouchLocation)
        
        return scene?.atPoint(sceneTouchPoint)
    }
    
    // MARK: ButtonNodeResponderType
    
    override func buttonTriggered(button: ButtonNode) {
        switch button.buttonIdentifier! {
        case .pause:
            pause(!isPaused)
        default:
            super.buttonTriggered(button: button)
        }
    }
    
    func pause(_ pause: Bool) {
        isPaused = pause
        isUserInteractionEnabled = !pause
        entityManager.pause(pause)
    }
}

// MARK: - Notifications

extension LevelScene {
    func registerForPauseNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LevelScene.gameWillPause), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    func gameWillPause() {
        pause(true)
    }
    
    func unregisterForPauseNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
}

// MARK: - HousesManagerDataSource

extension LevelScene: HousesManagerDataSource {
    func housesManager(_ housesManager: HousesManager, citizenForHouse house: HouseEntity) -> CitizenEntity {
        let houseSprite = house.renderComponent.node as! HouseNode
        let sprite = SKSpriteNode(imageNamed: "citizen")
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.height / 2)
        sprite.position = houseSprite.doorPosition
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        
        let citizen = CitizenEntity(player: player, healthIncreaseFactor: 0.3, healthDecreaseFactor: 1.0, node: sprite, possibleDestinations: houses, destinationChildNodeName: Const.Nodes.Houses.door, obstacles: obstacles)
        citizen.delegate = entityManager
        
        return citizen
    }
}

// MARK: - HousesManagerDelegate

extension LevelScene: HousesManagerDelegate {
    func housesManager(_ housesManager: HousesManager, didSpawnCitizen citizen: CitizenEntity) {
        // Make citizen move away from door
        if let pathComponent = citizen.component(ofType: PathComponent.self) {
            pathComponent.clearMovingPoints()
            
            let sprite = citizen.renderComponent.node as! SKSpriteNode
            let firstPoint = sprite.position
            let secondPoint = CGPoint(x: firstPoint.x, y: firstPoint.y - sprite.size.height - 10)
            
            pathComponent.addMovingPoint(point: firstPoint)
            pathComponent.addMovingPoint(point: secondPoint)
        }
        
        entityManager.add(citizen)
    }
}
