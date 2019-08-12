//
//  CheckoutViewController.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/12/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var shippingMethodButton: UIButton!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var processingFeeLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Identifiers.cartItemCellNibFileName, bundle: nil), forCellReuseIdentifier: Identifiers.CartItemCell)
    }
    
    @IBAction func placeOrderButtonPressed(_ sender: UIButton) {
        
        
    }
    @IBAction func paymentMothodButtonPressed(_ sender: UIButton) {
        
        
    }
    @IBAction func shippingMethodPressed(_ sender: UIButton) {
        
        
    }
    
   

}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CartItemCell, for: indexPath) as? CartItemTableViewCell {
            
            let product = StripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
