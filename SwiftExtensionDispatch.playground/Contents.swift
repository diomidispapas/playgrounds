// Example of dynamic dispath of protocol extension

import Foundation

protocol Greetable {
    func sayHello()
}

extension Greetable {
    func sayHello() {
        print("executing \(#function) from \(Greetable.self)")
    }
    
    func sayHi() {
        print("executing \(#function) from \(Greetable.self)")
    }
}

class GreetStruct: Greetable {
    func sayHello() {
        print("executing \(#function) from \(GreetStruct.self)")
    }
    
    func sayHi() {
        print("executing \(#function) from \(GreetStruct.self)")
    }
}

let greetableStruct: Greetable = GreetStruct()
greetableStruct.sayHello()
greetableStruct.sayHi() // sayHi() implementation is the Greetable's implementation

let greeterStruct = GreetStruct()
greeterStruct.sayHello()
greeterStruct.sayHi() // sayHi() implementation is the GreetStruct's implementation

