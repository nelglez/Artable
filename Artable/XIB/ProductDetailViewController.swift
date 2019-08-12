//
//  ProductDetailViewController.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/9/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var backgroundView: UIVisualEffectView!
    
    var product: Product!
    

    override func viewDidLoad() {
        super.viewDidLoad()

       productTitleLabel.text = product.name
        productDescriptionLabel.text = product.productDescription
        
        if let url = URL(string: product.imageUrl) {
            productImage.kf.setImage(with: url)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPriceLabel.text = price
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProduct))
        tap.numberOfTapsRequired = 1
        
        backgroundView.addGestureRecognizer(tap)
        
    }
    
    @objc private func dismissProduct() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
        //Add product to cart
        StripeCart.addItemToCart(item: product)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func keepShoppingButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
