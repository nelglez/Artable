//
//  ProductTableViewCell.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import Kingfisher

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func configureCell(product: Product) {
        productTitleLabel.text = product.name
        productPriceLabel.text = String(product.price)
        if let url = URL(string: product.imageUrl) {
            productImage.kf.setImage(with: url)
        }
    }
    

    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
    }
    
}
