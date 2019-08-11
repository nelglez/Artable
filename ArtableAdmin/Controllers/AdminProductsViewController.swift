//
//  AdminProductsViewController.swift
//  ArtableAdmin
//
//  Created by Nelson Gonzalez on 8/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class AdminProductsViewController: ProductsViewController {
    
    var selectedProduct: Product?

    override func viewDidLoad() {
        super.viewDidLoad()

        let editCategoryButton = UIBarButtonItem(title: "Edit Category", style: .plain, target: self, action: #selector(editCategory))
        editCategoryButton.tintColor = .white
        
        let newProductButton = UIBarButtonItem(title: "+ Product", style: .plain, target: self, action: #selector(newProduct))
        newProductButton.tintColor = .white
        
        navigationItem.setRightBarButtonItems([editCategoryButton, newProductButton], animated: false)
        
    }
    

    @objc private func editCategory() {
        performSegue(withIdentifier: Segues.ToEditCategory, sender: self)
    }
   
    @objc private func newProduct() {
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //editing product
        selectedProduct = products[indexPath.row]
        performSegue(withIdentifier: Segues.ToAddEditProduct, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.ToAddEditProduct {
            if let destinationVC = segue.destination as? AddEditProductsViewController {
                destinationVC.selectedCategory = category
                destinationVC.productToEdit = selectedProduct
            }
        } else if segue.identifier == Segues.ToEditCategory {
            if let destinationVC = segue.destination as? AddEditCategoryViewController {
                destinationVC.categoryToEdit = category
            }
        }
    }
    

}
