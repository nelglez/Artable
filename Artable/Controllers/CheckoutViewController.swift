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
       //Updating the selected payment method
        if let paymentOption = paymentContext.selectedPaymentOption {
            paymentMethodButton.setTitle(paymentOption.label, for: .normal)
        } else {
            paymentMethodButton.setTitle("Select Method", for: .normal)
        }
        
        //updating the selected shipping method
        
        if let shippingMethod = paymentContext.selectedShippingMethod {
            shippingMethodButton.setTitle(shippingMethod.label, for: .normal)
            //Add shipping fees to total
            StripeCart.shippingFees = Int(Double(truncating: shippingMethod.amount) * 100)
            setupPaymentInfo()
        } else {
            shippingMethodButton.setTitle("Select Method", for: .normal)
        }
    }
    
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        
    }
    //Select shipping method
    func paymentContext(_ paymentContext: STPPaymentContext, didUpdateShippingAddress address: STPAddress, completion: @escaping STPShippingMethodsCompletionBlock) {
        
        let upsGround = PKShippingMethod()
        upsGround.amount = 0
        upsGround.label = "UPS Ground"
        upsGround.detail = "Arrives in 3-5 days"
        upsGround.identifier = "ups_ground"
        
        let fedex = PKShippingMethod()
        fedex.amount = 6.99
        fedex.label = "FedEx"
        fedex.detail = "Arrives tomorrow"
        fedex.identifier = "fedex"
        //Address Validation
        if address.country == "US" {
            completion(.valid, nil, [upsGround, fedex], nil /*'fedex' to select a default shipping*/)
        } else {
            completion(.invalid, nil, nil, nil)
        }
        
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
