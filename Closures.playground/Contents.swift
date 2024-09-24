import UIKit
import XCTest


//MARK: - Closures

// Closure takes no parameter and returns nothing
let sayHello: () -> () = {
    print("Hello")
}
sayHello()

// Closure takes 1 parameter and returns 1 parameter
let value: (Int) -> Int = { value in
    value
}
print(value(5))

// Closure takes 2 parameter and returns 1 parameter
let add: (Int, Int) -> Int = { $0 + $1 }

print(add(5, 3))

// Closure takes 2 parameter and returns String parameter
let addValues: (Int, Int) -> String = {
    String("Total after adding two values is: \($0 + $1)")
}

print(addValues(10, 2))


// Trailing closure & Non-Escaping closure
func makeSquareOf(number: Int, onCompletion: (Int) -> Void) {
    let square = number * number
    onCompletion(square)
}

makeSquareOf(number: 5) { squareOfNumber in
    print("Square of the given number is \(squareOfNumber)")
}

let numbersArray = [1,2,3,4,5]
let sum = numbersArray.reduce(0) { $0 + $1 }
print(sum)

// Capturing values
class CaptureList: NSObject {
    var singleDigit = 5
    typealias onCompletionHandler = (Int) -> Void
    
    override init() {
        super.init()
        singleDigit = 10
        makeSquareOfSingleDigit { [singleDigit] squareOfSingleDigit in
            print("Square of \(singleDigit) is \(squareOfSingleDigit)")
        }
    }
    
    func makeSquareOfSingleDigit(onCompletion: onCompletionHandler) {
        let squareOfSigleDigit = singleDigit * singleDigit
        onCompletion(squareOfSigleDigit)
    }
}

CaptureList()

//MARK: - Function take closures as arguments and return values.
func performOperation(on a: Int, and b: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(a, b)
}

let addClosure: (Int, Int) -> Int = { $0 + $1 }
let subtractClosure: (Int, Int) -> Int = { $0 - $1 }
let multiplyClosure: (Int, Int) -> Int = { $0 * $1 }

let addResult = performOperation(on: 5, and: 3, operation: addClosure)
let subtractResult = performOperation(on: 10, and: 4, operation: subtractClosure)
let multiplyResult = performOperation(on: 3, and: 3, operation: multiplyClosure)

print(addResult, subtractResult, multiplyResult)

// Function that returns a closure
func makeMultiplier(factor: Int) -> (Int) -> Int {
    return { number in
        return number * factor
    }
}

let double = makeMultiplier(factor: 2)
let triple = makeMultiplier(factor: 3)

let doubleResult = double(4)
let tripleResult = triple(5)

print(doubleResult, tripleResult)


//MARK: - Sorting With closures
struct Person {
    var name: String
    var age: Int
}

let people = [
    Person(name: "Alice", age: 28),
    Person(name: "Bob", age: 22),
    Person(name: "Charlie", age: 35)
]

// Sorting by age using closures
let sortByAge = people.sorted { $0.age < $1.age }
print(sortByAge)

//MARK: - Filtering with closures
let numbers = [1,2,3,4,5,6,7,8,9,10]

// Filtering even numbers using closures
let evenNumbers = numbers.filter { number in
    number % 2 == 0
}

print(evenNumbers)

//MARK: - Capture values in closures
func makeIncrementar(incrementAmount: Int) -> () -> Int {
    var total = 0
    
    let increment: () -> Int = {
        total += incrementAmount
        return total
    }
    return increment
}

let incrementByTwo = makeIncrementar(incrementAmount: 2)
print(incrementByTwo())
print(incrementByTwo())

let incrementByFive = makeIncrementar(incrementAmount: 5)
print(incrementByFive())
print(incrementByFive())



// Closures different usage


class Tests: XCTestCase {
    func test() {
        let adapter1 = Adapter1()
        let adapter2 = Adapter2()
        let controller = ViewController()
        
        controller.delegate = Delegate(
            doSomething: adapter1.doSomething,
            doSomethingElse: adapter2.doSomethingElse)
    }
}

struct Delegate {
    let doSomething: () -> Void
    let doSomethingElse: () -> String
}

//protocol Delegate {
//    func doSomething()
//    func doSomethingElse()
//}

//typealias Delegate = (doSomething: () -> Void, doSomethingElse: () -> Void)

class ViewController: UIViewController {
    var delegate: Delegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate?.doSomething()
        title = delegate?.doSomethingElse()
    }
}

class Adapter1 {
    func doSomething() {
        
    }
}

class Adapter2 {
    func doSomethingElse() -> String {
        "any"
    }
}
