//
//  CategoryCollectionViewCell.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       categoryImage.layer.cornerRadius = 5
    }
    
    func configureCell(category: Category) {
        categoryLabel.text = category.name
        if let url = URL(string: category.imageUrl) {
            let placeholder = UIImage(named: "placeholder")
            categoryImage.kf.indicatorType = .activity
            let options: KingfisherOptionsInfo = [.transition(.fade(0.2))]
           categoryImage.kf.setImage(with: url, placeholder: placeholder, options: options)
        }
    }

}
