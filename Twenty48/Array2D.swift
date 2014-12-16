//
//  Array2D.swift
//  Twenty48
//
//  Created by Austin Wu on 12/15/14.
//  Copyright (c) 2014 Austin Wu. All rights reserved.
//

class Array2D<T> {
    let columns: Int
    let rows: Int
    
    var array: Array<T?>
    
    init(columns: Int, rows: Int){
        self.columns = columns
        self.rows = rows
        array = Array<T?>(count:rows * columns, repeatedValue: nil )
    }
    
    subscript(column: Int, row: Int) -> T? {
        get{
            return array [(row * columns) + column]
        }
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
    
}
