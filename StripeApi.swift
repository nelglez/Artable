//
//  StripeApi.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/12/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//https://github.com/kboy-silvergym/stripe-payments-firebase/blob/master/iOS/StripePaymentsSample/StripeProvider.swift

import Foundation
import Stripe
import FirebaseFunctions

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider {
    
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        //create data object
        let data = [
            "stripe_version": apiVersion,
            "customer_id": UserService.user.stripeId
        ]
       
        
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(nil, error)//nil for json and error for error
                return
            }
            
            guard let key  = result?.data as? [String: Any] else {
                completion(nil, nil)
                return
            }
            
            completion(key, nil)
        }
    }
}
