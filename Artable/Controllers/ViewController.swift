//
//  ViewController.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/7/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let storyboard = UIStoryboard(name: "LoginStoryboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        present(controller, animated: true, completion: nil)
    }

}

