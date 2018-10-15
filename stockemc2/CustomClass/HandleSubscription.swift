//
//  HandleSubscription.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 12/19/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import StoreKit

var options: [Subscription]?

class HandleSubscription:NSObject,SKProductsRequestDelegate,SKPaymentTransactionObserver{
    static let shared = HandleSubscription()
    
    
    override init() {
        super.init()
    }
    
    func createProductID(){
        let productID = "stockemc"
        let productIDs = Set([productID])
        
        // let option = Subscription.init(product: SKProduct)
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }

    func purchase() {
        guard let subscription = options?[0] else {
            print("failed")
            return
        }
        let payment = SKPayment(product: subscription.product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        guard let subscription = options?[0] else {
            print("failed")
            return
        }
        let payment = SKPayment(product: subscription.product)
        SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

// MARK: - SKProductsRequestDelegate

extension HandleSubscription {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        options = response.products.map { Subscription(product: $0) }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        if request is SKProductsRequest {
            print("Subscription Options Failed Loading: \(error.localizedDescription)")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue,
                      updatedTransactions transactions: [SKPaymentTransaction]) {
        UIWindow.dismissView()
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                handlePurchasingState(for: transaction, in: queue)
            case .purchased:
                handlePurchasedState(for: transaction, in: queue)
            case .restored:
                handleRestoredState(for: transaction, in: queue)
            case .failed:
                handleFailedState(for: transaction, in: queue)
            case .deferred:
                handleDeferredState(for: transaction, in: queue)
            }
        }
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        print("Cancel Transaction");
    }
    
    func handlePurchasingState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("User is attempting to purchase product id: \(transaction.payment.productIdentifier)")
    }
    
    func handlePurchasedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("User purchased product id: \(transaction.payment.productIdentifier)")
        loadReceipt { (status) in
            isValidPurchase = status
            Utility.showMessage(message: "Your subscription is active")
           // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshApplication"), object: nil, userInfo: nil)
        }
        queue.finishTransaction(transaction)
        
    }
    
    func handleRestoredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        print("Purchase restored for product id: \(transaction.payment.productIdentifier)")
        loadReceipt { (status) in
            isValidPurchase = status
            Utility.showMessage(message: "Your subscription is active")
        }
        //        queue.finishTransaction(transaction)
        //        SubscriptionService.shared.uploadReceipt { (success) in
        //            DispatchQueue.main.async {
        //                NotificationCenter.default.post(name: SubscriptionService.restoreSuccessfulNotification, object: nil)
        //            }
        //        }
    }
    
    func handleFailedState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        Utility.showMessage(message: "Purchase failed")
        print("Purchase failed for product id: \(transaction.payment.productIdentifier)")
    }
    
    func handleDeferredState(for transaction: SKPaymentTransaction, in queue: SKPaymentQueue) {
        Utility.showMessage(message: "Purchase failed")
        print("Purchase deferred for product id: \(transaction.payment.productIdentifier)")
    }
    
    func loadReceipt(completion:@escaping (_ Result: Bool)->Void) {
        
        guard let url = Bundle.main.appStoreReceiptURL else {
            completion(false)
            return 
        }
        
        do {
            let data = try Data(contentsOf: url)
            //let encodedData = data.base64EncodedData(options: [])
            let body = [
                "receipt-data": data.base64EncodedString(),
                "password": "902fcee0844d44eaa05ecc864545cdcf"
            ]
        
            
            let bodyData = try! JSONSerialization.data(withJSONObject: body, options: [])
            var url:URL?
            #if DEBUG
                url = URL(string: "https://sandbox.itunes.apple.com/verifyReceipt")!
            #else
                url = URL(string: "https://buy.itunes.apple.com/verifyReceipt")!
            #endif
            
            
            var request = URLRequest(url: url!)
            request.httpBody = bodyData
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data,
                    let object = try? JSONSerialization.jsonObject(with: data, options: []),
                    let json = object as? [String: Any] else {
                        completion(false)
                        return
                }
                if(json["status"] as! NSNumber == 0){
                    completion(true)
                }else{
                    if(json["status"] as! NSNumber == 21006){
                            Utility.showMessage(message: "The subscription has expired from onwards you will some minimal detail only")
                    }
                    completion(false)
                }
                // Your application logic here.
            }
            task.resume()
        } catch {
            print("Error loading receipt data: \(error.localizedDescription)")
            completion(false)
        }
    }

}
