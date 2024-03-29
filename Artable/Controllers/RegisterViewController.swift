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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordImageCheck: UIImageView!
    @IBOutlet weak var confirmPasswordCheckImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
       confirmPasswordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let passwordText = passwordTextField.text else { return }
        
        //if we are typing in confirm password text field
        if textField == confirmPasswordTextField {
           passwordImageCheck.isHidden = false
            confirmPasswordCheckImage.isHidden = false
        } else {
            if passwordText.isEmpty {
                passwordImageCheck.isHidden = true
                confirmPasswordCheckImage.isHidden = true
                confirmPasswordTextField.text = ""
            }
        }
        
        //When passwords match, checkmarks turn green
        if passwordTextField.text == confirmPasswordTextField.text {
            passwordImageCheck.image = UIImage(named: AppImages.GreenCheck)
            confirmPasswordCheckImage.image = UIImage(named: AppImages.GreenCheck)
        } else {
            passwordImageCheck.image = UIImage(named: AppImages.RedCheck)
            confirmPasswordCheckImage.image = UIImage(named: AppImages.RedCheck)
        }
    }
   
    

    private func signUpNewUser() {
        guard let username = usernameTextField.text, username.isNotEmpty, let email = emailTextField.text, email.isNotEmpty, let password = passwordTextField.text, password.isNotEmpty else {
            simpleAlert(title: "Error", message: "Please fill out all fields.")
            return
        }
        
        guard let confirmPasswords = confirmPasswordTextField.text, confirmPasswords == password else {
            simpleAlert(title: "Error", message: "Passwords do not match.")
            return
        }
        
        activityIndicator.startAnimating()
        
        //Without linking accounts
//        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
//            if let error = error {
//                print("Error signing user up with email and password: \(error.localizedDescription)")
//                Auth.auth().handleFireAuthError(error: error, vc: self)
//                return
//            }
//
//            guard let firUser = result?.user else { return }
//
//            let artUser = User(id: firUser.uid, email: email, username: username, stripeId: "")
//            //Upload to Firestore
//            self.createFirestoreUser(user: artUser)
//
//        }
        
        //With linking accounts.
        
        guard let authUser = Auth.auth().currentUser else { return }

        let credential = EmailAuthProvider.credential(withEmail: email, password: password)

        authUser.link(with: credential) { (result, error) in
            if let error = error {
                print("Error signing user up with email and password: \(error.localizedDescription)")
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }

            guard let firUser = result?.user else { return }
            
            let artUser = User(id: firUser.uid, email: email, username: username, stripeId: "")
            //Upload to Firestore
            self.createFirestoreUser(user: artUser)
        }
    }
    
    private func createFirestoreUser(user: User) {
        //Create document Ref
        let newUserRef = Firestore.firestore().collection("users").document(user.id)
        //Create Model Data
        let data = User.modelToData(user: user)
        //Upload to fireStore
        newUserRef.setData(data) { (error) in
            if let error = error {
                Auth.auth().handleFireAuthError(error: error, vc: self)
                print("Unable to upload user: \(error.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            self.activityIndicator.stopAnimating()
        }
    }
   
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        signUpNewUser()
    }
    
}
