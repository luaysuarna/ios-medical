//
//  PurchaseController.swift
//  medical
//
//  Created by Luay Suarna on 3/24/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit

class PurchaseController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var purchases: [Purchase] = []
    var purchaseWrapper: PurchaseWrapper?
    var alert = AlertMessage()
    
    @IBOutlet weak var tablePurchase: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Mark - Load Code
        addSlideMenuButton()
        loadPurchases()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "purchaseCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PurchaseCell
        let purchase: Purchase = purchases[indexPath.row]
        
        cell.labelCashier.text = currentUser.name
        cell.labelDate.text = Utils.timeAgo(purchase.date!)
        cell.labelItems.text = "\(purchase.purchaseItems.count)"
        cell.labelPrice.text = String(format: "$%.02f", locale: Locale.current, arguments: [purchase.totalPrice!])
        
        cell.viewWrapper.layer.cornerRadius = 5.0
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // Mark - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPurchaseDetail" {
            if let indexPath = tablePurchase.indexPathForSelectedRow {
                let destinationController = segue.destination as! PurchaseDetailsController
                
                let selectedPurchase = purchases[indexPath.row]
                destinationController.purchase = selectedPurchase
                destinationController.purchaseItems = selectedPurchase.purchaseItems
            }
        }
    }
    
    // Mark - Load Purchases
    
    func loadPurchases() {
        Purchase.list({
            result in
            if let error = result.error {
                self.alert.show("Error", alertDescription: "Could not load purchases")
            }
            
            let purchaseWrapper = result.value
            
            self.addPurchasesFromWrapper(purchaseWrapper)
        })
    }
    
    func addPurchasesFromWrapper(_ wrapper: PurchaseWrapper?) {
        
        self.purchaseWrapper = wrapper
        if self.purchaseWrapper?.purchases != nil {
            self.purchases = (self.purchaseWrapper?.purchases)!
        }
        
        self.tablePurchase.reloadData()
    }
    

}
