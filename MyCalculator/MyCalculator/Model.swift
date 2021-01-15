//
//  Model.swift
//  MyCalculator
//
//  Created by 백종운 on 2021/01/15.
//

import Foundation

class Model {
    
    //MARK: Collections
    private enum Operation {
        case UnaryOperation(Double)
        case BinaryOperation((Double, Double) -> Double)
        case EqualOperation
    }
    
    //MARK: Properties
    private var accumulator: Double?
    private var operations: Dictionary<String, Operation> = [
        "AC" : UnaryOperation(0)
        "C" : UnaryOperation(0)
        "±" : UnaryOperation(0)
        "%" : BinaryOperation({$0 % $1})
        "÷" : BinaryOperation({$0 / $1})
        "×" : BinaryOperation({$0 * $1})
        "-" : BinaryOperation({$0 - $1})
        "+" : BinaryOperation({$0 + $1})
        "=" : EqualOperation
    ]
    
    //MARK: Methods
    func performOperation(number: Int, symbol: String) {
        switch operations[symbol] {
        case .UnaryOperation:
            break
        case .BinaryOperation:
            break
        case .EqualOperation:
            break
        }
    }
}
