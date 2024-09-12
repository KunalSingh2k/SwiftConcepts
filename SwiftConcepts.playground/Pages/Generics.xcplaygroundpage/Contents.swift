import UIKit


func determineHigherValue<T: Comparable>(valueOne: T, valueTwo: T) {
    let higherValue = valueOne > valueTwo ? valueOne: valueTwo
    print("\(higherValue) is the higher value")
}

determineHigherValue(valueOne: 1, valueTwo: 2)
determineHigherValue(valueOne: 20.0, valueTwo: 30.0)
determineHigherValue(valueOne: Date.now, valueTwo: Date.now + 5)
