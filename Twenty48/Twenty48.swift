//
//  Twenty48.swift
//  Twenty48
//
//  Created by Austin Wu on 12/15/14.
//  Copyright (c) 2014 Austin Wu. All rights reserved.
//

import Foundation

let NumRows = 4
let NumCols = 4

protocol Twenty48Delegate{
    //end of game
    func gameDidEnd(twenty48: Twenty48)
    
    //beginning of game
    func gameDidBegin(twenty48: Twenty48)
    
    //blocks were swiped in one direction
    func blockDidSlide(twenty48: Twenty48, block: Block)
    
    //blocks
    func blockDidCombine(twenty48: Twenty48, block: Block)
}

class Twenty48{
    var blockArray : Array2D<Block>
    var delegate: Twenty48Delegate?

    var score: Int
    
    var randomOpenCell: (col: Int, row: Int) {
        var locations = [(Int,Int)]()
        for var r = 0; r < NumRows; r++ {
            for var c = 0; c < NumCols; c++ {
                if(blockArray[c,r] == nil){
                    locations.append((c,r))
                }
            }
        }
        let randomIndex = Int(arc4random_uniform(UInt32(locations.count)))
        return locations[randomIndex]
    }
    
    var newBlockNumber: Int {
        let diceRoll = Int(arc4random_uniform(2))
        return (2 * (1 + diceRoll))
    }
    
    init(){
        score = 0;
        blockArray = Array2D<Block>(columns: NumCols, rows: NumRows)
    }
    
    func addBlock(){
        var result = randomOpenCell
        var newBlock = Block(col: result.col, row: result.row, number: newBlockNumber)
        blockArray[result.col, result.row] = newBlock
    }
    
    func beginGame(){
        self.addBlock()
        delegate?.gameDidBegin(self)
    }
    
    //take block at loc x,y and move delx,dely
    func slide(delx: Int, dely: Int, x: Int, y: Int){
        if delx + x >= NumCols || delx + x < 0 || dely + y >= NumRows || dely + y < 0{
            return
        }
        
        //maybe instead we need to add all the blocks that move at once to a collection, and then call blockDidSlide on all of them at once, in the same way tetris moves 4 blocks in a shape at once AND THEN does the delay? Instead of one block then delay then one block
        
        var block = blockArray[x,y]
        block?.shiftBy(x, y: dely)
        blockArray[x + delx, y + dely] = block
        delegate?.blockDidSlide(self, block: block!)
        blockArray[x,y] = nil
    }
    
    //take block at loc x,y and combine with block at delx,dely
    func combine(delx: Int, dely: Int, x: Int, y: Int){
        if delx + x >= NumCols || delx + x < 0 || dely + y >= NumRows || dely + y < 0{
            return
        }
        
        var block = blockArray[x,y]
        block?.shiftBy(x, y: dely)
        blockArray[x + delx, y + dely] = block
        delegate?.blockDidCombine(self, block: block!)
        
        blockArray[x + delx, y + dely]?.doubleNum()
        //call double animation
        blockArray[x,y] = nil
    }
    
    func shiftUp(){
        for var c = 0; c < NumCols; c++ {
            for var r = 1; r < NumRows; r++ {
                if blockArray.occupied(c, row: r - 1) && blockArray[c,r - 1]?.number == blockArray[c,r]?.number{
                    combine(0, dely: -1, x: c, y: r)
                } else {
                    slide(0, dely: -1, x: c, y: r)
                }
            }
        }
        addBlock()

    }
    
    func shiftDown(){
        for var c = 0; c < NumCols; c++ {
            for var r = NumRows - 2; r >= 0; r-- {
                if blockArray.occupied(c, row: r + 1) && blockArray[c,r + 1]?.number == blockArray[c,r]?.number{
                    combine(0, dely: 1, x: c, y: r)
                } else {
                    slide(0, dely: 1, x: c, y: r)
                }
            }
        }
        addBlock()
    }
    
    func shiftLeft(){
        for var r = 0; r < NumRows; r++ {
            for var c = 1; c < NumCols; c++ {
                if blockArray.occupied(c - 1, row: r) && blockArray[c - 1,r]?.number == blockArray[c,r]?.number{
                    combine(-1, dely: 0, x: c, y: r)
                } else {
                    slide(-1, dely: 0, x: c, y: r)
                }
            }
        }
        addBlock()
    }
    
    func shiftRight(){
        for var r = 0; r < NumRows; r++ {
            for var c = NumCols - 2; c >= 0; c-- {
                if blockArray.occupied(c + 1, row: r) && blockArray[c + 1,r]?.number == blockArray[c,r]?.number{
                    combine(1, dely: 0, x: c, y: r)
                } else {
                    slide(1, dely: 0, x: c, y: r)
                }
            }
        }
        addBlock()
    }
    
    func endGame(){
        delegate?.gameDidEnd(self)
    }
    
}