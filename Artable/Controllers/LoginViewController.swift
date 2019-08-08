//
//  LoginViewController.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text, email.isNotEmpty, let password = passwordTextField.text, password.isNotEmpty else { return }
        
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
           guard let strongSelf = self else { return }
            if let error = error {
                print("Error signing user in with email and password: \(error.localizedDescription)")
                strongSelf.handleFireAuthError(error: error)
                strongSelf.activityIndicator.stopAnimating()
                return
            }
            
            strongSelf.activityIndicator.stopAnimating()
            strongSelf.dismiss(animated: true, completion: nil) //dismiss the entire navigation controllers
        }
    }
    @IBAction func guestButtonPressed(_ sender: UIButton) {
        
    }
    

}
