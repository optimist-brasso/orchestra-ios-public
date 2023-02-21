//
//  IAP.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/07/2022.
//

import Foundation
import SwiftyStoreKit
import Combine
import StoreKit


/// The state of purchase flow
enum IAPProductState {
    case processing
    case failed(SKError)
    case purchased(InAppPurchase)
    case expire
    case error(String)
}

final public class IAP {
    
    public static let shared = IAP()
    var bag = Set<AnyCancellable>()
    
    private init() {
        self.network = Networking()
//        self.completeTransactions()
    }
    
    /// The product list fetched from AppStoer with the provided identifiers
    let products = CurrentValueSubject<[IAPProduct], Never>([])
    
    /// the product fetch result
    let productsFetchResult = PassthroughSubject<Result<[IAPProduct], Error>, Never>()

    /// The available products to purchase for this app
    private var availableProducts = [String]()

    let finishVerification = PassthroughSubject<Result<IAPProduct?, Error>, Never>()
    // States when purchasing product
    var productPurchaseState = PassthroughSubject<IAPProductState, Never>()
    
    let  network: Networking
    
    /// set's the products
    func setProducts(availableProducts: [String]) {
        self.availableProducts = availableProducts
        DispatchQueue.main.async { [weak self]  in
            self?.fetchAvailableProductsInfo()
        }
    }
    
    /// Method that will be called for every app launch to complete the remaining transactions
    func completeTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: false) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                case .failed, .purchasing, .deferred:
                    break // do nothing
                default:
                    break
                }
            }
        }
    }
    
//    /// Retrieve the payment term from the identifiers list
//    /// - Parameter identifier: the product identifire
//    /// - Returns: the matching payment term for that product identifier
//    private func getPaymentTerm(identifier: String) -> PaymentTerm {
//        if let termsData = availableProducts.filter ({ $0.identifier == identifier }).first {
//            return termsData.term
//        }
//        fatalError("The term is not setup for this identifier, Please check and update")
//    }
    
    /// Method to fetch the product description for appstore
    func fetchAvailableProductsInfo() {
        let products = Set(availableProducts.map { $0 })
        print(products)
        SwiftyStoreKit.retrieveProductsInfo(products) { [weak self] result in
            guard let self = self else { return }
            var allProducts = [IAPProduct]()
            for product in result.retrievedProducts {
                let price = product.localizedPrice ?? product.price.stringValue
                let requiredProduct = IAPProduct(identifier: product.productIdentifier,
                                                 localizedPrice: price,
                                                 amount: product.price.doubleValue,
                                                 currency: product.priceLocale.currencySymbol ?? "¥",
                                                 regionCode: product.priceLocale.regionCode ?? "JP")
                print(product)
                allProducts.append(requiredProduct)
            }
            self.products.send(allProducts)
            if result.error == nil {
                self.productsFetchResult.send(.success(allProducts))
            } else {
                self.productsFetchResult.send(.failure(result.error!))
            }
        }
    }
    
    /// Purchase the product
    /// - Parameters:
    ///   - product: the product to purchase
    ///   - quantity: the quantity to purchase default to 1
    func purchase(product: IAPProduct, quantity: Int = 1) {
        SwiftyStoreKit.purchaseProduct(product.identifier, quantity: quantity, atomically: false) { [weak self] (result) in
            guard let self = self else { return }
            self.handlePurchaseResult(result, product: product)
        }
    }
    
    func purchase(identifier: String, quantity: Int = 1) {
        SwiftyStoreKit.purchaseProduct(identifier, quantity: quantity, atomically: false) { [weak self] result in
            guard let self = self else { return }
            self.handlePurchaseResult(result, product: nil)
        }
    }
    
    /// Method to handle the purchase result of the product
    ///
    /// - Parameters:
    ///   - result: the purchase result after purchasing flow
    ///   - product: the product we are purchasing
    private func handlePurchaseResult(_ result: PurchaseResult, product: IAPProduct?) {
        switch result {
        case .success(purchase: let details):
            self.fetchPurchaseReceipt(for: details, product: product)
        case .error(error: let error):
            let errorString = error.localizedDescription
            let cancelError = "The operation couldn’t be completed. (SKErrorDomain error 2.)"
            productPurchaseState.send(.error(errorString == cancelError ? LocalizedKey.purchaseCancel.value : errorString))
        }
    }
    
    /// Method to get the latest receipt
    /// - Parameters:
    ///   - force: should the recipt be loaded forcefully
    ///   - completion: the completion handler for the result
   public func fetchLatestReceipt(force: Bool = true, completion: @escaping (_ receiptData: Data?, _ error: ReceiptError?) -> Void) {
        SwiftyStoreKit.fetchReceipt(forceRefresh: force) { (result) in
            switch result {
            case .success(let receiptData):
                completion(receiptData, nil)
            case .error(error: let error):
                completion(nil, error)
            }
        }
    }
    
    /// This method will fetch the receipt so that we can get the receipt details and base64 data to be verified by server
    ///
    /// - Parameters:
    ///   - details: the purchase details
    ///   - product: the product we are purchasing
    private func fetchPurchaseReceipt(for details: PurchaseDetails, product: IAPProduct?) {
        fetchLatestReceipt { [weak self] (receiptData, error) in
            guard let self = self else { return }
            if let receiptData = receiptData {
                let receiptValue = receiptData.base64EncodedString(options: [])
                let iap = InAppPurchase(product: product,
                                        receiptData: receiptData,
                                        receiptValue: receiptValue,
                                        purchasedDate: details.transaction.transactionDate)
                self.productPurchaseState.send(.purchased(iap))
                UserDefaults.standard.set(receiptValue, forKey: "receiptValue")
                UserDefaults.standard.synchronize()
                print(receiptValue)
                self.verify(receipt: receiptValue, excludeOldTransactions: true) { [weak self] result in
                    switch result {
                    case .success(_):
                        //UserDefaults.standard.set(nil, forKey: "receiptValue")
                       // UserDefaults.standard.synchronize()
                        self?.finishVerification.send(.success(product))
                    case .failure(let error):
                        //UserDefaults.standard.set(receiptValue, forKey: "receiptValue")
                        //UserDefaults.standard.synchronize()
                        self?.finishVerification.send(.failure(error))

                    }
                }
            }
        }
    }
}

extension IAP: PaymentApi {}
