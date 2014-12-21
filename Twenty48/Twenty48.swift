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
    //beginning of game
    func gameDidBegin(twenty48: Twenty48)
    
    //end of game
    func gameDidEnd(twenty48: Twenty48, win: Bool)
    
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
    func addBlock(){
        var result = randomOpenCell
        var newBlock = Block(col: result.col, row: result.row, number: newBlockNumber)
        blockArray[result.col, result.row] = newBlock
        delegate?.blockWasAdded(self, block: newBlock)
    }
    
    func testAddBlock(){
        var block1 = Block(col: 0, row: 3, number: 4)
//        var block2 = Block(col: 1, row: 3, number: 4)
//        var block3 = Block(col: 2, row: 0, number: 2)
//        var block4 = Block(col: 3, row: 0, number: 4)
//        var block5 = Block(col: 0, row: 1, number: 4)
//        var block6 = Block(col: 1, row: 1, number: 2)
//        var block7 = Block(col: 2, row: 1, number: 4)
//        var block8 = Block(col: 3, row: 1, number: 2)
        blockArray[0, 3] = block1
//        blockArray[1, 2] = block2
//        blockArray[2, 1] = block3
//        blockArray[3, 0] = block4
//        blockArray[0, 1] = block5
//        blockArray[1, 1] = block6
//        blockArray[2, 1] = block7
//        blockArray[3, 1] = block8
        delegate?.blockWasAdded(self, block: block1)
//        delegate?.blockWasAdded(self, block: block2)
//        delegate?.blockWasAdded(self, block: block3)
//        delegate?.blockWasAdded(self, block: block4)
//        delegate?.blockWasAdded(self, block: block5)
//        delegate?.blockWasAdded(self, block: block6)
//        delegate?.blockWasAdded(self, block: block7)
//        delegate?.blockWasAdded(self, block: block8)
    }
    
    func beginGame(){
        score = 0
        delegate?.gameDidBegin(self)
        self.addBlock()
    }
    
    // take block at loc x,y and move in delx dely direction
    func slide(delx: Int, dely: Int, x: Int, y: Int) -> Bool{
        
        if blockArray[x,y] == nil {
            return false
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
    
        var testloc = (col: goloc.col + delx, row: goloc.row + dely)
        if isValid(testloc.col, row: testloc.row) {
            if blockArray[testloc.col, testloc.row]?.number == blockArray[x,y]?.number {
                if !blockArray[testloc.col, testloc.row]!.combined {
                    var doubledBlock = blockArray[testloc.col, testloc.row]
                    doubledBlock?.doubleNum()
                    doubledBlock?.didCombine()
                    score += doubledBlock!.number
                    if(doubledBlock!.number >= 64) {
                        self.endGame(true)
                    }
                    var movedBlock = blockArray[x,y]
                    movedBlock!.setLocation(testloc.col - delx, y: testloc.row - dely)
                    blockArray[x, y] = nil
                    
                    delegate?.blockDidCombine(self, movedBlock: movedBlock!, doubledBlock: doubledBlock!)
                    return true
                }
            }
        }
        if goloc.col != x || goloc.row != y {
            var block = blockArray[x,y]
            block?.setLocation(goloc.col, y: goloc.row)
            blockArray[goloc.col, goloc.row] = block
            blockArray[x,y] = nil
            delegate?.blockDidSlide(self, block: block!)
            return true
        }
        return false
    }
    
    func swipeUp(){
        var somethingHappened = false
        for var c = 0; c < NumCols; c++ {
            for var r = NumRows - 2; r >= 0; r-- {
                if slide(0, dely: 1, x: c, y: r) {
                    somethingHappened = true
                }
                
            }
        }
        if somethingHappened {
            postSwipe()
        }
    }
    
    func swipeDown(){
        for var c = 0; c < NumCols; c++ {
            for var r = 1; r < NumRows; r++ {
                slide(0, dely: -1, x: c, y: r)
            }
        }
        postSwipe()
    }
    
    func swipeLeft(){
        for var r = 0; r < NumRows; r++ {
            for var c = 1; c < NumCols; c++ {
                slide(-1, dely: 0, x: c, y: r)
            }
        }
        postSwipe()
    }

    func swipeRight(){
        for var r = 0; r < NumRows; r++ {
            for var c = NumCols - 2; c >= 0; c-- {
                slide(1, dely: 0, x: c, y: r)
            }
        }
        postSwipe()
    }
    
    func isValid(col: Int, row: Int) -> Bool {
        return col >= 0 && col < 4 && row >= 0 && row < 4
    }
    
    func postSwipe() {
        addBlock()
        clearCombined()
        if didLose() {
            endGame(false)
        }
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
    
    func didLose() -> Bool {
        for var r = 0; r < NumRows; r++ {
            for var c = 0; c < NumCols; c++ {
                if isValid(c + 1, row: r){
                    if blockArray[c,r]?.number == blockArray[c + 1,r]?.number{
                        return false
                    }
                }
                if isValid(c - 1, row: r){
                    if blockArray[c,r]?.number == blockArray[c - 1,r]?.number{
                        return false
                    }
                }
                if isValid(c, row: r + 1){
                    if blockArray[c,r]?.number == blockArray[c,r + 1]?.number{
                        return false
                    }
                }
                if isValid(c, row: r - 1){
                    if blockArray[c,r]?.number == blockArray[c,r - 1]?.number{
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func endGame(win: Bool){
        delegate?.gameDidEnd(self, win: win)
    }
    
}