//: [Previous](@previous)

import Foundation

class Person {
    let name: String
    var macbook: MacBook?
    
    init(name: String, macbook: MacBook?) {
        self.name = name
        self.macbook = macbook
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
}

class MacBook {
    let name: String
    weak var owner: Person?
    
    init(name: String, owner: Person?) {
        self.name = name
        self.owner = owner
    }
    deinit {
        print("MackBook named \(name) is being deinitialized")
    }
}

var sean: Person?
var matilda: MacBook?

func createStrongReference() {
    sean?.macbook = matilda
    matilda?.owner = sean
}
