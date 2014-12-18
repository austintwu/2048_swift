//
//  GameScene.swift
//  Twenty48
//
//  Created by Austin Wu on 12/15/14.
//  Copyright (c) 2014 Austin Wu. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

let distanceFromBottom = 146

let BorderLength = 15
var SquareSize: Int{
    return ((375-(5 * BorderLength))/4)
}

class GameScene: SKScene {
    
    var blockLayer = SKNode()
    var textureCache = Dictionary<Int, SKTexture>()
    
    /**
    Default anchor point is .5, .5
    Default position is 0,0
    Anchor point determins which part of frame will be anchored at point position in parent node, with 0,0 or parent node starting at the bottom left no matter what
    */
    
    override init(size: CGSize){
        super.init(size: size)
        
        var background = SKSpriteNode(texture: SKTexture(imageNamed: "Game Background"), size: CGSize(width: 375, height: 667))
        background.anchorPoint = CGPoint(x: 0, y: 0)
        addChild(background)
        
        var board = SKSpriteNode(texture: SKTexture(imageNamed: "Board Background"), size: CGSize(width: 375, height: 375))
        board.position = CGPoint(x: 0, y: distanceFromBottom)
        board.anchorPoint = CGPoint(x: 0, y: 0)

        for var r = 0; r < 4; r++ {
            for var c = 0; c < 4; c++ {
                
                let square = SKSpriteNode(texture: SKTexture(imageNamed: "Tile Background"), size: CGSize(width: SquareSize, height: SquareSize))
                square.position = blockPosition(c, row:r)
                square.anchorPoint = CGPoint(x: 0, y: 0)
                board.addChild(square)
                
            }
        }
        board.addChild(blockLayer)
        addChild(board)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func renderNewBlock(block: Block) {
        var texture = textureCache[block.number]
        if texture == nil {
            texture = SKTexture(imageNamed: String(block.number))
            textureCache[block.number] = texture
        }
        let sprite = SKSpriteNode(texture: texture, size: CGSize(width: SquareSize, height: SquareSize))
        sprite.position = blockPosition(block.col, row: block.row)
        sprite.anchorPoint = CGPoint(x: 0, y: 0)
        
        let label = SKLabelNode(text: "\(block.number)")
        
        label.fontName = "Clear Sans"
        label.fontSize = 50
        if(block.number < 5){
            label.fontColor = UIColor.blackColor()
        } else {
            label.fontColor = UIColor.whiteColor()
        }
        label.position = CGPoint(x: SquareSize / 2, y: SquareSize / 2)
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        sprite.addChild(label)
        blockLayer.addChild(sprite)
        
        block.spriteLabel = label
        block.sprite = sprite
    }
    
    func updateBlockSprite(block: Block) {
        let sprite = block.sprite!
        let moveTo = blockPosition(block.col, row: block.row)
        let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.2)
        moveToAction.timingMode = .EaseOut
        sprite.runAction(
            SKAction.group([moveToAction, SKAction.fadeAlphaTo(1.0, duration: 0.2)]))
    }
    
    func blockPosition(col: Int, row: Int) -> CGPoint {
        var x = BorderLength + (SquareSize + BorderLength) * col
        var y = BorderLength + (SquareSize + BorderLength) * row
        return CGPoint(x: x, y: y)
    }
    
    func drawBoard(twenty48: Twenty48) {
        for (idx, block) in enumerate(twenty48.blockArray.array){
            
        }
    }
    
    
    /**
    Next layer: 4x4 grid of squares (gamelayer)
    Next layer: each individual block (blockLayer)
    
    //second goal: render grid with initial square on open
    third goal: render grid before/after. forget animations for now
    */
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
