//
//  WallEntity.swift
//  CityPollution
//
//  Created by Tassilo Bouwman on 12/02/2017.
//  Copyright © 2017 Tassilo Bouwman. All rights reserved.
//

import GameplayKit

class WallEntity: GKEntity {
    init(node: SKNode) {
        super.init()
                
        let render = GKSKNodeComponent(node: node)
        let collision = CollisionComponent(node: node, category: Const.Physics.Category.bounds, pinned: true)
        
        addComponent(collision)
        addComponent(render)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
