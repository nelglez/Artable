//
//  CartItemTableViewCell.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/12/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

protocol CartItemDelegate: class {
    func removeItem(product: Product)
}

class CartItemTableViewCell: UITableViewCell {
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var removeItemButton: UIButton!
    
    private var item: Product!
    weak var delegate: CartItemDelegate?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func configureCell(product: Product, delegate: CartItemDelegate) {
        
        self.delegate = delegate
        self.item = product
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        if let price = formatter.string(from: product.price as NSNumber) {
        productTitleLabel.text = "\(product.name) \(price)"
        }
        
        if let url = URL(string: product.imageUrl) {
            productImage.kf.setImage(with: url)
        }
    }
    
    @IBAction func removeItemButtonPressed(_ sender: UIButton) {
        delegate?.removeItem(product: item)
        
    }
    
}
