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
        
        guard let renderComponent = entity?.component(ofType: GKSKNodeComponent.self) else { return }
        guard let capacityLabel = renderComponent.node.childNode(withName: Const.Nodes.Houses.capacity) as? SKLabelNode else { return }
        
        capacityLabel.text = "\(curCapacity)/\(maxCapacity)"
    }
}
