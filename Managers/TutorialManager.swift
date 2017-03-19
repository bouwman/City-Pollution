//
//  TutorialManager.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 13/03/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import Foundation

class TutorialManager: NSObject {
    var levelScene: LevelScene
    var currentStep: String?
    var currentStepImageName: String?
    
    var isActive = true {
        didSet {
            if isActive == false {
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    
    init(levelScene: LevelScene) {
        self.levelScene = levelScene
        super.init()
        
        NotificationCenter.default.add(self, selector: #selector(TutorialManager.didReceiveSpawnCitizenNotification), notification: .spawnCitizen)
        
        currentStep = "Welcome to London!\n\nCurrently diesel vehicles and indoor pollution contribute to illegally high levels of NO2.  Inhaling NO2 is similar to breathing in tar. It inflames the lungs and increases the risk of stroke, heart attack, asthma and lung cancer. An estimated 40,000 people die prematurely from NO2 pollution in the UK each year."
        currentStepImageName = "london intro background"
    }
    
    func didReceiveSpawnCitizenNotification() {
        currentStepImageName = nil
        
        NotificationCenter.default.remove(self, forNotification: .spawnCitizen)
        
        // Listen for next step
        NotificationCenter.default.add(self, selector: #selector(TutorialManager.didReceiveArriveAtParkNotification), notification: .arriveAtPark)
        
        currentStep = "Your healthy citizen needs time in the park to increase vitality.\n\nDraw a line to show the way but beware of polluting cars!"
        currentStepImageName = "tutorial draw a line"
        levelScene.stateMachine.enter(LevelSceneInstructionsState.self)
    }
    
    func didReceiveArriveAtParkNotification() {
        NotificationCenter.default.remove(self, forNotification: .arriveAtPark)
        
        // Listen for next step
        NotificationCenter.default.add(self, selector: #selector(TutorialManager.didReceiveTurnOnLightNotification), notification: .turnOnLight)
        NotificationCenter.default.add(self, selector: #selector(TutorialManager.didReceiveReachMaxHealthNotification), notification: .reachMaxHealth)
        
        currentStep = "Good job!  Your healthy citizen can now enjoy a short time outside.\n\nDon’t forget to bring others to the park to join."
        currentStepImageName = "tutorial regenerating"
        levelScene.stateMachine.enter(LevelSceneInstructionsState.self)
    }
    
    func didReceiveTurnOnLightNotification() {
        NotificationCenter.default.remove(self, forNotification: .turnOnLight)
        
        currentStep = "Oh, someone left their light on. Reduce pollution levels by tapping a house to turn the lights off and save energy."
        currentStepImageName = "tutorial turn off light"
        levelScene.stateMachine.enter(LevelSceneInstructionsState.self)
    }
    
    func didReceiveReachMaxHealthNotification() {
        NotificationCenter.default.remove(self, forNotification: .reachMaxHealth)
        
        // Listen for next step
        NotificationCenter.default.add(self, selector: #selector(TutorialManager.didReceiveArriveAtHouseNotification), notification: .arriveAtHouse)
        
        currentStep = "Earn support by drawing a line to guide your citizen back home, the line should turn blue.\n\nMake sure the home isn’t already full."
        currentStepImageName = "tutorial send back"
        levelScene.stateMachine.enter(LevelSceneInstructionsState.self)
    }
    
    func didReceiveArriveAtHouseNotification() {
        isActive = false
        
        NotificationCenter.default.remove(self, forNotification: .arriveAtHouse)
        
        currentStep = "Great! Once you have enough, you can use your support to cut down pollution by upgrading factories and cars.\n\nGood luck saving the city!"
        currentStepImageName = nil
        levelScene.stateMachine.enter(LevelSceneInstructionsState.self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
