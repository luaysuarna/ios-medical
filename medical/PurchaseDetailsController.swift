//
//  PurchaseDetailsController.swift
//  medical
//
//  Created by Luay Suarna on 3/30/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit

class PurchaseDetailsController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var labelCashierType: UILabel!
    @IBOutlet var labelCashierName: UILabel!
    @IBOutlet var imageCashier: UIImageView!
    @IBOutlet var labelOrderItem: UILabel!
    @IBOutlet var labelTotalPrice: UILabel!
    @IBOutlet var labelAmountPrice: UILabel!
    @IBOutlet var btnBack: UIButton!
    
    @IBOutlet var mainWrapper: UIView!
    @IBOutlet var cashierWrapper: UIView!
    
    @IBOutlet var tablePurchaseItems: UITableView!
    
    var purchase: Purchase!
    var purchaseItems: [PurchaseItem] = []
    var currentUser = CurrentUser(SessionModel.getCurrentUser())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        labelCashierName.text = currentUser.name
        labelAmountPrice.text = Utils.numberToCurrency(purchase.totalPrice!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
        btnBack.titleLabel?.font = font16
        
        imageCashier.image = UIImage(named: "doctor")
        imageCashier.layer.cornerRadius = imageCashier.frame.size.width / 2;
        imageCashier.clipsToBounds = true
        imageCashier.layer.borderWidth = 3.0
        let color = UIColor.init(red: 255, green: 108, blue: 94, alpha: 1)
        imageCashier.layer.borderColor = color.cgColor
        
        mainWrapper.layer.cornerRadius = 7.0
        cashierWrapper.layer.cornerRadius = 7.0
        
        tablePurchaseItems.layoutMargins = UIEdgeInsets.zero
        tablePurchaseItems.separatorInset = UIEdgeInsets.zero
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Mark - Table
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchaseItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "purchaseItemCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PurchaseItemCell
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
        addDashedBottomBorder(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

}
