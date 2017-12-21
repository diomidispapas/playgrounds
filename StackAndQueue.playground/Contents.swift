//: Playground - noun: a place where people can play

import UIKit

struct Stack<T> {
    
    private var storage = [T]()
    
    mutating func push(_ element: T) {
        storage.append(element)
    }
    
    mutating func pop() -> T? {
        guard !isEmpty else { return nil }
        return storage.removeLast()
    }
    
    var isEmpty: Bool {
        return storage.isEmpty
    }
    
    mutating func reversed() -> Stack<T>? {
        let reversedElements = Array(storage.reversed())
        return Stack(storage: reversedElements)
    }
}

extension Stack: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return storage.description
    }
}

extension Stack: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = T

    init(arrayLiteral elements: T...) {
        storage.append(contentsOf: elements)
    }
}

var intStack = Stack<Int>()
intStack.push(5)
intStack.push(3)
intStack.push(2)

intStack.pop()
intStack.pop()


// 3, 2, 1

struct Queue<T> {

    private var stack = Stack<T>()

    mutating func enqueue(_ element: T) {
        stack.push(element)
    }

    mutating func dequeue() -> T? {
        var reversedStack = stack.reversed()
        let poppedElement = reversedStack?.pop()
        stack = reversedStack?.reversed() ?? Stack<T>()
        return poppedElement
    }
}

extension Queue: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return stack.debugDescription
    }
}

var queue = Queue<Int>()
queue.enqueue(2)
queue.enqueue(3)
queue.enqueue(4)
queue.enqueue(5)
queue.dequeue()
queue
queue.dequeue()
queue
queue.dequeue()
queue



