//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

protocol Greetable {
    func sayHello()
}

extension Greetable {
    func sayHello() {
        print("Hello")
    }
    
    func sayHi() {
        print("Hi")
    }
}

class GreetStruct: Greetable {
    func sayHello() {
        print("HELLO")
    }
    
    func sayHi() {
        print("HI")
    }
}

let greeterStruct = GreetStruct()
greeterStruct.sayHello()
greeterStruct.sayHi()

