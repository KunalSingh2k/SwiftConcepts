import UIKit

//MARK: - Enumerations
/// An enumeration defines a common type for a group of related values and enables you to work with those values in a type-safe way within your code.
/// If a value (known as a raw value) is provided for each enumeration case, the value can be a string, a character, or a value of any integer or floating-point type.
enum CompassPoint {
    case north
    case south
    case east
    case west
}

/// Multiple cases can appear on a single line, separated by commas:
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}
///The type of directionToHead is inferred when it’s initialized with one of the possible values of CompassPoint. 
var directionToHead = CompassPoint.west

///Once directionToHead is declared as a CompassPoint, you can set it to a different CompassPoint value using a shorter dot syntax:
directionToHead = .east


//MARK: - Matching Enumeration Values with a Switch Statement
directionToHead = .south
switch directionToHead {
case .north:
    print("Lots of planets have north")
case .south:
    print("watch out for penguins")
case .east:
    print("where the sun rises")
case .west:
    print("where the sun sets")
}

/// When it isn’t appropriate to provide a case for every enumeration case, you can provide a default case to cover any cases that aren’t addressed explicitly
let somePlanet = Planet.earth
switch somePlanet {
case .earth:
    print("Moslty harmless")
default:
    print("Not safe for humans")
}

//MARK: - Iterating over Enumeration Cases
enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count
print("\(numberOfChoices) beverages available")

/// A for-in loop to iterate over all the cases.
for beverage in Beverage.allCases {
    print(beverage)
}

//MARK: - Associated Values
/// You can define Swift enumerations to store associated values of any given type, and the value types can be different for each case of the enumeration if needed.
/// Enumerations similar to these are known as discriminated unions, tagged unions, or variants in other programming languages.
/// It’s convenient for an inventory tracking system to store UPC barcodes as a tuple of four integers, and QR code barcodes as a string of any length.
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
var productBarCode = Barcode.upc(8, 222, 111, 9)
productBarCode = .qrCode("ASDFFGHHJJ")

switch productBarCode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check)")
case let .qrCode(productCode):
    print("QR Code: \(productCode)")
}

//MARK: - Raw Values
/// Enumeration cases can come prepopulated with default values (called raw values), which are all of the same type.
/// Raw values can be strings, characters, or any of the integer or floating-point number types.
/// Each raw value must be unique within its enumeration declaration.
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

// Implicitly Assigned Raw Values
enum Planet1: Int {
    case mercury = 1, venus, earth, mars
}

enum CompassPoint1: String {
    case north, south, east, west
}

let orderOfEarth = Planet1.earth.rawValue
print("Earths Order is: \(orderOfEarth)")
let sunsetDirection = CompassPoint1.west.rawValue
print("Sunset direction is: \(sunsetDirection)")

// Initializing from a Raw Value
let possiblePlanet = Planet1(rawValue: 4)
/// possiblePlanet is of type Planet? and equals Planet1.mars

// Optional binding
let positionToFind = 7
if let somePlanet = Planet1(rawValue: positionToFind) {
    switch somePlanet {
    case .earth:
        print("Less harm")
    default:
        print("more harm")
    }
} else {
    print("No planets in this position \(positionToFind)")
}

//MARK: - Recursive Enumerations
/// A recursive enumeration is an enumeration that has another instance of the enumeration as the associated value for one or more of the enumeration cases.
/// You indicate that an enumeration case is recursive by writing indirect before it, which tells the compiler to insert the necessary layer of indirection.
indirect enum ArithmeticExpression {
    case number(Int)
    case addition(ArithmeticExpression, ArithmeticExpression)
    case multiplication(ArithmeticExpression, ArithmeticExpression)
}

let four = ArithmeticExpression.number(4)
let five = ArithmeticExpression.number(5)
let sum = ArithmeticExpression.addition(four, five)
let multiply = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))

func evaluate(_ expression: ArithmeticExpression) -> Int {
    switch expression {
    case let .number(value):
        return value
    case let .addition(lhs, rhs):
        return evaluate(lhs) + evaluate(rhs)
    case let .multiplication(lhs, rhs):
        return evaluate(lhs) * evaluate(rhs)
    }
}

print(evaluate(sum))
print(evaluate(multiply))
