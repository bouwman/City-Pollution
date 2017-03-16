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
    
    var isNotEmpty: Bool {
        return curCapacity != 0
    }
    
    var curCapacity: Int
    var maxCapacity: Int
    
    private lazy var renderComponent: GKSKNodeComponent? = {
        self.entity?.component(ofType: GKSKNodeComponent.self)
    }()
    
    private lazy var capacityLabel: SKLabelNode? = {
        self.renderComponent?.node.childNode(withName: Const.Nodes.Houses.capacity) as? SKLabelNode
    }()
    
    init(maxCapacity: Int) {
        self.maxCapacity = maxCapacity
        self.curCapacity = maxCapacity
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        capacityLabel?.text = "\(curCapacity)/\(maxCapacity)"
    }
}
