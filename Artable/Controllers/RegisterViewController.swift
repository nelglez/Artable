//
//  RegisterViewController.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

    private func signUpNewUser() {
        guard let username = usernameTextField.text, !username.isEmpty, let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing user up with email and password: \(error.localizedDescription)")
                return
            }
            
            print("Successfully registered new user.")
        }
    }
   
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        signUpNewUser()
    }
    
}
