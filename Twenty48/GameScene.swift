//
//  GameScene.swift
//  Twenty48
//
//  Created by Austin Wu on 12/15/14.
//  Copyright (c) 2014 Austin Wu. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene {
    
    let gameLayer = SKNode()
    let blockLayer = SKNode()
    
    override init(size: CGSize){
        super.init(size: size)

        anchorPoint = CGPoint(x: 0.0, y: 1.0)
        
        let background = SKSpriteNode(texture: SKTexture(imageNamed: "Board Background"), size: CGSize(width: 375, height: 375))
        background.position = CGPoint(x: 0, y: -146)
        background.anchorPoint = CGPoint(x: 0, y: 1.0)
        addChild(background)

        /**

        for var y = 0; y < 4; y++ {
            for var x = 0; x < 4; x++ {
                SKSpriteNode square =
                CGPoint squareCoordinate = CGPointMake(x, y);
                squareNode.position = [_squareSystemCoord tileCenter:squareCoordinate];
                squareNode.texture = _textureNormal;
                [self addChild:squareNode];
            }
        }
        */
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /**
    Next layer: 4x4 grid of squares (gamelayer)
    Next layer: each individual block (blockLayer)
    
    //first goal: render grid on open
    //second goal: render grid with initial square on open
    */
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
