//
//  AddEditCategoryViewController.swift
//  ArtableAdmin
//
//  Created by Nelson Gonzalez on 8/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class AddEditCategoryViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryImage: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    
    var categoryToEdit: Category?

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
        
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        //If we are editing, categoryToEdit will not be nil
        if let category = categoryToEdit {
            nameTextField.text = category.name
            addButton.setTitle("Save Changes", for: .normal)
            
            if let url = URL(string: category.imageUrl) {
                categoryImage.contentMode = .scaleAspectFill
                categoryImage.kf.setImage(with: url)
            }
        }
    }
    
    @objc private func imageTapped() {
        launchImagePicker()
    }

    @IBAction func addCategoryButtonPressed(_ sender: UIButton) {

        uploadImageThenDocument()
    }
    
    private func uploadImageThenDocument() {
        guard let image = categoryImage.image, let categoryName = nameTextField.text, categoryName.isNotEmpty else {
            simpleAlert(title: "Error", message: "Must have category image and name.")
            return
        }
        
        activityIndicator.startAnimating()
        
        //Turn image into data
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }//1. full resolution. 0. compressed
        
        //create a storage image ref
        let imageRef = Storage.storage().reference().child("/categoryImages/\(categoryName).jpg")
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
                //upload new category document to the firestore category collection
                self.uploadDocument(url: url.absoluteString)
            })
        }
    }
    
    private func uploadDocument(url: String) {
        var docRef: DocumentReference!
        var category = Category(name: nameTextField.text!, id: "", imageUrl: url, timeStamp: Timestamp())
        
        if let categoryToEdit = categoryToEdit {
            //We are editing
            docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
            category.id = categoryToEdit.id
        } else {
             // new category
            docRef = Firestore.firestore().collection("categories").document() //add new document
            category.id = docRef.documentID
            
        }
        
       
        let data = Category.modelToData(category: category)
        
        docRef.setData(data, merge: true) { (error) in
            if let error = error {
                print(error.localizedDescription)
                self.handleError(error: error, message: "Unable to upload new category to firestore.")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func handleError(error: Error, message: String) {
        self.simpleAlert(title: "Error", message: message)
        self.activityIndicator.stopAnimating()
    }

}

extension AddEditCategoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func launchImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //Image we selected from picker
        guard let image = info[.originalImage] as? UIImage else { return }
        
        categoryImage.contentMode = .scaleAspectFit
        categoryImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
