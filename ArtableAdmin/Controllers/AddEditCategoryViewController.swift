//
//  AddEditCategoryViewController.swift
//  ArtableAdmin
//
//  Created by Nelson Gonzalez on 8/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import FirebaseStorage

class AddEditCategoryViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var categoryImage: RoundedImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        tap.numberOfTapsRequired = 1
        categoryImage.isUserInteractionEnabled = true
        categoryImage.addGestureRecognizer(tap)
    }
    
    @objc private func imageTapped() {
        launchImagePicker()
    }

    @IBAction func addCategoryButtonPressed(_ sender: UIButton) {
        
        activityIndicator.startAnimating()
        uploadImageThenDocument()
    }
    
    private func uploadImageThenDocument() {
        guard let image = categoryImage.image, let categoryName = nameTextField.text, categoryName.isNotEmpty else {
            simpleAlert(title: "Error", message: "Must have category image and name.")
            return
        }
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
                self.simpleAlert(title: "Error", message: "Unable to upload image.")
                self.activityIndicator.stopAnimating()
                return
            }
            //retrieve the download url.
            imageRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.simpleAlert(title: "Error", message: "Unable to upload image.")
                    self.activityIndicator.stopAnimating()
                    return
                }
                guard let url = url else { return }
                
                print("URL: \(url)")
                
                //upload new category document to the firestore category collection
            })
        }
    }
    
    private func uploadDocument() {
        
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
