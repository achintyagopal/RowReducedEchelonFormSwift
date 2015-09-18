//: Playground - noun: a place where people can play

import UIKit

var array = [[Double]](count: 3, repeatedValue: [Double](count: 2, repeatedValue: 0))

for first in array {
    println("row")
    for second in first {
        println("value \(second)")
    }
}

for i in 0..<3 {
    for j in 0..<2 {
        var a = array[i][j];
        array[i][j] = 2.0
        println("value \(i), \(j) equals \(array[i][j])")
    }
}