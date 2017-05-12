//
//  MenuController.swift
//  medical
//
//  Created by Luay Suarna on 3/6/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    /**
     *  Array to display menu options
     */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    /**
     *  Menu button which was tapped to display the menu
     */
    var btnMenu : UIButton!
    
    /**
     *  Delegate of the MenuVC
     */
    var delegate : SlideMenuDelegate?
    
    var currentUser = CurrentUser(SessionModel.getCurrentUser())
    var appointments: [Appointment] = []
    var alert = AlertMessage()
    var appointmentWrapper: AppointmentWrapper?
    
    @IBOutlet var nameUser: UILabel!
    @IBOutlet var roleUser: UILabel!
    @IBOutlet var imageUser: UIImageView!
    @IBOutlet var backgroundMenu: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        
        nameUser.text = currentUser.name
        roleUser.text = currentUser.role
        if currentUser.role == "Doctor" {
            loadAppointments()
        }
        
        imageUser.layer.cornerRadius = imageUser.frame.size.width / 2;
        imageUser.clipsToBounds = true
        imageUser.layer.borderWidth = 3.0
        let color = UIColor.white
        imageUser.layer.borderColor = color.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        if currentUser.role == "Doctor" {
            arrayMenuOptions.append(["title":"Home", "icon":"ico1"])
            arrayMenuOptions.append(["title":"Appointment", "icon":"ico1"])
            arrayMenuOptions.append(["title":"Complaint", "icon":"ico1"])
            arrayMenuOptions.append(["title":"Logout", "icon":"ico1"])
        } else if currentUser.role == "Nurse" {
            arrayMenuOptions.append(["title":"Home", "icon":"ico1"])
            arrayMenuOptions.append(["title":"Medicine", "icon":"ico1"])
            arrayMenuOptions.append(["title":"Pharmacy Cashier", "icon":"ico1"])
            arrayMenuOptions.append(["title":"Transaction Data", "icon":"ico1"])
            arrayMenuOptions.append(["title":"Logout", "icon":"ico1"])
        } else if currentUser.role == "Patient" {
            arrayMenuOptions.append(["title":"Home", "icon":"ico1"])
            arrayMenuOptions.append(["title":"Appointment", "icon":"ico1"])
            arrayMenuOptions.append(["title":"Logout", "icon":"ico1"])
        } else {
            arrayMenuOptions.append(["title":"Home", "icon":"ico1"])
            arrayMenuOptions.append(["title":"Purchase", "icon":"ico1"])
            arrayMenuOptions.append(["title":"Cashier", "icon":"ico1"])
            arrayMenuOptions.append(["title":"Logout", "icon":"ico1"])
        }
        
        
        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
        
        cell.selectionStyle = .none
        cell.layoutMargins = .zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = .clear
        
        let fontStyle = UIFont(name: "Avenir-Light", size: 16.0)
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        let badgeNotif: UIView = cell.contentView.viewWithTag(104) as UIView!
        let labelNotif: UILabel = cell.contentView.viewWithTag(103) as! UILabel
        
        lblTitle.font = fontStyle
        badgeNotif.isHidden = true
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        if currentUser.role == "Doctor" && arrayMenuOptions[indexPath.row]["title"]! == "Appointment" && appointments.count > 0 {
            badgeNotif.isHidden = false
            labelNotif.text = "\(appointments.count)"
            
            badgeNotif.layer.cornerRadius = badgeNotif.frame.size.width / 2
            badgeNotif.clipsToBounds = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func loadAppointments() {
        if currentUser.role == "Doctor" {
            Appointment.listByDoctor(doctorId: String(currentUser.id), status: "Pending", {
                result in
                if let error = result.error {
                    self.alert.show("Error", alertDescription: "Could not load appointments")
                }
                let appointmentWrapper = result.value
                self.addAppointmentsFromWrapper(appointmentWrapper)
            })
        } else if currentUser.role == "Patient" {
            Appointment.listByPatient(patientId: String(currentUser.id), status: "Pending", {
                result in
                if let error = result.error {
                    self.alert.show("Error", alertDescription: "Could not load appointments")
                }
                let appointmentWrapper = result.value
                self.addAppointmentsFromWrapper(appointmentWrapper)
            })
        }
    }
    
    func addAppointmentsFromWrapper(_ wrapper: AppointmentWrapper?)
    {
        self.appointmentWrapper = wrapper
        if self.appointments == nil {
            self.appointments = (self.appointmentWrapper?.appointments)!
        } else if self.appointmentWrapper != nil && self.appointmentWrapper!.appointments != nil {
            self.appointments = self.appointments + self.appointmentWrapper!.appointments!
        }
        self.tblMenuOptions.reloadData()
    }
    
}
