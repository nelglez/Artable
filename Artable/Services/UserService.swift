//
//  UserService.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/12/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

let UserService = _UserService()

final class _UserService {
  
    var user = User()
    var favorites = [Product]()
    let auth = Auth.auth()
    let db = Firestore.firestore()
    var userListener: ListenerRegistration? = nil
    var favoritesListener: ListenerRegistration? = nil
    
    var isGuest: Bool {
        guard let authUser = Auth.auth().currentUser else {
            return true
        }
        if authUser.isAnonymous {
            return true
        } else {
            return false
        }
    }
    
    func getCurrentUser() {
        guard let authUser = auth.currentUser else { return }
        
        let userRef = db.collection("users").document(authUser.uid)
        //So any changes will reflect up to date in our app
        userListener = userRef.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = snapshot?.data() else { return }
            self.user = User(data: data)
            print(self.user)
        })
        
        let favoritesRef = userRef.collection("favorites")
        favoritesListener = favoritesRef.addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            snapshot?.documents.forEach({ (document) in
                let favorite = Product(data: document.data())
                self.favorites.append(favorite)
            })
        })
        
    }
    
    func favoriteSelected(product: Product) {
        let favsRef = Firestore.firestore().collection("users").document(user.id).collection("favorites")
        
        if favorites.contains(product) {
            //remove it as a favorite
            favorites.removeAll{ $0 == product }
            favsRef.document(product.id).delete()
        } else {
            //We add as a favorite
            favorites.append(product)
            let data = Product.modelToData(product: product)
            favsRef.document(product.id).setData(data)
        }
    }
    
    func logoutUser() {
        userListener?.remove()
        userListener = nil
        favoritesListener?.remove()
        favoritesListener = nil
        user = User()
        favorites.removeAll()
    }
    
}
