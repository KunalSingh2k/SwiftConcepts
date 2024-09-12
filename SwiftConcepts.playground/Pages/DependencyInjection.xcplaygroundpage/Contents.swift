//: [Previous](@previous)

import Foundation

class NetworkManager {
    func fetchIngredients() {
        print("Ingredients fetched")
    }
}

class Bag {
    var items: [String] = []
    
    func placeOrder() {
        print("Order Placed")
    }
}

struct MealCategoryView {
    let networkManager = NetworkManager()
    let bag = Bag()
    
    func goToBurritoIngredientsView() {
        let viewModel = BurritoIngredientsViewModel(networkManager: networkManager, bag: bag)
    }
}

class BurritoIngredientsViewModel {
    let networkManager: NetworkManager
    let bag: Bag
    
    init(networkManager: NetworkManager, bag: Bag) {
        self.networkManager = networkManager
        self.bag = bag
    }
    
    func fetchIngredients() {
        networkManager.fetchIngredients()
    }
    
    func placeOrder() {
        bag.placeOrder()
    }
}
