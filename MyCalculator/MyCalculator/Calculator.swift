//
//  Calculator.swift
//  MyCalculator
//
//  Created by 백종운 on 2021/01/15.
//

import Foundation

enum CalculatorError: Error {
    case invalidValue(String)
    case invalidOperation(String)
}

class Calculator {
    
    //MARK: Operations
    private enum Operation {
        case Random
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case EqualOperation
    }
    
    private var operations: Dictionary<String, Operation> = [
        // Random
        "Rand" : .Random,
        
        // Constant
        "e" : .Constant(M_E),
        "π" : .Constant(M_PI),
        
        // Unary operation
        "±" : .UnaryOperation{ -$0 },
        "%" : .UnaryOperation{ $0 / 100 },
        "1/x" : .UnaryOperation{ if $0 == 0 { return Double.nan } else { return 1 / $0 } },
        "x!" : .UnaryOperation{ if $0 != floor($0) || $0 < 0 { return Double.nan } else { return Double((1...max(Int64($0), 1)).reduce(1, *)) } },
        "x²" : .UnaryOperation{ pow($0, 2) },
        "x³" : .UnaryOperation{ pow($0, 3) },
        "²√x" : .UnaryOperation{ pow($0, 1 / 2) },
        "³√x" : .UnaryOperation{ pow($0, 1 / 3) },
        "eˣ" : .UnaryOperation{ pow(M_E, $0) },
        "2ˣ" : .UnaryOperation{ pow(2, $0) },
        "10ˣ" : .UnaryOperation{ pow(10, $0) },
        "ln" : .UnaryOperation{ if $0 <= 0 { return Double.nan } else { return log($0) } },
        "log₂" : .UnaryOperation{ if $0 <= 0 { return Double.nan } else { return log2($0) } },
        "log₁₀" : .UnaryOperation{ if $0 <= 0 { return Double.nan } else { return log10($0) } },
        "sin" : .UnaryOperation{ sin($0) },
        "cos" : .UnaryOperation{ cos($0) },
        "tan" : .UnaryOperation{ tan($0) },
        "sinh" : .UnaryOperation{ sinh($0) },
        "cosh" : .UnaryOperation{ cosh($0) },
        "tanh" : .UnaryOperation{ tanh($0) },
        "sin⁻¹" : .UnaryOperation{ asin($0) },
        "cos⁻¹" : .UnaryOperation{ acos($0) },
        "tan⁻¹" : .UnaryOperation{ atan($0) },
        "sinh⁻¹" : .UnaryOperation{ asinh($0) },
        "cosh⁻¹" : .UnaryOperation{ acosh($0) },
        "tanh⁻¹" : .UnaryOperation{ atanh($0) },
        
        // Binary operation
        "+" : .BinaryOperation{ $0 + $1 },
        "-" : .BinaryOperation{ $0 - $1 },
        "×" : .BinaryOperation{ $0 * $1 },
        "÷" : .BinaryOperation{ $0 / $1 },
        "xʸ" : .BinaryOperation{ pow($0, $1) },
        "yˣ" : .BinaryOperation{ pow($1, $0) },
        "ʸ√x" : .BinaryOperation{ pow($0, 1 / $1) },
        "log𝗒" : .BinaryOperation{ if $0 <= 0 || $1 <= 0 || $1 == 1 { return Double.nan } else { return log($0) / log($1) } },
        
        // Equal operation
        "=" : .EqualOperation,
    ]
    
    //MARK: Properties
    private struct BinaryOperationInfo {
        var firstOperand: Double
        var binaryFunction: ((Double, Double) -> Double)
    }
    
    private var binaryOperationInfo: BinaryOperationInfo?
    private var memory = 0.0
    
    
    //MARK: Methods
    func performClear() {
        binaryOperationInfo = nil
    }
    
    func performOperation(number: String?, symbol: String?) throws -> Double {
        var result: Double
        
        // Check invalid input
        guard let value = Double(number ?? "nil") else {
            throw CalculatorError.invalidValue(number ?? "nil")
        }
        guard let operation = operations[symbol ?? "nil"] else {
            throw CalculatorError.invalidOperation(symbol ?? "nil")
        }
        
        // Perform operation
        switch operation {
        case .Random:
            result = drand48()
        case .Constant(let k):
            result = k
        case .UnaryOperation(let function):
            result = function(value)
        case .BinaryOperation(let function):
            if binaryOperationInfo == nil {
                result = value
                binaryOperationInfo = BinaryOperationInfo(firstOperand: value, binaryFunction: function)
            }
            else {
                result = binaryOperationInfo!.binaryFunction(binaryOperationInfo!.firstOperand, value)
                binaryOperationInfo = BinaryOperationInfo(firstOperand: result, binaryFunction: function)
            }
        case .EqualOperation:
            if binaryOperationInfo == nil {
                result = value
            }
            else {
                result = binaryOperationInfo!.binaryFunction(binaryOperationInfo!.firstOperand, value)
                binaryOperationInfo = nil
            }
        }
            
        return result
    }
}
