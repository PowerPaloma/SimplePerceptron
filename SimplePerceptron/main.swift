//
//  main.swift
//  SimplePerceptron
//
//  Created by Ada 2018 on 11/09/2018.
//  Copyright © 2018 Academy. All rights reserved.
//

import Foundation

var dataBase: [[Double]] = []
var trainingDataBase: [[Double]] = []
var testDataBase: [[Double]] = []
var w: [Double]!
let n = 0.1
let epochs = 1000

func readDataSet(name: String){
    let file = "/Users/ada2018/Desktop/iris.txt"
    let path = URL(fileURLWithPath: file)
    let data = try! String(contentsOf: path, encoding: String.Encoding.utf8)
    do {
        let lines = data.components(separatedBy: "\n")
        for line in lines {
            dataBase.append(line.components(separatedBy: ",").map({Double($0)!}))
        }
    } catch {
        print("Error")
    }
}


func dot(v1: [Double], v2: [Double]) -> Double? {
    var result = 0.0
    if v1.count == v2.count{
        for (ind, num1) in v1.enumerated(){
            result += num1 * v2[ind]
        }
        return result
    }else{
        return nil
    }
}

func activation_function(y: Double) -> Double {
    return (y >= 0) ? 1.0 : 0.0
}

func predict(x: [Double]) -> Double? {
    guard let y = dot(v1: w, v2: x) else { return nil }
    return activation_function(y: y)
}

func randonElementFrom(array: [[Double]]) -> [Double]{
    if array.isEmpty{
        return []
    }else{
        let index = Int(arc4random_uniform(UInt32(array.count)))
        return array[index]
    }
}


// 0 < training/test < 1
func definePercentOf(training: Double, andTest: Double){
//    print(dataBase.count)
//    trainingDataBase = Array(dataBase[0 ..< Int(Double(dataBase.count) * training)])
//    testDataBase = Array(dataBase[0 ..< Int(Double(dataBase.count) * andTest)])
    var dataBaseCopy = dataBase
    var element = [Double]()
    let limit = Int(Double(dataBase.count) * training)
    while(trainingDataBase.count < limit) {
        element = randonElementFrom(array: dataBaseCopy)
        while (trainingDataBase.contains(element)){
            element = randonElementFrom(array: dataBaseCopy)
        }
        trainingDataBase.append(element)
        let index = dataBaseCopy.index(of: element)
        dataBaseCopy.remove(at: index!)
    }
    testDataBase = dataBaseCopy
    w = [Double](repeating: 0, count:trainingDataBase[0].count-1)
}

func multipy(array: [Double], ByScalar scalar : Double) -> [Double] {
    return array.map({ $0*scalar })
}



func traning_perceptron(){
    var y_esperado = 0.0
    var error = 0.0
    var x: [Double] = []
    for _ in 0...epochs {
        for row in dataBase {
            x = Array(row[0 ..< row.count-1])
            guard let y = predict(x: x ) else {return}
            y_esperado = row.last!
            error = y_esperado - y
            w = zip(w, multipy(array: multipy(array: x, ByScalar: error), ByScalar: n)).map(+)
        }
    }
}

func testPerceptron(){
    var correctPredict = 0.0
    var learning_rate = 0.0
    var y_esperado = 0.0
    var prediction = 0.0
    var x: [Double] = []
    for row in testDataBase {
        x = Array(row[0 ..< row.count-1])
        y_esperado = row.last!
        prediction = predict(x: x)!
        if y_esperado == prediction {correctPredict += 1}
    }
    learning_rate = (correctPredict)*100 / Double(testDataBase.count)
    print(learning_rate)
}


func main (){
    
    print("Execution Start:")
    print("Reading Data Set:")
    readDataSet(name: "iris")
    print("Defining Percent Of Traninhg and Test:")
    definePercentOf(training: 0.8, andTest: 0.2)
    print("Traning")
    traning_perceptron()
    print("Testing")
    testPerceptron()
    
}



main()


