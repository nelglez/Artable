//
//  Constants.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/8/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

struct Storyboard {
    static let LoginStoryboard = "LoginStoryboard"
}

struct StoryboardId {
    static let LoginVC = "LoginVC"
}

struct AppImages {
    static let GreenCheck = "green_check"
    static let RedCheck = "red_check"
}

struct AppColors {
    static let Blue = #colorLiteral(red: 0.2274509804, green: 0.2666666667, blue: 0.3607843137, alpha: 1)
    static let Red = #colorLiteral(red: 0.8739202619, green: 0.4776076674, blue: 0.385545969, alpha: 1)
    static let OffWhite = #colorLiteral(red: 0.9529411765, green: 0.9490196078, blue: 0.968627451, alpha: 1)
}

struct Identifiers {
    static let CategoryCell = "CategoryCell"
    static let CategoryCellNibFile = "CategoryCollectionViewCell"
    static let ProductCell = "ProductCell"
    static let ProductCellNibFile = "ProductTableViewCell"
}

struct Segues {
    static let ToProducts = "ToProductsVC"
    static let ToAddEditCategory = "ToAddEditCategory"
    static let ToEditCategory = "ToEditCategory"
    static let ToAddEditProduct = "ToAddEditProduct"
}
