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
    func gameDidBegin(twenty48: Twenty48, firstblock: Block)
    
    //a block moved without combining
    func blockDidSlide(twenty48: Twenty48, block: Block)
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
    
    // adds a new block to an open cell having either 2 or 4
    func addBlock() -> Block {
        var result = randomOpenCell
        var newBlock = Block(col: result.col, row: result.row, number: newBlockNumber)
        blockArray[result.col, result.row] = newBlock
        return newBlock
    }
    
    func testAddBlock() -> Block {
        var newBlock = Block(col: 0, row: 0, number: 2)
        blockArray[0, 0] = newBlock
        return newBlock
    }
    
    func beginGame(){
        var block = self.testAddBlock()
        delegate?.gameDidBegin(self, firstblock: block)
    }
    
    // take block at loc x,y and move in delx dely direction
    func slide(delx: Int, dely: Int, x: Int, y: Int){
        if blockArray[x,y] == nil {
            return
        }
        
        var loc = (col: x, row: y)
        var goloc = (col: x, row: y)
        
        while isValid(loc.col, row: loc.row) {
            if blockArray[loc.col, loc.row] == nil {
                goloc = loc
            }
            loc.col += delx
            loc.row += dely
        }
        
        var testloc = (col: goloc.col + delx, row: goloc.row + dely)
        if isValid(testloc.col, row: testloc.row) {
            if blockArray[testloc.col, testloc.row]?.number == blockArray[x,y]?.number{
                blockArray[testloc.col, testloc.row]?.doubleNum()
                blockArray[testloc.col, testloc.row]?.didCombine()
                blockArray[x, y] = nil
                return
            }
        }
        var block = blockArray[x,y]
        block?.setLocation(goloc.col, y: goloc.row)
        blockArray[goloc.col, goloc.row] = block
        blockArray[x,y] = nil
        delegate?.blockDidSlide(self, block: block!)
        
        //maybe instead we need to add all the blocks that move at once to a collection, and then call blockDidSlide on all of them at once, in the same way tetris moves 4 blocks in a shape at once AND THEN does the delay? Instead of one block then delay then one block
    }
    
    func isValid(col: Int, row: Int) -> Bool {
        return col >= 0 && col < 4 && row >= 0 && row < 4
    }
    
    func swipeUp(){
        for var c = 0; c < NumCols; c++ {
            for var r = NumRows - 2; r >= 0; r-- {
                slide(0, dely: 1, x: c, y: r)
            }
        }
        //addBlock()
    }
    
    func swipeDown(){
        for var c = 0; c < NumCols; c++ {
            for var r = 1; r < NumRows; r++ {
                slide(0, dely: -1, x: c, y: r)
            }
        }
        //addBlock()
    }
    
    func swipeLeft(){
        for var r = 0; r < NumRows; r++ {
            for var c = 1; c < NumCols; c++ {
                slide(-1, dely: 0, x: c, y: r)
            }
        }
        //addBlock()
    }

    func swipeRight(){
        for var r = 0; r < NumRows; r++ {
            for var c = NumCols - 2; c >= 0; c-- {
                slide(1, dely: 0, x: c, y: r)
            }
        }
        //addBlock()
    }
    
    
    func endGame(){
        delegate?.gameDidEnd(self)
    }
    
}