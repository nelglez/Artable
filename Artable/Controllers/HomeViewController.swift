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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    //Called every single time when the view appears
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _ = Auth.auth().currentUser {
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
        if let _ = Auth.auth().currentUser {
            // We are logged in
            do {
                try Auth.auth().signOut()
                presentLoginController()
            } catch {
                print("Error logging user out: \(error.localizedDescription)")
            }
        } else {
            //We are not logged in
            presentLoginController()
        }
        
    }
    

}

