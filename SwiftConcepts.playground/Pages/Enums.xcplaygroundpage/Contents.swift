//: [Previous](@previous)

import Foundation

enum carBrandOption {
    case ford, toyota
   
    var title: String {
        switch self {
        case .ford:
            return "Ford"
        case .toyota
            return "Toyota"
        }
    }
}

struct carModel {
    let brand: carBrandOption
    let model: String
}

var car1 = carModel(brand: .ford, model: "Fiesta")
var car1 = carModel(brand: .toyota, model: "Camry")
