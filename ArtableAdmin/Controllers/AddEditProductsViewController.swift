//
//  AddEditProductsViewController.swift
//  ArtableAdmin
//
//  Created by Nelson Gonzalez on 8/11/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditProductsViewController: UIViewController {
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var productImageView: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: RoundedButton!
    
  
    var selectedCategory: Category!
    var productToEdit: Product?
    
    var name = ""
    var price = 0.0
    var productDescription = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        productImageView.isUserInteractionEnabled = true
        productImageView.clipsToBounds = true
        productImageView.addGestureRecognizer(tap)
        
    }
    
    @objc private func imageTapped() {
        //launch image picker
        launchImagePicker()
        
    }
    
    private func uploadImageThenDocument() {
        guard let image = productImageView.image, let name = productNameTextField.text, name.isNotEmpty, let description = productDescriptionTextView.text, description.isNotEmpty, let priceString = productPriceTextField.text, let price = Double(priceString) else {
            simpleAlert(title: "Missing Fields", message: "Please fill out all required fields.")
            return
        }
        
        self.name = name
        self.productDescription = description
        self.price = price
        
        //Upload image to cloud storage
        activityIndicator.startAnimating()
        
        //Turn image into data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }//1. full resolution. 0. compressed
        
        //create a storage image ref
        let imageRef = Storage.storage().reference().child("/productImages/\(name).jpg")
        //set meta data
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        //upload data
        imageRef.putData(imageData, metadata: metaData) { (metaData, error) in
            if let error = error {
                print(error.localizedDescription)
                self.handleError(error: error, message: "Unable to upload image.")
                return
            }
            //retrieve the download url.
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.handleError(error: error, message: "Unable to retrive image url.")
                    return
                }
                guard let url = url else { return }
                //upload new product document to the firestore category collection
                self.uploadDocument(url: url.absoluteString)
            })
        }
        
        
    }
    
    private func uploadDocument(url: String) {
        var docRef: DocumentReference!
        
        var product = Product(name: name, id: "", category: selectedCategory.id, price: price, productDescription: productDescription, imageUrl: url)
        
        
        
        if let productToEdit = productToEdit {
            //We are editing a product
            docRef = Firestore.firestore().collection("products").document(productToEdit.id)
            product.id = productToEdit.id
        } else {
            // adding a new product
            docRef = Firestore.firestore().collection("products").document() //add new product
            product.id = docRef.documentID
            
        }
    
        let data = Product.modelToData(product: product)
        
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                print(error.localizedDescription)
                self.handleError(error: error, message: "Unable to upload new product to firestore.")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func handleError(error: Error, message: String) {
        print(error.localizedDescription)
        simpleAlert(title: "Error", message: message)
        activityIndicator.stopAnimating()
    }
    

    @IBAction func addButtonPressed(_ sender: UIButton) {
        uploadImageThenDocument()
    }
    
}

extension AddEditProductsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else { return }
        
        productImageView.contentMode = .scaleAspectFill
        productImageView.image = image
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
