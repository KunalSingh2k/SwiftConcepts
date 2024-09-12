//: [Previous](@previous)

import Foundation

//MARK: - Extensions with computed properties
let sentence =
"""
Now is the time for all good men to come to the aid of the party.

we will have a very good time.
"""

let word = "SwiftUI"

extension String {
    var wordCount: Int {
        self.components(separatedBy: .whitespacesAndNewlines)
            .filter { $0 != "" }
            .count
    }
    
    var scrambled: String {
        String(self.shuffled())
    }
}

print(sentence.wordCount)
print("Kunal".scrambled)

//MARK: - Extensions with functions
let number = 123.4565454

extension Double {
    func round(to decimalPlace: Int) -> Double {
        (pow(10, Double(decimalPlace)) * self).rounded() / pow(10, Double(decimalPlace))
    }
}

print(number.round(to: 1))

//MARK: - Extensions with subscripts
let myArray = [1,2,3]

extension Array {
    subscript(safe index: Int) -> Element? {
        index < count ? self[index]: nil
    }
}

print(myArray[safe: 1])
print(myArray[safe: 3])
