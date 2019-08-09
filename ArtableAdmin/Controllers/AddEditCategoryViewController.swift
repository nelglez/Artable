//
//  AddEditCategoryViewController.swift
//  ArtableAdmin
//
//  Created by Nelson Gonzalez on 8/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

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
