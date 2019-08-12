//
//  CartItemTableViewCell.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/12/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class CartItemTableViewCell: UITableViewCell {
    @IBOutlet weak var productImage: RoundedImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var removeItemButton: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    
    @IBAction func removeItemButtonPressed(_ sender: UIButton) {
    }
    
}
