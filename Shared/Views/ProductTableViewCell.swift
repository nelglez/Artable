//
//  ProductTableViewCell.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProductCellDelegate: class {
    func productFavorited(product: Product)
}

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    weak var delegate: ProductCellDelegate?
    private var product: Product!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func configureCell(product: Product, delegate: ProductCellDelegate) {
        self.product = product
        self.delegate = delegate
        
        productTitleLabel.text = product.name
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
            productPriceLabel.text = price
        }
        if let url = URL(string: product.imageUrl) {
            let placeholder = UIImage(named: AppImages.Placeholder)
            productImage.kf.indicatorType = .activity
            let options: KingfisherOptionsInfo = [.transition(.fade(0.2))]
            productImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
        
        if UserService.favorites.contains(product) {
            //Favorite
            favoriteButton.setImage(UIImage(named: AppImages.FilledStar), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: AppImages.EmptyStar), for: .normal)
        }
        
    }
    

    @IBAction func addToCartButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        delegate?.productFavorited(product: product)
    }
    
}
