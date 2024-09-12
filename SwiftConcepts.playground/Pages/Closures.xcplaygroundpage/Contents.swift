//: [Previous](@previous)

import Foundation


struct Student {
    let name: String
    var testScore: Int
}

let students = [
    Student(name: "Aaron", testScore: 75),
    Student(name: "Bill", testScore: 57),
    Student(name: "Chris", testScore: 88),
    Student(name: "Dan", testScore: 99),
    Student(name: "Elixir", testScore: 32),
    Student(name: "Frank", testScore: 60),
    Student(name: "Greg", testScore: 40),
    Student(name: "Hisenki", testScore: 66),
    Student(name: "Irish", testScore: 58),
]


var topStudentFilter: (Student) -> Bool = { student in
    return student.testScore > 80
}

// Trailing closure
let topStudents = students.filter { $0.testScore > 80 }
let studentRanking = topStudents.filter { $0.testScore > $1.testScore }

for topStudent in topStudents {
    print(topStudent.name)
}
