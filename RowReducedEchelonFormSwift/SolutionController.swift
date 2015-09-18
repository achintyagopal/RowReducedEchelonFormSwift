//
//  SolutionController.swift
//  RowReducedEchelonFormSwift
//
//  Created by Achintya Gopal on 9/18/15.
//  Copyright (c) 2015 Achintya Gopal. All rights reserved.
//

import UIKit

extension String{
    
    func removeCharsFromEnd(number:Int) -> String{
        let stringLength = count(self)
    
        let substringIndex = (stringLength < number) ? 0 :stringLength - number
        
        return self.substringToIndex(advance(self.startIndex, substringIndex))
    }
    
    func length() -> Int {
        return count(self)
    }
}

class SolutionController: UIViewController {
    
    var matrixArray: [[Double]] = []
    var rows : Int = 0
    var cols : Int = 0
    var arrayOfLabels:[UILabel] = []

    override func viewDidLoad(){
       super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        createMatrix()
        printSolution()
    }
    
    func createMatrix() {
        if rows != 0 && cols != 0 {
            var startx = 16
            var starty = 66
            var endx = (Int) (self.view.frame.size.width) - 32
            var endy = (Int) (self.view.frame.size.height) - 80
            
            var width = (endx - startx)/cols
            var height = (endy - starty)/rows
            if height-2 > 32 {
                height = 32
            }
            
            for i in 0..<rows {
                for j in 0..<cols {
                    var newLabel = UILabel()
                    newLabel.frame = CGRect(x: j*width + (Int)(self.view.frame.origin.x) + 16, y: i*height + (Int)(self.view.frame.origin.y) + 66, width: width-2, height: height-2)
                    newLabel.layer.borderColor = UIColor.blackColor().CGColor;
                    newLabel.layer.borderWidth = 2.0
                    
                    newLabel.tag = i*cols + j
                    arrayOfLabels.append(newLabel)
                    self.view.addSubview(newLabel)
                }
            }
        }
    }
    
    func printSolution() {
        for i in 0..<rows {
            for j in 0..<cols {
                var a = getLabelFromArrayAtIndex(i*cols + j)
                var result = "\(matrixArray[i][j])"
                for k in 0..<result.length() {
                    var length = result.length()
                    var character = advance(result.startIndex, length-1-(Int)(k))
                    if result[character] == "0" || result[character] == "." {
                        result.removeCharsFromEnd(1)
                    } else{
                        break
                    }
                }
                if result == "" {
                    result = "0"
                }
                a!.text = result;
            }
        }
    }
    
   func getLabelFromArrayAtIndex(a: Int) -> UILabel? {
        for label in arrayOfLabels {
            if label.tag == a {
                return label
            }
        }
        return nil
    }
    
    @IBAction func returnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
