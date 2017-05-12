//
//  SearchMedicineController.swift
//  medical
//
//  Created by Luay Suarna on 4/7/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit

class SearchMedicineController: UITableViewController {
    
    var medicines: [Medicine] = []
    var selectedMedicines: [Medicine] = []
    var medicineWrapper: MedicineWrapper!
    var alert = AlertMessage()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMedicines()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicines.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SearchMedicineCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchMedicineCell
        let medicine = medicines[indexPath.row]
        
        cell.labelName.text = medicine.name
        cell.labelType.text = "\(Utils.numberToCurrency(medicine.price!)) \\ \(medicine.unitName!)"
        
        let valid = selectedMedicines.contains { (value) -> Bool in
            value.name == medicine.name
        }
        
        if(valid) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let medicine = medicines[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        
        if(!isContain(medicine)) {
            cell?.accessoryType = .checkmark
            selectedMedicines.append(medicine)
        } else {
            let index = selectedMedicines.index { (value) -> Bool in value.name == medicine.name }
            
            cell?.accessoryType = .none
            selectedMedicines.remove(at: index!)
        }
        
        print(selectedMedicines)
    }
    
    // Mark - Load Medicines
    
    func loadMedicines() {
        Medicine.list({
            result in
            if let error = result.error {
                self.alert.show("Error", alertDescription: "Could not load medicines")
            }
            
            let medicineWrapper = result.value
            
            self.addMedicinesFromWrapper(medicineWrapper)
        })
    }
    
    func addMedicinesFromWrapper(_ wrapper: MedicineWrapper?) {
        
        self.medicineWrapper = wrapper
        if self.medicineWrapper?.medicines != nil {
            self.medicines = (self.medicineWrapper?.medicines)!
        }
        
        self.tableView.reloadData()
    }
    
    // Mark - Helper
    
    func isContain(_ medicine: Medicine) -> Bool {
        let valid = selectedMedicines.contains { (value) -> Bool in
            value.name == medicine.name
        }
        
        return valid
    }
}
