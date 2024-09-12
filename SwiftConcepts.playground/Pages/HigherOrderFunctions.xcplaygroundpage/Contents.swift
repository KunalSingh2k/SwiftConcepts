// examples: map, compactMap, flatMap, filter, reduce, removeAll, contains, sorted, forEach

import Foundation


func greet(name: String) {
    print("Good Morning \(name)")
}

func greetUser(message: (String) -> Void) {
    message("Mock_User")
}

greetUser(message: greet)

// Taking function as output
func greetingFunction(username: String) -> () -> String {
    func toGreet() -> String {
        return "Good Morning \(username)"
    }
    return toGreet
}

let output = greetingFunction(username: "Kunal")
print(output())
