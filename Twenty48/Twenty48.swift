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
    
    //block was added
    func blockWasAdded(twenty48: Twenty48, block: Block)
    
    //a block moved without combining
    func blockDidSlide(twenty48: Twenty48, block: Block)
    
    //a block moved and movedBlock moved, got deleted, and doubledBlock was doubled
    func blockDidCombine(twenty48: Twenty48, movedBlock: Block, doubledBlock: Block)
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
        delegate?.blockWasAdded(self, block: newBlock)
        return newBlock
    }
    
    func testAddBlock() -> Block {
        var newBlock = Block(col: 0, row: 0, number: 2)
        blockArray[0, 0] = newBlock
        return newBlock
    }
    
    func beginGame(){
        var block = self.addBlock()
        delegate?.gameDidBegin(self, firstblock: block)
    }
    
    // take block at loc x,y and move in delx dely direction
    func slide(delx: Int, dely: Int, x: Int, y: Int){
        if blockArray[x,y] == nil {
            return
        }
        
        var loc = (col: x, row: y)
        var goloc = (col: x, row: y)
        
        //after loop, goloc = furthest empty cell in correct direction
        while isValid(loc.col, row: loc.row) {
            if blockArray[loc.col, loc.row] == nil {
                goloc = loc
            }
            loc.col += delx
            loc.row += dely
        }
        /**
        When theres 3 in a row, it combines the first two adn covers the third. why.
        whichis saying the same thing as the middle one combines and then still moves OR the last one moves toofar
        */
        
        var testloc = (col: goloc.col + delx, row: goloc.row + dely)
        if isValid(testloc.col, row: testloc.row) {
            if blockArray[testloc.col, testloc.row]?.number == blockArray[x,y]?.number {
                if !blockArray[testloc.col, testloc.row]!.combined {
                    var doubledBlock = blockArray[testloc.col, testloc.row]
                    doubledBlock?.doubleNum()
                    doubledBlock?.didCombine()
                    
                    var movedBlock = blockArray[x,y]
                    movedBlock!.setLocation(testloc.col - delx, y: testloc.row - dely)
                    blockArray[x, y] = nil
                    
                    delegate?.blockDidCombine(self, movedBlock: movedBlock!, doubledBlock: doubledBlock!)
                    return
                }
            }
        }
        var block = blockArray[x,y]
        block?.setLocation(goloc.col, y: goloc.row)
        blockArray[goloc.col, goloc.row] = block
        blockArray[x,y] = nil
        delegate?.blockDidSlide(self, block: block!)
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
        addBlock()
        clearCombined()
    }
    
    func swipeDown(){
        for var c = 0; c < NumCols; c++ {
            for var r = 1; r < NumRows; r++ {
                slide(0, dely: -1, x: c, y: r)
            }
        }
        addBlock()
        clearCombined()
    }
    
    func swipeLeft(){
        for var r = 0; r < NumRows; r++ {
            for var c = 1; c < NumCols; c++ {
                slide(-1, dely: 0, x: c, y: r)
            }
        }
        addBlock()
        clearCombined()
    }

    func swipeRight(){
        for var r = 0; r < NumRows; r++ {
            for var c = NumCols - 2; c >= 0; c-- {
                slide(1, dely: 0, x: c, y: r)
            }
        }
        addBlock()
        clearCombined()
    }
    
    func clearCombined(){
        for var r = 0; r < NumRows; r++ {
            for var c = 0; c < NumRows; c++ {
                if blockArray[c,r] != nil {
                    blockArray[c,r]!.uncombine()
                }
                
            }
        }
    }
    
    func endGame(){
        delegate?.gameDidEnd(self)
    }
    
}