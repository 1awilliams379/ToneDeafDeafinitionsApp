//
//  Cart.swift
//  ToneDeafDeafinitionsApp
//
//  Created by Tone Deaf on 10/12/20.
//  Copyright © 2020 GITEM Solutions. All rights reserved.
//




import Foundation
import SPAlert

let userCart = Cart<Product>()

public enum CartItemChangeType {

    /// When a new item is added to the cart.
    case add(at: Int)

    /// When an existing item increments its quantity.
    case increment(at: Int)

    /// When an existing item decrements its quantity.
    case decrement(at: Int)

    /// When an existing item is removed from the cart.
    case delete(at: Int)

    /// When the cart is cleaned (All items were removed).
    case clean
}

public protocol CartDelegate {

    /// Its called when an item is added, removed, or change its quantity.
    ///
    /// - parameter type: Describes which type of change was made.
    ///
    func cart<T>(_ cart: Cart<T>, itemsDidChangeWithType type: CartItemChangeType)
}

public protocol ProductProtocol: Equatable {

    /// The price will be use to calculate the amount in the cart.
    var price: Double { get }
}

open class Cart<T: ProductProtocol> {
    
    /// Describes the product and quantity.
    public typealias Item = (product: T, quantity: Int)

    /// Counts the number of items without regard to quantity of each one.
    /// Use this to know the number of items in a list, e.g. To get the number of rows in a table view.
    public var count: Int {
        get {
            return items.count
        }
    }

    /// Counts the number of products regarding the quantity of each one.
    /// Use this to know the total of products e.g. To display the number of products in cart.
    public var countQuantities: Int {
        get {
            var numberOfProducts = 0
            for item in items {
                numberOfProducts += item.quantity
            }
            return numberOfProducts
        }
    }

    /// The amount to charge.
    open var amount: Double {
        var total: Double = 0
        for item in items {
            total += (item.product.price * Double(item.quantity))
        }
        return total
    }

    /// The delegate to communicate the changes.
    public var delegate: CartDelegate?

    /// The list of products to sell.
    private var items = [Item]()

    /// Public init
    public init() {}

    /// Gets the item at index.
    public subscript(index: Int) -> Item {
        return items[index]
    }

    /// Adds a product to the items.
    /// if the product already exists, increments the quantity, otherwise adds as new one.
    ///
    /// - parameter product: The product to add.
    /// - parameter quantity: How many times will add the products. Default is 1.
    ///
    public func add(_ product: T, quantity: Int = 1) {
        for (index, item) in items.enumerated() {
            if product == item.product {
                items[index].quantity += quantity

                delegate?.cart(self, itemsDidChangeWithType: .increment(at: index))
                return
            }
        }

        items.append((product: product, quantity: quantity))

        delegate?.cart(self, itemsDidChangeWithType: .add(at: (items.count - 1)))
        NotificationCenter.default.post(name: ExpandCartHeightNotify, object: nil)
        NotificationCenter.default.post(name: OpenTheCartNotify, object: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
            let alert = SPAlertView(title: "Added to Cart", message: "", preset: .custom(UIImage(named: "cart")!))
            alert.duration = 1.5
            alert.present()
            //SPAlert.present(title: "Added to Cart", preset: .cart)
            
        })
    }

    /// Increments the quantity of an item at index in 1.
    ///
    /// - parameter index: The index of the product to increment.
    ///
    public func increment(at index: Int) {
        items[index].quantity += 1
        delegate?.cart(self, itemsDidChangeWithType: .increment(at: index))
    }

    /// Increments the quantity of the product item.
    ///
    /// - parameter product: The product to increment the quantity.
    ///
    public func increment(_ product: T)  {
        for (index, item) in items.enumerated() {
            if product == item.product {
                increment(at: index)
                break
            }
        }
    }

    /// Decrements the quantity of an item at index in 1, removes from items if the quantity downs to 0.
    ///
    /// - parameter index: The index of the product to reduce.
    ///
    public func decrement(at index: Int) {
        if items[index].quantity > 1 {
            items[index].quantity -= 1
            delegate?.cart(self, itemsDidChangeWithType: .decrement(at: index))
        } else {
            remove(at: index)
        }
    }

    /// Decrements the quantity of a product item.
    ///
    /// - parameter product:  The product to reduce the quantity.
    ///
    public func decrement(_ product: T)  {
        for (index, item) in items.enumerated() {
            if product == item.product {
                decrement(at: index)
                break
            }
        }
    }

    /// Removes completely the product at index from the items list, not matter the quantity.
    ///
    /// - parameter index: The index of the product to remove.
    ///
    public func remove(at index: Int) {
        items.remove(at: index)

        delegate?.cart(self, itemsDidChangeWithType: .delete(at: index))
        NotificationCenter.default.post(name: ExpandCartHeightNotify, object: nil)
        let alert = SPAlertView(title: "Removed Successfully", message: "", preset: .done)
        alert.duration = 1.5
        alert.present()
        
    }

    /// Removes all products from the items list.
    open func clean() {
        items.removeAll()

        delegate?.cart(self, itemsDidChangeWithType: .clean)
    }
}

extension Product: Equatable {

    static func == (lhs: Product, rhs: Product) -> Bool {
        var dabool:Bool = false
        if lhs.id == rhs.id && lhs.type == rhs.type {
            dabool = true
        }
        return dabool
    }
}

class Product: ProductProtocol {

    var id: String
    var dbid: String
    var name: String
    var price: Double
    var thumbnailURL: String
    var type: String
    var involved:[String]

    init(id: String, dbid: String, name: String, price: Double, thumbnailURL: String, type: String, involved:[String]) {
        self.id = id
        self.dbid = dbid
        self.name = name
        self.price = price
        self.thumbnailURL = thumbnailURL
        self.type = type
        self.involved = involved
    }
}
