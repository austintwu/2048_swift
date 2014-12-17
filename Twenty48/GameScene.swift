//
//  GameScene.swift
//  Twenty48
//
//  Created by Austin Wu on 12/15/14.
//  Copyright (c) 2014 Austin Wu. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let gameLayer = SKNode()
    let blockLayer = SKNode()
    
    /**
    Background layer: Flat background, get color from game online
    Next layer: 4x4 grid of squares (gamelayer)
    Next layer: each individual block (blockLayer)
    
    //first goal: render grid on open
    //second goal: render grid with initial square on open
    */
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
