//
//  StateComponent.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 12/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class StateComponent: GKComponent {
    
    let stateMachine: GKStateMachine
    let initialStateClass: AnyClass
    
    init(states: [GKState]) {
        stateMachine = GKStateMachine(states: states)
        
        let firstState = states.first!
        initialStateClass = type(of: firstState)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        stateMachine.update(deltaTime: seconds)
    }
    
    func enterInitialState() {
        stateMachine.enter(initialStateClass)
    }
}
