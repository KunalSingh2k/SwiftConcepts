import UIKit

//MARK: - Protocols
/// A protocol defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality.
/// The protocol can then be adopted by a class, structure, or enumeration to provide an actual implementation of those requirements.
/// Any type that satisfies the requirements of a protocol is said to conform to that protocol.
protocol FullyNamed {
    var fullName: String { get }
}

struct Person: FullyNamed {
    var fullName: String
}

let kunal = Person(fullName: "Kunal")
print(kunal)

class StarShip: FullyNamed {
    var prefix: String?
    var name: String
    init(prefix: String? = nil, name: String) {
        self.prefix = prefix
        self.name = name
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " ": "") + name
    }
}
var ship = StarShip(prefix: "USS", name: "Enterprise")
print(ship.fullName)

//MARK: - Method Requirements
protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c))
            .truncatingRemainder(dividingBy: m)
        return lastRandom/m
    }
}
let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
print("Add another one: \(generator.random())")

//MARK: - Mutating method requirements
/// If you mark a protocol instance method requirement as mutating, you don’t need to write the mutating keyword when writing an implementation of that method for a class.
/// The mutating keyword is only used by structures and enumerations.
protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case on, off
    mutating func toggle() {
        switch self {
        case .on:
            self = .off
        case .off:
            self = .on
        }
    }
}

var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()

//MARK: - Delegation
    /// Delegation is a design pattern that enables a class or structure to hand off (or delegate) some of its responsibilities to an instance of another type.
    /// This design pattern is implemented by defining a protocol that encapsulates the delegated responsibilities, such that a conforming type (known as a delegate) is guaranteed to provide the functionality that has been delegated.
class DiceGame {
    let sides: Int
    let generator = LinearCongruentialGenerator()
    weak var delegate: Delegate?
    
    init(sides: Int) {
        self.sides = sides
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
    func play(rounds: Int) {
        delegate?.gameDidStart(self)
        for round in 1...rounds {
            let player1 = roll()
            let player2 = roll()
            
            if player1 == player2 {
                delegate?.game(self, didEndRound: round, winner: nil)
            } else if player1 > player2 {
                delegate?.game(self, didEndRound: round, winner: 1)
            } else {
                delegate?.game(self, didEndRound: round, winner: 2)
            }
        }
        delegate?.gameDidEnd(self)
    }
    protocol Delegate: AnyObject {
        func gameDidStart(_ game: DiceGame)
        func game(_ game: DiceGame,didEndRound round: Int, winner: Int?)
        func gameDidEnd(_ game: DiceGame)
    }
}

class DiceGameTracker: DiceGame.Delegate {
    var player1Score = 0
    var player2Score = 0
    
    func gameDidStart(_ game: DiceGame) {
        print("Started a new game")
        player1Score = 0
        player2Score = 0
    }
    
    func game(_ game: DiceGame, didEndRound round: Int, winner: Int?) {
        switch winner {
        case 1:
            player1Score += 1
            print("Player 1 won round \(round)")
        case 2:
            player2Score += 1
            print("Player 2 won round \(round)")
        default:
            print("The round was a draw")
        }
    }
    
    func gameDidEnd(_ game: DiceGame) {
        if player1Score == player2Score {
            print("The game ended in a draw")
        } else if player1Score > player2Score {
            print("Player 1 won!")
        } else {
            print("Player 2 won!")
        }
    }
}
let tracker = DiceGameTracker()
let game = DiceGame(sides: 6)
game.delegate = tracker
game.play(rounds: 3)

//MARK: - Protocol conformance with an extension
protocol TextRepresentable {
    var textDescription: String { get }
}

extension DiceGame: TextRepresentable {
    var textDescription: String {
        return "A \(sides)-sided dice"
    }
}

let d12 = DiceGame(sides: 12)
let d6 = DiceGame(sides: 6)
print(d12.textDescription)

//MARK: - Conditonally conforming to a protocol
extension Array: TextRepresentable where Element: TextRepresentable {
    var textDescription: String {
        let itemsAsText = self.map { $0.textDescription }
        return "[" + itemsAsText.joined(separator: ",") + "]"
    }
}

let myDice = [d6, d12]
print(myDice.textDescription)

//MARK: - Declaring protocol adoption with extension
    /// Types don’t automatically adopt a protocol just by satisfying its requirements. They must always explicitly declare their adoption of the protocol.
    /// If a type already conforms to all of the requirements of a protocol, but hasn’t yet stated that it adopts that protocol, you can make it adopt the protocol with an empty extension
struct Hamster {
    var name: String
    var textDescription: String {
        return "A hamster named \(name)"
    }
}

extension Hamster: TextRepresentable {}

let simonTheHamster = Hamster(name: "Simon")
print(simonTheHamster.textDescription)
//let someTextRepresentable: TextRepresentable = simonTheHamster
//print(someTextRepresentable.textDescription)

//MARK: - Adopting a Protocol Using a Synthesized Implementation
    /// Using this synthesized implementation means you don’t have to write repetitive boilerplate code to implement the protocol requirements yourself.
struct Vector3D: Equatable {
    var x = 0.0, y = 0.0, z = 0.0
}
let twoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
let anotherTwoThreeFour = Vector3D(x: 2.0, y: 3.0, z: 4.0)
if twoThreeFour == anotherTwoThreeFour {
    print("These two vectors are equivalent")
}

enum SkillLevel: Comparable {
    case beginner
    case intermediate
    case expert(stars: Int)
}
var levels = [SkillLevel.intermediate, SkillLevel.beginner, SkillLevel.expert(stars: 5), SkillLevel.expert(stars: 3)]
for level in levels.sorted() {
    print(level)
}

//MARK: - Collections of Protocol Types
    /// A protocol can be used as the type to be stored in a collection such as an array or a dictionary
let things: [TextRepresentable] = [d6, d12, simonTheHamster]
for thing in things {
    print(thing.textDescription)
}

//MARK: - Protocol Inheritance
protocol SomeProtocol { }

protocol AnotherProtocol { }

protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // Protocol definition goes here
}

protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextDescription: String { get }
}

//MARK: - Class only protocols
    /// You can limit protocol adoption to class types by adding the AnyObject protocol to a protocol’s inheritance list.
protocol SomeClassOnlyProtocol: AnyObject {
    // class-only protocol definition goes here
}

//MARK: - Protocol composition
    /// It can be useful to require a type to conform to multiple protocols at the same time.
    /// You can combine multiple protocols into a single requirement with a protocol composition.
    /// Protocol compositions behave as if you defined a temporary local protocol that has the combined requirements of all protocols in the composition.
    /// Protocol compositions don’t define any new protocol types.
protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person1: Named, Aged {
    var name: String
    var age: Int
}
func wishHappyBirthday(to celebrator: Named & Aged) {
    print("Happy Birthday, \(celebrator.name), you're \(celebrator.age)!")
}
let birthdayPerson = Person1(name: "Kunal", age: 22)
wishHappyBirthday(to: birthdayPerson)

class Location {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}
func beginConcert(in location: Location & Named) {
    print("Hello, \(location.name)!")
}
let seattle = City(name: "Seatlle", latitude: 47.6, longitude: -122.3)
beginConcert(in: seattle)

//MARK: - Checking for Protocol Conformance
/// Checking for and casting to a protocol follows exactly the same syntax as checking for and casting to a type
protocol HasArea {
    var area: Double { get }
}
class Circle: HasArea {
    var pi = 3.1415927
    var radius: Double
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}
class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}
class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}
let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_640),
    Animal(legs: 4)
]

for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area is \(objectWithArea.area)")
    } else {
        print("Something that does not confirm to HasArea protocol")
    }
}

//MARK: - Optional protocol Requirements
/// Optional requirements are available so that you can write code that interoperates with Objective-C.
/// Both the protocol and the optional requirement must be marked with the @objc attribute.
/// Note that @objc protocols can be adopted only by classes, not by structures or enumerations.
/// They’re both optional, after all. Although technically allowed, this wouldn’t make for a very good data source.
@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSoure: CounterDataSource?
    func increment() {
        if let amount = dataSoure?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSoure?.fixedIncrement {
            count += amount
        }
    }
}

class ThreeSource: NSObject, CounterDataSource {
    let fixedIncrement = 3
}

var counter = Counter()
counter.dataSoure = ThreeSource()
for _ in 1...4 {
    counter.increment()
    print(counter.count)
}

class TowardsZeroSource: NSObject, CounterDataSource {
    func increment(forCount count: Int) -> Int {
        if count == 0 {
            return 0
        } else if count < 0 {
            return 1
        } else {
            return -1
        }
    }
}

counter.count = -4
counter.dataSoure = TowardsZeroSource()
for _ in 1...5 {
    counter.increment()
    print(counter.count)
}

//MARK: - Protocol Extensions
    /// By creating an extension on the protocol, all conforming types automatically gain this method implementation without any additional modification.
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}
let generator1 = LinearCongruentialGenerator()
print("Here's a random number: \(generator1.random())")
print("Here's a random Boolean: \(generator1.randomBool())")

//MARK: - Providing Default Implementations
    /// Although conforming types don’t have to provide their own implementation of either, requirements with default implementations can be called without optional chaining.
extension PrettyTextRepresentable {
    var prettyTextDescription: String {
        return textDescription
    }
}

//MARK: - Adding Constraints to Protocol Extensions
extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}
let numberSet1 = [100, 100, 100]
let numberSet2 = [100, 200, 300]

print(numberSet1.allEqual())
print(numberSet2.allEqual())
