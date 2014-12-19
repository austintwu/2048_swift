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

let distanceFromBottom = 70

let BorderLength = 15
let BoardSize = 345
var SquareSize: Int{
    return ((BoardSize-(5 * BorderLength))/4)
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
        
        var board = SKSpriteNode(texture: SKTexture(imageNamed: "Board Background"), size: CGSize(width: BoardSize, height: BoardSize))
        board.position = CGPoint(x: (375 - BoardSize) / 2, y: distanceFromBottom + (375 - BoardSize) / 2)
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
        
        label.fontName = "Apple SD Gothic Neo"
        label.fontSize = 50
        label.fontColor = UIColor(red: 0.39, green: 0.35, blue: 0.19, alpha: 1.0)
        label.position = CGPoint(x: SquareSize / 2, y: SquareSize / 2)
        label.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        
        sprite.addChild(label)
        
        sprite.alpha = 0.0
        let fadeInAction = SKAction.fadeInWithDuration(0.6)
        fadeInAction.timingMode = .EaseOut
        sprite.runAction(fadeInAction)
        blockLayer.addChild(sprite)
        
        block.spriteLabel = label
        block.sprite = sprite
    }
    
    func updateBlockSpriteMove(block: Block) {
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
    
    func updateBlockCombining(movedBlock: Block, doubledBlock: Block){
        let sprite1 = movedBlock.sprite!
        let moveTo = blockPosition(movedBlock.col, row: movedBlock.row)
        let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.2)
        moveToAction.timingMode = .EaseOut
        sprite1.runAction(
            SKAction.group([moveToAction, SKAction.fadeAlphaTo(1.0, duration: 0.2)]))
        
        sprite1.removeFromParent()
        
        let label = doubledBlock.spriteLabel!
        label.text = "\(doubledBlock.number)"
        
        let sprite2 = doubledBlock.sprite!
        var texture = textureCache[doubledBlock.number]
        if texture == nil {
            texture = SKTexture(imageNamed: String(doubledBlock.number))
            textureCache[doubledBlock.number] = texture
        }
        
        sprite2.texture = texture
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
