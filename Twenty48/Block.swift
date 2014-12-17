//
//  Block.swift
//  Twenty48
//
//  Created by Austin Wu on 12/15/14.
//  Copyright (c) 2014 Austin Wu. All rights reserved.
//

import Foundation
import SpriteKit

class Block: Hashable, Printable {
    var col: Int
    var row: Int
    var number: Int
    var combined : Bool
    
    var colorValues: (Int, Int, Int) {
        switch number{
        case 2: return (238, 228, 218)
        case 4: return (236, 224, 202)
        case 8: return (243, 177, 119)
        case 16: return (244, 154, 92)
        case 32: return (248, 122, 97)
        case 64: return (246, 94, 57)
        case 128: return (235, 203, 116)
        case 256: return (204, 192, 178)
        case 512: return (236, 199, 84)
        case 1024: return (238, 198, 61)
        case 2048: return (236, 196, 0)
        default: return (256, 256, 256)
        }
    }
    
    var hashValue: Int {
        return self.col ^ self.row
    }
    
    var description: String {
        return "\(number): row: \(row), col \(col): "
    }
    
    init (col: Int, row: Int, number: Int) {
        self.col = col
        self.row = row
        self.number = number
        self.combined = false
    }
    
    func doubleNum(){
        number *= 2
    }
    
    func shiftBy(x: Int, y: Int){
        col += x
        row += y
    }
    
}
func == (lhs: Block, rhs: Block) -> Bool {
    return (lhs.col == rhs.col) && (lhs.row == rhs.row) && (lhs.number == rhs.number)
}