//
//  ProductsViewController.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ProductsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var products = [Product]()
    var category: Category!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let product = Product.init(name: "Landscape", id: "hfodsfjvdf", category: "Nature", price: 24.99, productDescription: "What a lovely landscape", imageUrl: "https://images.unsplash.com/photo-1565191999001-551c187427bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80", timeStamp: Timestamp(), stock: 0, favorite: false)
        
        products.append(product)

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Identifiers.ProductCellNibFile, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
    }
    

}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductTableViewCell {
            
            cell.configureCell(product: products[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
