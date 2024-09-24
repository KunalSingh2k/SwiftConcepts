import UIKit

//MARK: - Generic functions
/// Type parameters - Type parameter is replaced with the actual type whenever the function is called.
/// Naming type parameters - can be descreptive or T, U, V is used . (Upper case or upper camel case)
func swapTwoValues<T>(_ a: inout T, _ b: inout T ) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someInt = 3
var anotherInt = 107
swapTwoValues(&someInt, &anotherInt)
print("After Swapping:", someInt)
print("After Swapping:", anotherInt)

var someString = "Hello"
var anotherString = "World"
swapTwoValues(&someString, &anotherString)
print("After Swapping:", someString)
print("After Swapping:", anotherString)


//MARK: - Generic Types
/// Can implement your own generic type in swift similar to array and dict.
/// Element defines a placeholder name for a type to be provided later.
/// This future type can be referred to as Element anywhere within the structure’s definition.

struct Stack<Element> {
    var items: [Element] = []
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        items.removeLast()
    }
}

var stackOfStrings = Stack<String>()
stackOfStrings.push("uno")
stackOfStrings.push("des")
stackOfStrings.push("tres")
print(stackOfStrings)

let popFromStack = stackOfStrings.pop()

print("Ater popping:", stackOfStrings)

//MARK: - Extending a Generic Type
///When you extend a generic type, you don’t provide a type parameter list as part of the extension’s definition. 
///Instead, the type parameter list from the original type definition is available within the body of the extension
extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil: items[items.count - 1]
    }
}

if let topItem = stackOfStrings.topItem {
    print("The top item of the stack is:", topItem)
}

//MARK: - Type constraints
/// Type constraints specify that a type parameter must inherit from a specific class, or conform to a particular protocol or protocol composition.
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind {
            return index
        }
    }
    return nil
}

let doubleIndex = findIndex(of: 9.3, in: [3.111, 0.4, 0.25])
let stringIndex = findIndex(of: "Kunal", in: ["Andrea", "Krish", "Kunal"])

//MARK: - Associated types
/// An associated type gives a placeholder name to a type that’s used as part of the protocol.
/// The actual type to use for that associated type isn’t specified until the protocol is adopted.
protocol Container {
    /// Adding Constraints to an Associated Type
    associatedtype Item ///Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
    
        /// Associated Types with a Generic Where Clause
            // associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
            // func makeIterator() -> Iterator
}
protocol ComparableContainer: Container where Item: Comparable { }

struct Stack1<Element>: Container {
    var items: [Element] = []
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func append(_ item: Element) {
        self.push(item)
    }
    
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Element {
        return items[i]
    }
    
}

// Extending an Existing Type to Specify an Associated Type
extension Array: Container { }

// Using a Protocol in Its Associated Type’s Constraints
protocol suffixableContainer: Container {
    associatedtype Suffix: suffixableContainer where Suffix.Item == Item
    func suffix(_ size: Int) -> Suffix
}

extension Stack1: suffixableContainer {
    func suffix(_ size: Int) -> Stack1 {
        var result = Stack1()
        for index in (count - size)..<count {
            result.append(self[index])
        }
        return result
    }
}

var stackOfInt = Stack1<Int>()
stackOfInt.append(10)
stackOfInt.append(20)
stackOfInt.append(30)
print(stackOfInt)
let suffix = stackOfInt.suffix(2)
print(suffix)


//MARK: - Generic Where Clauses
/// A generic where clause enables you to require that an associated type must conform to a certain protocol, or that certain type parameters and associated types must be the same.
/// A generic where clause starts with the where keyword, followed by constraints for associated types or equality relationships between types and associated types.
/// You write a generic where clause right before the opening curly brace of a type or function’s body.

func allItemsMatch<C1: Container, C2: Container>(_ someContainer: C1, _ anotherContainer: C2) -> Bool where C1.Item == C2.Item, C1.Item: Equatable {
    
    if someContainer.count != anotherContainer.count {
        return false
    }
    
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] {
            return false
        }
    }
    return true
    /// C1 and C2 must conform to the Container protocol (written as C1: Container).
    /// The Item for C1 must be the same as the Item for C2 (written as C1.Item == C2.Item).
    /// The Item for C1 must conform to the Equatable protocol (written as C1.Item: Equatable).
}

var stackOfStrings1 = Stack1<String>()
stackOfStrings1.push("uno")
stackOfStrings1.push("dos")
stackOfStrings1.push("tres")
print(stackOfStrings1)

var arrayOfStrings1 = ["uno", "dos", "tres"]
print(arrayOfStrings1)

if allItemsMatch(stackOfStrings1, arrayOfStrings1) {
    print("All items match")
} else {
    print("Not all items match")
}


//MARK: - Extensions with a Generic Where Clause
extension Stack1 where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

if stackOfStrings1.isTop("tres") {
    print("Top item is tres")
} else {
    print("Top item is something else")
}

// Generic where clause with extensions to a protocol
extension Container where Item: Equatable {
    func startsWith(_ item: Item) -> Bool {
        return count >= 1 && self[0] == item
    }
}

if [9,9,9].startsWith(42) {
    print("Starts with 42")
} else {
    print("Starts with something else")
}

// Generic where clauses that require Item to be a specific type
extension Container where Item == Double {
    func average() -> Double {
        var sum = 0.0
        for index in 0..<count {
            sum += self[index]
        }
        return sum/Double(count)
    }
}

print([1260.0, 1222, 96, 90].average())

//MARK: - Contextual Where Clauses
extension Container {
    func getAverage() -> Double where Item == Int {
        var sum = 0.0
        for index in 0..<count {
            sum += Double(self[index])
        }
        return sum/Double(count)
    }
    func endsWith(_ item: Item) -> Bool where Item: Equatable {
        return count >= 1 && self[count-1] == item
    }
}

let numbers = [500, 500, 500, 20]
print(numbers.getAverage())
print(numbers.endsWith(500))

//MARK: - Generic Subscripts
extension Container {
    subscript<Indices: Sequence>(_ indices: Indices) -> [Item] where Indices.Iterator.Element == Int {
        var result: [Item] = []
        for index in indices {
            result.append(self[index])
        }
        return result
    }
}
