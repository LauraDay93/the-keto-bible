//
//  SubscriptionManager.swift
//  The Keto Bible
//
//  Created by Laura Day on 12/9/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import SwiftyStoreKit
import StoreKit



class SubscriptionManager {
    public static let sharedInstance = SubscriptionManager()
    
    static var productIdYearly : String {
        if StyleManager.isKeto {
            return "tkhyearly"
        } else {
            return "tvhyearly"

        }
    }
    
    static var productIdMonthly : String {
        if StyleManager.isKeto {
            return "tkhmonthly"
        } else {
            return "tvhmonthly"

        }
    }

    public let allProductIds : Set<String> = [SubscriptionManager.productIdYearly, SubscriptionManager.productIdMonthly]
    private var allProductsById : [String: SKProduct] = [:]

    
    public var receiptSharedSecret : String {
        if StyleManager.isKeto {
            return  "cedb028d974d423281c0116f9cd219d0"
        } else {
            return  "96c183226abb48d38818bf1c455fa6dc"
        }
    }

    static let purchaseComplete = NSNotification.Name(rawValue: "purchaseComplete")

    
    func verifyAllSubscriptions(completion: ((Bool, ReceiptError?) -> Void)?) {
        
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: SubscriptionManager.sharedInstance.receiptSharedSecret)
        
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productIds = self.allProductIds
                let purchaseResult = SwiftyStoreKit.verifySubscriptions(productIds: productIds, inReceipt: receipt)
                switch purchaseResult {
                case .purchased(let expiryDate, let items):
                    completion?(true, nil)
                    print("\(productIds) are valid until \(expiryDate)\n\(items)\n")
                case .expired(let expiryDate, let items):
                    completion?(false, nil)
                    print("\(productIds) are expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    completion?(false, nil)
                    print("The user has never purchased \(productIds)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
                completion?(false, error)
            }
        }
        
    }
    

    
    func loadProducts(completion: (() -> Void)?) {
        SwiftyStoreKit.retrieveProductsInfo(allProductIds) { result in
            
            if result.error == nil {
                self.allProductsById.removeAll()
                for product in result.retrievedProducts {
                    self.allProductsById[product.productIdentifier] = product
                    print("product loaded: " + product.localizedTitle)
                }
                completion?()
                //print("ALL PRODUCTS LOADED")
            } else {
                print("ERROR: \(result.error!)")
            }
        }
    }
    
    func getMonthlyProduct() -> SKProduct? {
        return allProductsById[SubscriptionManager.productIdMonthly]
    }
    
    func getYearlyProduct() -> SKProduct? {
        return allProductsById[SubscriptionManager.productIdYearly]
    }

    public func purchaseMonthly(completion: @escaping (_ purchaseDetails: PurchaseDetails?, _ errorStr : String?) -> Void) {
        purchase(productId: SubscriptionManager.productIdMonthly, completion: completion)
    }
    
    public func purchaseYearly(completion: @escaping (_ purchaseDetails: PurchaseDetails?, _ errorStr : String?) -> Void) {
        purchase(productId: SubscriptionManager.productIdYearly, completion: completion)
    }
    
    public func restore(showAlerts: Bool, completion: @escaping (_ restored: Bool, _ errorStr : String?) -> Void) {

        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
                
                completion(false, "Restore Failed")
           
            }
                else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                self.verifyAllSubscriptions { (validSub, error) in
                    if validSub && error == nil {
                        NotificationCenter.default.post(name: SubscriptionManager.purchaseComplete, object: nil)
                    } else if error != nil {
                        print("error restoring: " + error!.localizedDescription)
                        completion(false, error!.localizedDescription)
                    } else {
                        completion(false, "Nothing to Restore")
                    }
                }
            }
            else {
                print("Nothing to Restore")
                completion(false, "Nothing to restore")
            }
        }
        
    }
    
    
    private func purchase(productId : String, completion: @escaping (_ purchaseDetails: PurchaseDetails?, _ errorStr : String?) -> Void) {
        SwiftyStoreKit.purchaseProduct(productId, atomically: true) { result in
                        
            var success = false
            switch result {
            case .success(let purchase):
                
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                }
                
                completion(purchase, nil)
            case .error(let error):
                
                
                switch error.code {
                case .unknown:
                    
                print("getting error as unkown")

                // failsafe check 1
                self.restore(showAlerts: true) { (restored, errorStr) in
                    success = restored
                }
                    
                    if !success {
                        completion(nil, error.localizedDescription)
                    }

                case .clientInvalid: print("client_invalid")
                    completion(nil, error.localizedDescription)
                case .paymentCancelled:print("payment cancelled")
                
                    // On cancel check again IF there's a receipt found.
                    self.restore(showAlerts: true) { (restored, errorStr) in }
                    
                completion(nil, "")

                case .paymentInvalid: print("payment_invalid")
                    completion(nil, error.localizedDescription)
                case .paymentNotAllowed: print("payment_not_allowed")
                    completion(nil, error.localizedDescription)
                case .storeProductNotAvailable: print("product_not_available")
                    completion(nil, "")
                case .cloudServicePermissionDenied: print("cloud_permission_denied")
                    completion(nil, "")
                case .cloudServiceNetworkConnectionFailed: print("no_network_connection")
                    completion(nil, "")
                case .cloudServiceRevoked: print("cloud_service_revoked")
                    completion(nil, "")
                default: print("unknown")
                
                    // failsafe check again
                    self.restore(showAlerts: true) { (restored, errorStr) in
                        success  = restored
                    }
                }
                

                
            }
        }
        
    }
    
    public func localReceiptFound() -> Bool {
       return SwiftyStoreKit.localReceiptData != nil
    }
    
    public func appLaunchedCompleteTransactions() {
            SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
                
                for purchase in purchases {
                    if purchase.transaction.transactionState == .purchased || purchase.transaction.transactionState == .restored {
                        
                        if purchase.needsFinishTransaction {
                            // Deliver content from server, then:
                            SwiftyStoreKit.finishTransaction(purchase.transaction)
                        }
                    }
                    
                    // self.validateReceipts(notify: true, completion: nil)
                }
            }
        }
    
}
