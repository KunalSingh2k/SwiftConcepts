//: [Previous](@previous)

import Foundation

//MARK: - Single Responsibility Principle (SRP)
/// A class or struct should only be responsible for one thing.

struct Product {
    let price: Double
}

struct Invoice {
    var products: [Product]
    let id = UUID().uuidString
    var discountPercentage: Double = 0
    
    var total: Double {
        let total = products.map({ $0.price }).reduce(0, { $0 + $1 })
        let discountedAmount = total * (discountPercentage/100)
        return total - discountedAmount
    }
    
    func printInvoice() {
        let printer = InvoicePrinter(invoice: self)
        printer.printInvoice()
    }
    
    func saveInvoice() {
        // Save invoice locally or in a database.
        let persistence = InvoicePersistence(invoice: self)
        persistence.saveInvoice()
    }
}

struct InvoicePrinter {
    let invoice: Invoice
    func printInvoice() {
        print("----------------")
        print("Invoice id: \(invoice.id)")
        print("Total cost: $\(invoice.total)")
        print("Discounts: \(invoice.discountPercentage)")
        print("----------------")
    }
}

struct InvoicePersistence {
    let invoice: Invoice
    
    func saveInvoice() {
        // Save it locally or in a database.
    }
}

let products: [Product] = [
    .init(price: 99.99),
    .init(price: 9.99),
    .init(price: 24.99),
]

let invoice = Invoice(products: products, discountPercentage: 10)
//let printer = InvoicePrinter(invoice: invoice)
//printer.printInvoice()
invoice.printInvoice()

let invoice2 = Invoice(products: products, discountPercentage: 50)
invoice2.printInvoice()


//MARK: - Open/Closed Principle (OCP)
/// Software entities such as (classes, modules, functions, etc..) should be open for extension, but closed for modification.
/// In other words, we can add additional functionality(extension) without touching the existing code(modification) of an object.

struct InvoicePersistenceOCP {
    let persistence: InvoicePersistable
    
    func save(invoice: Invoice) {
        persistence.save(invoice: invoice)
    }
}

protocol InvoicePersistable {
    func save(invoice: Invoice)
}

struct CoreDataPersistence: InvoicePersistable {
    func save(invoice: Invoice) {
        print("Saving to coreData: \(invoice.id)")
    }
}

struct DatabasePersistence: InvoicePersistable {
    func save(invoice: Invoice) {
        print("Saving to database: \(invoice.id)")
    }
}

let coreDataPersistence = CoreDataPersistence()
let persistenceOCP = InvoicePersistenceOCP(persistence: coreDataPersistence)
persistenceOCP.save(invoice: invoice)


//MARK: - Liskov Substitution Principle (LSP)
/// Derived or child classes (or) structs  must be substitutable for their base or parent classes.

enum APIError: Error {
    case invalidUrl
    case invalidResponse
    case invalidStatusCode
}

struct MockUserService {
    func fetchUser() async throws {
        do {
            throw APIError.invalidUrl
        }catch {
            print("Error: \(error)")
        }
    }
}

let mockUserService = MockUserService()
Task { try await mockUserService.fetchUser() }


//MARK: - Interface Segregation Principle (ISP)
/// Do not force any client to implement an interface which is irrelevant to them

protocol GestureProtocol {
    func didTap()
    func didDoubleTap()
    func didLongPress()
}
protocol SingleTap {
    func didTap()
}

protocol DoubleTap {
    func didDoubleTap()
}

protocol LongPress {
    func didLongPress()
}

struct SuperButton: SingleTap, DoubleTap, LongPress {
    func didTap() { }
    func didDoubleTap() { }
    func didLongPress() { }
}

struct DoubleTapButton: DoubleTap {
    func didDoubleTap() { print("DEBUG: Double Tapped...") }
}


//MARK: - Dependency Inversion Principle (DIP)
/// High level modules should not depend on low-level modules, but should depend on abstraction
/// If a high level module imports low level module then the code becomes tightly coupled
/// Changes in one class could break another class

protocol PaymentMethod {
    func execute(amount: Double)
}

// High level module
/// not scalable or better approach
struct Payment {
    var debitCardPayment: DebitCardPayment?
    var StripePayment: StripePayment?
    var ApplePayPayment: ApplePayPayment?
}

// Low level modules
struct DebitCardPayment: PaymentMethod {
    func execute(amount: Double) {
        print("Debit card payment success for \(amount)")
    }
}

struct StripePayment: PaymentMethod {
    func execute(amount: Double) {
        print("Stripe payment success for \(amount)")
    }
}

struct ApplePayPayment: PaymentMethod {
    func execute(amount: Double) {
        print("Apple Pay payment success for \(amount)")
    }
}

/// Better approach comaped to struct payment
struct PaymentDepedency {
    let payment: PaymentMethod
    
    func makePayment(amount: Double) {
        payment.execute(amount: amount)
    }
}

let stripe = StripePayment()
let applePay = ApplePayPayment()

let stripePaymentDIP = PaymentDepedency(payment: stripe)
let applePaymentDIP = PaymentDepedency(payment: applePay)
stripePaymentDIP.makePayment(amount: 100)
applePaymentDIP.makePayment(amount: 50)
