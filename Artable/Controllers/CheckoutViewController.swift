//
//  CheckoutViewController.swift
//  Artable
//
//  Created by Nelson Gonzalez on 8/12/19.
//  Copyright © 2019 Nelson Gonzalez. All rights reserved.
//

import UIKit
import Stripe

class CheckoutViewController: UIViewController, CartItemDelegate {
 
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var paymentMethodButton: UIButton!
    @IBOutlet weak var shippingMethodButton: UIButton!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var processingFeeLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var paymentContext: STPPaymentContext!

    override func viewDidLoad() {
        super.viewDidLoad()

       setupTableView()
        setupPaymentInfo()
        setupStripeConfig()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: Identifiers.cartItemCellNibFileName, bundle: nil), forCellReuseIdentifier: Identifiers.CartItemCell)
    }
    
    private func setupPaymentInfo() {
        subTotalLabel.text = StripeCart.subtotal.penniesToFormattedCurrency()
        processingFeeLabel.text = StripeCart.processingFees.penniesToFormattedCurrency()
        shippingCostLabel.text = StripeCart.shippingFees.penniesToFormattedCurrency()
        totalLabel.text = StripeCart.total.penniesToFormattedCurrency()
    }
    
    func removeItem(product: Product) {
        StripeCart.removeItemFromCart(item: product)
        tableView.reloadData()
        
        setupPaymentInfo()
        paymentContext.paymentAmount = StripeCart.total
    }
    //https://github.com/kboy-silvergym/stripe-payments-firebase/blob/master/iOS/StripePaymentsSample/ViewController.swift
    private func setupStripeConfig() {
        let config = STPPaymentConfiguration.shared()
        config.requiredBillingAddressFields = .full
        
        config.requiredShippingAddressFields = [.postalAddress]
        
        let customerContext = STPCustomerContext(keyProvider: StripeApi)
        paymentContext = STPPaymentContext(customerContext: customerContext, configuration: config, theme: .default())
        paymentContext.paymentAmount = StripeCart.total
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    @IBAction func placeOrderButtonPressed(_ sender: UIButton) {
        
        
    }
    @IBAction func paymentMothodButtonPressed(_ sender: UIButton) {
        paymentContext.pushPaymentOptionsViewController()
        
    }
    @IBAction func shippingMethodPressed(_ sender: UIButton) {
        
        paymentContext.pushShippingViewController()
    }
    
   

}

extension CheckoutViewController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
    }
    
    
    
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StripeCart.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.CartItemCell, for: indexPath) as? CartItemTableViewCell {
            
            let product = StripeCart.cartItems[indexPath.row]
            cell.configureCell(product: product, delegate: self)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
