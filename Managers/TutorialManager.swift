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
        
        currentStep = "Welcome to London!\n\nIn 1952 the “great smog” resulted in 4,000 deaths in a matter of days.  Currently diesel vehicles and indoor pollution contribute to illegally high levels of no2. \nInhaling No2 is similar to breathing in tar. It inflames the lungs and increases the chances of strokes, heart attacks, asthma, and lung cancer. An estimated 40,000 people across the uk die prematurely from noz pollution each year."
        currentStepImageName = "london intro background"
    }
    
    func didReceiveSpawnCitizenNotification() {
        currentStepImageName = nil
        
        NotificationCenter.default.remove(self, forNotification: .spawnCitizen)
        
        // Listen for next step
        NotificationCenter.default.add(self, selector: #selector(TutorialManager.didReceiveArriveAtParkNotification), notification: .arriveAtPark)
        
        currentStep = "The citizen wants some fresh air. Move him to the park. The air quality is really bad though. Make sure your citizens do not die on their way to the park."
        levelScene.stateMachine.enter(LevelSceneInstructionsState.self)
    }
    
    func didReceiveArriveAtParkNotification() {
        NotificationCenter.default.remove(self, forNotification: .arriveAtPark)
        
        // Listen for next step
        NotificationCenter.default.add(self, selector: #selector(TutorialManager.didReceiveTurnOnLightNotification), notification: .turnOnLight)
        NotificationCenter.default.add(self, selector: #selector(TutorialManager.didReceiveReachMaxHealthNotification), notification: .reachMaxHealth)
        
        currentStep = "Good job! Wait for the citizen to regenerate. Don't forget to take care of the other citizens."
        levelScene.stateMachine.enter(LevelSceneInstructionsState.self)
    }
    
    func didReceiveTurnOnLightNotification() {
        NotificationCenter.default.remove(self, forNotification: .turnOnLight)
        
        currentStep = "Oh, someone left their light on. Turn it off to reduce the pollution. You see the current pollution level in the top left corner. The pollution level is also reflected by the color of the ground."
        levelScene.stateMachine.enter(LevelSceneInstructionsState.self)
    }
    
    func didReceiveReachMaxHealthNotification() {
        NotificationCenter.default.remove(self, forNotification: .reachMaxHealth)
        
        // Listen for next step
        NotificationCenter.default.add(self, selector: #selector(TutorialManager.didReceiveArriveAtHouseNotification), notification: .arriveAtHouse)
        
        currentStep = "Move back the citizen back to earn support. The numbers above the house reflect the capacity of the house. You can only move citizens into houses that have some capactity left."
        levelScene.stateMachine.enter(LevelSceneInstructionsState.self)
    }
    
    func didReceiveArriveAtHouseNotification() {
        isActive = false
        
        NotificationCenter.default.remove(self, forNotification: .arriveAtHouse)
        
        currentStep = "Great! You earned some support. When you have earned enough support you can upgrade the factories and the car to reduce the pollution even further. Good luck saving the city!"
        levelScene.stateMachine.enter(LevelSceneInstructionsState.self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
