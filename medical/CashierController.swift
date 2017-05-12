//
//  CashierController.swift
//  medical
//
//  Created by Luay Suarna on 3/31/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit

class CashierController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var labelCashierType: UILabel!
    @IBOutlet var labelCashierName: UILabel!
    @IBOutlet var imageCashier: UIImageView!
    @IBOutlet var labelOrderItem: UILabel!
    @IBOutlet var labelTotalPrice: UILabel!
    @IBOutlet var labelAmountPrice: UILabel!
    @IBOutlet var btnPurchases: UIButton!
    @IBOutlet var btnDraft: UIButton!
    @IBOutlet var btnPay: UIButton!
    @IBOutlet var btnSearch: UIButton!
    
    @IBOutlet var tableItems: UITableView!
    @IBOutlet var mainWrapper: UIView!
    @IBOutlet var cashierWrapper: UIView!
    
    var purchase: Purchase = Purchase(json: ["id": 0, "date": Utils.stringToDate("0000-00-00 00:00:00"), "total_price": "0", "paid": "0"])
    var purchaseItems: [PurchaseItem] = []
    var medicines: [Medicine] = []
    var alert = AlertMessage()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Mark - Setup View
    func setupView() {
        let font17 = UIFont(name: "Avenir-Light", size: 17.0)
        let font12 = UIFont(name: "Avenir-Light", size: 12.0)
        let font15 = UIFont(name: "Avenir-Light", size: 15.0)
        let font16 = UIFont(name: "Avenir-Light", size: 16.0)
        
        labelCashierType.font = font17
        labelCashierName.font = font12
        labelOrderItem.font = font17
        labelTotalPrice.font = font15
        labelAmountPrice.font = font15
        btnPurchases.titleLabel?.font = font16
        btnDraft.titleLabel?.font = font16
        btnPay.titleLabel?.font = font16
        btnSearch.titleLabel?.font = font16
        
        imageCashier.image = UIImage(named: "doctor")
        imageCashier.layer.cornerRadius = imageCashier.frame.size.width / 2;
        imageCashier.clipsToBounds = true
        imageCashier.layer.borderWidth = 3.0
        let color = UIColor.init(red: 255, green: 108, blue: 94, alpha: 1)
        imageCashier.layer.borderColor = color.cgColor
        
        mainWrapper.layer.cornerRadius = 7.0
        cashierWrapper.layer.cornerRadius = 7.0
        
        tableItems.layoutMargins = UIEdgeInsets.zero
        tableItems.separatorInset = UIEdgeInsets.zero
    }
    
    @IBAction func goToPurchases() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Mark - Table Purcahases
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CashierCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CashierCell
        let purchaseItem: PurchaseItem = purchaseItems[indexPath.row]
        
        
        cell.imageMedicine.image = UIImage(named: "ico2")
        cell.labelMedicineType.text = purchaseItem.unitName
        cell.labelMedicineName.text = purchaseItem.medicineName
        cell.labelMedicinePrice.text = Utils.numberToCurrency(purchaseItem.price!)
        cell.labelMedicineCount.text = "\(Int(purchaseItem.quantity!))"
        
        let font14 = UIFont(name: "Avenir-Light", size: 14.0)
        let font15 = UIFont(name: "Avenir-Light", size: 15.0)
        
        cell.labelMedicineType.font = font14
        cell.labelMedicineName.font = font15
        cell.labelMedicinePrice.font = font14
        cell.labelMedicineCount.font = font15
        cell.layoutMargins = UIEdgeInsets.zero
        cell.btnAddItem.layer.cornerRadius = cell.btnAddItem.frame.size.width / 2;
        cell.btnAddItem.clipsToBounds = true
        cell.btnReduceItem.layer.cornerRadius = cell.btnAddItem.frame.size.width / 2;
        cell.btnReduceItem.clipsToBounds = true
        
        cell.btnAddItem.tag = indexPath.row
        cell.btnAddItem.addTarget(self, action: #selector(self.addQuantity(_:)), for: .touchUpInside)
        cell.btnReduceItem.tag = indexPath.row
        cell.btnReduceItem.addTarget(self, action: #selector(self.reduceQuantity(_:)), for: .touchUpInside)
        
        addDashedBottomBorder(cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @IBAction func addQuantity(_ sender: UIButton) {
        let purchaseItem = purchaseItems[sender.tag]
        purchaseItem.quantity = purchaseItem.quantity! + 1
        purchaseItem.totalPrice = purchaseItem.quantity! * purchaseItem.price!
        tableItems.reloadData()
        reloadPrice()
    }
    
    @IBAction func reduceQuantity(_ sender: UIButton) {
        let purchaseItem = purchaseItems[sender.tag]
        purchaseItem.quantity = purchaseItem.quantity! - 1
        purchaseItem.totalPrice = purchaseItem.quantity! * purchaseItem.price!
        
        if purchaseItem.quantity == 0 {
            let index = medicines.index { (value) -> Bool in value.name == purchaseItem.medicineName }
            
            medicines.remove(at: index!)
            purchaseItems.remove(at: sender.tag)
        }
        tableItems.reloadData()
        reloadPrice()
    }
    
    func addDashedBottomBorder(cell: UITableViewCell) {
        
        let color = UIColor.lightGray.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = cell.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: 0)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [10.6]
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: shapeRect.height, width: shapeRect.width, height: 0), cornerRadius: 0).cgPath
        
        cell.layer.addSublayer(shapeLayer)
    }
    
    @IBAction func unwindToThisView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SearchMedicineController {
            medicines = sourceViewController.selectedMedicines
            
            for medicine in medicines {
                if !isContain(medicine) {
                    let purchaseItem = PurchaseItem(json: ["id": 0, "purchase_header_id": 0, "quantity": "1", "price": "\(medicine.price!)", "total_price": "\(medicine.price!)", "medicine_id": Int(medicine.id!), "unit_id": Int(medicine.unitId!), "medicine_name": medicine.name, "unit_name": medicine.unitName])
                    
                    purchaseItems.append(purchaseItem)
                }
            }
            if purchaseItems.count > 0 {
                for purchaseItem in purchaseItems {
                    if !medicinesIsContain(purchaseItem) {
                        
                        let index = purchaseItems.index { (value) -> Bool in value.medicineName == purchaseItem.medicineName }
                        
                        purchaseItems.remove(at: index!)
                    }
                }
            }
            
            tableItems.reloadData()
            reloadPrice()
        }
    }
    
    // Mark - Helper
    
    func isContain(_ medicine: Medicine) -> Bool {
        let valid = purchaseItems.contains { (value) -> Bool in
            value.medicineName == medicine.name
        }
        
        return valid
    }
    
    func medicinesIsContain(_ purcahseItem: PurchaseItem) -> Bool {
        let valid = medicines.contains { (value) -> Bool in
            value.name == purcahseItem.medicineName
        }
        
        return valid
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSearchMedicine" {
            let destinationNavController = segue.destination as! UINavigationController
            let destinationController = destinationNavController.topViewController as! SearchMedicineController
            destinationController.selectedMedicines = self.medicines
        }
    }
    
    func getTotalPrice() -> Double {
        var totalPrice: Double = Double()
        
        for purchaseItem in purchaseItems {
            totalPrice += purchaseItem.price! * purchaseItem.quantity!
        }
        
        self.purchase.totalPrice = totalPrice
        
        return totalPrice
    }
    
    func reloadPrice() {
        self.labelAmountPrice.text = Utils.numberToCurrency(self.getTotalPrice())
    }
    
    @IBAction func payNow() {
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            Purchase.create(Utils.currentDateInString(), "\(self.purchase.totalPrice!)", self.purchaseItems, {
                result in
                
                if let error = result.error {
                    self.alert.show("Error", alertDescription: "Could not store the data")
                } else {
                    
                    let purchaseHeaderId = result.value?.purchase?.id
                    for purchaseItem in self.purchaseItems {
                        print(purchaseItem)
                        PurchaseItem.createItem(purchaseHeaderId!, medicineId: purchaseItem.medicineId!, quantity: "\(purchaseItem.quantity!)", unitId: purchaseItem.unitId!, price: "\(purchaseItem.price!)", totalPrice: "\(purchaseItem.totalPrice!)", completionHandler: {
                            result in
                            
                            if let error = result.error {
                                self.alert.show("Error", alertDescription: "Could not store the data")
                            } else {
                                let item = self.purchaseItems[self.purchaseItems.count - 1]
                                
                                if(item.medicineName == purchaseItem.medicineName){
                                    self.alert.show("Success!", alertDescription: "Purchase successfully paid")
                                    self.purchaseItems = []
                                    self.medicines = []
                                    self.tableItems.reloadData()
                                    self.reloadPrice()
                                }
                            }
                        })
                    }
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            print("cancel")
        }
        
        let alertConfirm = alert.confirmationShow("Are you sure?", alertDescription: "your payment can not cancelled", okAction: okAction, cancelAction: cancelAction)
        self.present(alertConfirm, animated: true, completion: nil)
    }

}
