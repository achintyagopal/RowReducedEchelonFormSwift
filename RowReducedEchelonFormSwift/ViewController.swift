//
//  ViewController.swift
//  RowReducedEchelonFormSwift
//
//  Created by Achintya Gopal on 9/16/15.
//  Copyright (c) 2015 Achintya Gopal. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    
    var inputField: UITextField? = nil
    var arrayOfTextFields:[UITextField] = []
    var maxRows : Int = 0
    var maxColumns : Int = 0
    var rows : Int = 0
    var columns : Int = 0
    var matrixArray: [[Double]] = []
    
    @IBAction func solve(sender: AnyObject) {
        var matrixArray = createMatrixArray()
        matrixArray = rrefWithArray(matrixArray)
        self.matrixArray = matrixArray
    }
    
    @IBAction func createNewMatrix(sender: AnyObject) {
        removeMatrix()
        button2.enabled = false
        newMatrix()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SolutionController" {
            var matrixArray = createMatrixArray()
            matrixArray = rrefWithArray(matrixArray)
            self.matrixArray = matrixArray
            if let solutionController = segue.destinationViewController as? SolutionController {
                NSLog("solution controller")
                solutionController.matrixArray = matrixArray
                solutionController.rows = rows
                solutionController.cols = columns
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button2.enabled = false
        var width = self.view.frame.size.width - 32
        var height = self.view.frame.size.height - 76
        maxColumns = Int(width/55)
        maxRows = Int(height/32)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeMatrix() {
        
        for index in 0..<(rows*columns) {
            var field : UITextField? = getTextFieldFromArrayAtIndex(index)
            if (field != nil) {
                field?.removeFromSuperview()
            }
        }
        arrayOfTextFields.removeAll(keepCapacity: false);
    }
    
    func getTextFieldFromArrayAtIndex (var i: Int) -> UITextField?{
        for textField in arrayOfTextFields {
            if textField.tag == i {
                return textField;
            }
        }
        return nil;
    }
    
    func newMatrix() {
        var string = "How many rows? (1 - \(maxRows) )"
        let alert = UIAlertController(title: "Input", message: string, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(addTextField);
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: numberOfRows))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Rows"
        inputField = textField
    }
    
    func numberOfRows(alert: UIAlertAction!){
        var input = inputField!.text
        if input == nil {
            let alert = UIAlertController(title: "Error", message: "There needs to be an input", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler(addTextField);
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if input.toInt() == nil {
            let alert = UIAlertController(title: "Error", message: "There needs to be a numeric input", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler(addTextField);
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        rows = input.toInt()!
        if rows == 0 {
            let alert = UIAlertController(title: "Error", message: "There needs to be more than 0 rows", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler(addTextField);
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if rows > maxRows {
            let alert = UIAlertController(title: "Error", message: "The number of rows is to large", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler(addTextField);
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        var string = "How many columns? (1 - \(maxColumns) )"
        let alert = UIAlertController(title: "Input", message: string, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(addTextField);
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: numberOfCols))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func numberOfCols(alert: UIAlertAction!){
        var input = inputField!.text
        if input == nil {
            let alert = UIAlertController(title: "Error", message: "There needs to be an input", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler(addTextField);
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if input.toInt() == nil {
            let alert = UIAlertController(title: "Error", message: "There needs to be a numeric input", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler(addTextField);
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        columns = input!.toInt()!
        
        if columns == 0 {
            let alert = UIAlertController(title: "Error", message: "There needs to be more than 0 columns", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler(addTextField);
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if columns > maxRows {
            let alert = UIAlertController(title: "Error", message: "The number of columns is to large", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addTextFieldWithConfigurationHandler(addTextField);
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if self.rows == 0 || self.columns == 0 {
            button2.enabled = false
        } else {
            button2.enabled = true
            button2.tintColor = UIColor(red: 250.0/255.0, green: 62.0/255.0, blue: 53.0/255.0, alpha: 1.0)
            createMatrix()
        }
    }
    
    func createMatrix() {
        var startx : Int = 16
        var starty : Int = 16
        var endx : Int = (Int) (self.view.frame.size.width - 16)
        var endy : Int = (Int) (self.view.frame.size.height - 60)
        var width : Int = (Int)((endx - startx)/columns)
        var height : Int = (Int)((endy - starty)/rows)
        if height - 2 > 32 {
            height = 32
        }
        for i in 0..<rows {
            for j in 0..<columns {
                var newLabel = UITextField();
                newLabel.frame = CGRect(x: j*width + (Int)(self.view.frame.origin.x) + 16, y: i*height + (Int)(self.view.frame.origin.y) + 16, width: width-2, height: height-2)
                newLabel.tag = i * columns + j
                newLabel.keyboardType = UIKeyboardType.DecimalPad
                newLabel.layer.borderWidth = 1.0
                newLabel.delegate = self
                self.view.addSubview(newLabel)
                arrayOfTextFields.append(newLabel)
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "." {
            var textfieldtext = textField.text
            if textfieldtext.rangeOfString(".") != nil {
                return false
            }
        }
        return true
    }
    
    func createMatrixArray() -> [[Double]] {
        var array = [[Double]](count: rows, repeatedValue: [Double](count: columns, repeatedValue: 0))
        
        for i in 0..<rows {
            for j in 0..<columns {
                var textfield = getTextFieldFromArrayAtIndex(i*self.columns + j)
                var text = textfield!.text
                array[i][j] = (text as NSString).doubleValue
            }
        }
        
        return array
    }
    
    func rrefWithArray(array: [[Double]]) -> [[Double]]{
        var x = 0;
        var y = 0;
        
        var matrixArray = array

        while x < self.rows && y < self.columns {
            if matrixArray[x][y] == 0 {
                var k = 0.0
                var j = 1
                while k == 0 && (x+j) < rows {
                    k = matrixArray[x+j][y]
                    j++
                }
                j--
                if k == 0 {
                    y++
                    continue
                } else {
                    let search = x + j
                    for i in 0..<columns {
                        let temp = matrixArray[search][i]
                        matrixArray[search][i] = matrixArray[x][i]
                        matrixArray[x][i] = temp
                    }
                }
            }
            var a = matrixArray[x][y]
            for i in y..<columns {
                matrixArray[x][i] = matrixArray[x][i]/a
            }
            for i in 0..<rows {
                a = matrixArray[i][y]
                if i == x {
                    continue
                }
                for j in 0..<columns {
                    matrixArray[i][j] = matrixArray[i][j] - a * matrixArray[x][j]
                }
            }
            x++
            y++
        }
        
        return array;
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for i in 0..<rows*columns {
            var field = getTextFieldFromArrayAtIndex(i)
            field?.resignFirstResponder()
        }
    }
}

