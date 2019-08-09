//
//  AdminHomeViewController.swift
//  ArtableAdmin
//
//  Created by Nelson Gonzalez on 8/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class AdminHomeViewController: HomeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Disable login button
        navigationItem.leftBarButtonItem?.isEnabled = false
        
        //create ui bar button
        let addCategoryButton = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
        addCategoryButton.tintColor = AppColors.OffWhite
        navigationItem.rightBarButtonItem = addCategoryButton
       
    }
    
    
    @objc private func addCategory() {
        performSegue(withIdentifier: Segues.ToAddEditCategory, sender: self)
    }

    

}
