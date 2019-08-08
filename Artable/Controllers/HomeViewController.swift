//
//  ViewController.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/7/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    @IBOutlet weak var loginOutButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            Auth.auth().signInAnonymously() { (result, error) in
                if let error = error {
                    print("Error signing user anonymously: \(error.localizedDescription)")
                    Auth.auth().handleFireAuthError(error: error, vc: self)
                    return
                }
            }
        }
        
        
    }
    //Called every single time when the view appears
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = Auth.auth().currentUser, !user.isAnonymous {
        loginOutButton.title = "Logout"
        } else {
            loginOutButton.title = "Login"
        }
    }
    
    private func presentLoginController() {
        let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: StoryboardId.LoginVC)
        present(controller, animated: true, completion: nil)
    }

    @IBAction func logInOutPressed(_ sender: UIBarButtonItem) {
        
        guard let user = Auth.auth().currentUser else { return }
        
        if user.isAnonymous {
            presentLoginController()
        } else {
            do {
                try Auth.auth().signOut()
                Auth.auth().signInAnonymously { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                    }
                     self.presentLoginController()
                }
            } catch {
                print(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
            }
        }
    }
    

}

