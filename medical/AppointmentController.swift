//
//  NewAppointmentController.swift
//  medical
//
//  Created by Luay Suarna on 3/7/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit

class AppointmentController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet weak var tableAppointment: UITableView!
    @IBOutlet var btnNew: UIBarButtonItem!
    
    // Mark - Modal Detail
    @IBOutlet var viewSelectedAppointment: UIView!
    @IBOutlet var selectedName: UILabel!
    @IBOutlet var selectedDate: UILabel!
    @IBOutlet var selectedEmail: UILabel!
    @IBOutlet var selectedPhone: UILabel!
    @IBOutlet var selectedImage: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    var appointments: [Appointment] = []
    var searchResult: [Appointment] = []
    var appointmentWrapper: AppointmentWrapper?
    var alert = AlertMessage()
    var selectedAppointment: Appointment!
    var effect: UIVisualEffect!
    
    // Mark - Button Status
    @IBOutlet var btnApprove: UIButton!
    @IBOutlet var btnReject: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnComplete: UIButton!
    @IBOutlet var labelCancel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        loadAppointments()
        loadVisualEffect()
        self.navigationItem.rightBarButtonItem = nil
        visualEffectView.isHidden = true
    
        if currentUser.role == "Patient" {
            self.navigationItem.rightBarButtonItem = btnNew
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupTable() {
        tableAppointment.rowHeight = 100.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count:Int?
        
        if tableView == self.searchDisplayController!.searchResultsTableView {
            count = self.searchResult.count
        } else {
            count = self.appointments.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "appointmentCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AppointmentCell
        
        let appointment: Appointment!
        
        if searchResult.count > 0 {
            appointment = searchResult[indexPath.row]
        } else {
            appointment = appointments[indexPath.row]
        }
        
        cell.addressAppointment.text = appointment.doctor?.person?.address
        if currentUser.role == "Doctor" {
            cell.nameDoctor.text = appointment.patient?.person?.name
        } else {
            cell.nameDoctor.text = appointment.doctor?.person?.name
        }
        cell.imageDoctor.image = UIImage(named: "doctor")
        cell.imageDoctor.layer.cornerRadius = 30.0
        let date = appointment.date
        
        if  date != nil {
            cell.dateAppointment.text = Utils.dateToString(date!)
        } else {
            cell.dateAppointment.text = ""
        }
        
        if currentUser.role == "Doctor" {
            if appointment.status == "Approved" || appointment.status == "Completed" {
                cell.imageStatus.image = UIImage(named: "check")
            } else if appointment.status == "Cancelled" {
                cell.imageStatus.image = UIImage(named: "time")
            } else if appointment.status == "Rejected" {
                cell.imageStatus.image = UIImage(named: "cancel")
            } else {
                cell.imageStatus.isHidden = true
            }
            
            if appointment.status == "Completed" {
                cell.backgroundColor = UIColor(red: 91.0/255.0, green: 188.0/255.0, blue: 46.0/255.0, alpha: 0.30)
            } else if appointment.status == "Cancelled" {
                cell.backgroundColor = UIColor(red: 255.0/255.0, green: 108.0/255.0, blue: 94.0/255.0, alpha: 0.30)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedAppointment = appointments[indexPath.row]
        
        labelCancel.isHidden = true
        btnCancel.isHidden = true
        btnApprove.isHidden = true
        btnReject.isHidden = true
        btnComplete.isHidden = true
        
        if currentUser.role == "Doctor" {
            selectedName.text = selectedAppointment.patient?.person?.name
            selectedDate.text = Utils.dateToString(selectedAppointment.date!)
            selectedEmail.text = selectedAppointment.patient?.person?.email
            selectedPhone.text = selectedAppointment.patient?.person?.phone
            
            // Mark - Status Button
            if selectedAppointment.status == "Completed" {
                labelCancel.isHidden = false
                labelCancel.text = "COMPLETED"
            } else if selectedAppointment.status == "Approved" && ((selectedAppointment.date?.compare(Date())) != nil) {
                btnComplete.isHidden = false
            }
            else if selectedAppointment.status == "Approved" || selectedAppointment.status == "Rejected" && !((selectedAppointment.date?.compare(Date())) != nil) {
                btnCancel.isHidden = false
            }
            else if selectedAppointment.status == "Cancelled" {
                labelCancel.isHidden = false
            }
            else {
                btnApprove.isHidden = false
                btnReject.isHidden = false
            }
        } else if currentUser.role == "Patient" {
            selectedName.text = selectedAppointment.doctor?.person?.name
            selectedDate.text = Utils.dateToString(selectedAppointment.date!)
            selectedEmail.text = selectedAppointment.doctor?.person?.email
            selectedPhone.text = selectedAppointment.doctor?.person?.phone
            
            labelCancel.isHidden = false
            labelCancel.text = selectedAppointment.status
        }
        
        animateIn()
    }
    
    func addAppointmentsFromWrapper(_ wrapper: AppointmentWrapper?)
    {
        self.appointmentWrapper = wrapper
        if self.appointments == nil {
            self.appointments = (self.appointmentWrapper?.appointments)!
        } else if self.appointmentWrapper != nil && self.appointmentWrapper!.appointments != nil {
            self.appointments = self.appointments + self.appointmentWrapper!.appointments!
        }
    }
    
    func loadAppointments() {
        if currentUser.role == "Doctor" {
            Appointment.list(doctorId: String(currentUser.id), {
                result in
                if let error = result.error {
                    self.alert.show("Error", alertDescription: "Could not load appointments")
                }
                let appointmentWrapper = result.value
                self.addAppointmentsFromWrapper(appointmentWrapper)
                self.tableAppointment.reloadData()
            })
        } else if currentUser.role == "Patient" {
            Appointment.list(patientId: String(currentUser.id), {
                result in
                if let error = result.error {
                    self.alert.show("Error", alertDescription: "Could not load appointments")
                }
                let appointmentWrapper = result.value
                self.addAppointmentsFromWrapper(appointmentWrapper)
                self.tableAppointment.reloadData()
            })
        }
    }
    
    // Mark - Search Feature
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchText: searchString)
        return true
    }
    
    func filterContentForSearchText(searchText: String) {
        // Filter the array using the filter method
        self.searchResult.filter({(appointment: Appointment) -> Bool in
            return appointment.doctor?.person?.name?.range(of: searchText.lowercased()) != nil
        })
    }
    
    // Mark - Visual Effect
    
    func loadVisualEffect() {
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        
        viewSelectedAppointment.layer.cornerRadius = 5
        viewSelectedAppointment.clipsToBounds = true
        viewSelectedAppointment.layer.borderWidth = 1.0
        let color = UIColor.lightGray
        viewSelectedAppointment.layer.borderColor = color.cgColor
        
        selectedImage.layer.cornerRadius = selectedImage.frame.size.width / 2;
        selectedImage.clipsToBounds = true
        selectedImage.layer.borderWidth = 3.0
        let whiteColor = UIColor.white
        selectedImage.layer.borderColor = whiteColor.cgColor
    }
    
    func animateIn() {
        visualEffectView.isHidden = false
        self.view.addSubview(viewSelectedAppointment)
        viewSelectedAppointment.center = self.view.center
        
        viewSelectedAppointment.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        viewSelectedAppointment.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            self.viewSelectedAppointment.alpha = 1
            self.viewSelectedAppointment.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.viewSelectedAppointment.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewSelectedAppointment.alpha = 0
            
            self.visualEffectView.effect = nil
            
        }) { (success:Bool) in
            self.viewSelectedAppointment.removeFromSuperview()
        }
        visualEffectView.isHidden = true
    }
    
    func updateStatus(_ status: String) {
        Appointment.updateStatus(id: selectedAppointment.id!, status: status, {
            result in
                if let error = result.error {
                    self.alert.show("Error", alertDescription: "Could not excute")
                } else {
                    let appointmentWrapper = result.value
                    self.addAppointmentsFromWrapper(appointmentWrapper)
                    self.alert.show("Success!", alertDescription: "Appointment \(status)")
                }
        })
    }
    
    @IBAction func approved() {
        updateStatus("Approved")
        selectedAppointment.status = "Approved"
        self.tableAppointment.reloadData()
        animateOut()
    }
    
    @IBAction func rejected() {
        updateStatus("Rejected")
        selectedAppointment.status = "Rejected"
        self.tableAppointment.reloadData()
        animateOut()
    }
    
    @IBAction func cancelled() {
        updateStatus("Cancelled")
        selectedAppointment.status = "Cancelled"
        self.tableAppointment.reloadData()
        animateOut()
    }
    
    @IBAction func closeDetail() {
        animateOut()
    }
    
    @IBAction func completed() {
        updateStatus("Completed")
        selectedAppointment.status = "Completed"
        self.tableAppointment.reloadData()
        animateOut()
    }

}
