//
//  ForgotPasswordViewController.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        
        guard let email = emailTextField.text, email.isNotEmpty else {
            simpleAlert(title: "Error", message: "Please enter email.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                self.handleFireAuthError(error: error)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    

}
