//
//  NewAppointmentController.swift
//  medical
//
//  Created by Luay Suarna on 3/8/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit
import DateTimePicker

class NewAppointmentController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // @IBOutlet weak var datePicker: JBDatePickerView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var selectedDate: UILabel!
    @IBOutlet var labelNewAppointment: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    
    var current = Date()
    let alert = AlertMessage()
    
    var doctors: [Doctor]?
    var doctorWrapper: DoctorWrapper?
    var selectedDoctor: Doctor?
    var isLoadingDoctor = false
    var currentUser = CurrentUser(SessionModel.getCurrentUser())

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadDoctors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDoctors() {
        isLoadingDoctor = true
        Doctor.list({ result in
            if let error = result.error {
                self.isLoadingDoctor = false
                self.alert.show("Error", alertDescription: "Could not load doctors")
            }
            let doctorWrapper = result.value
            self.addDoctorsFromWrapper(doctorWrapper)
            self.isLoadingDoctor = false
            self.tableView.reloadData()
        })
    }
    
    func addDoctorsFromWrapper(_ wrapper: DoctorWrapper?)
    {
        self.doctorWrapper = wrapper
        if self.doctors == nil {
            self.doctors = self.doctorWrapper?.doctors
        } else if self.doctorWrapper != nil && self.doctorWrapper!.doctors != nil {
            self.doctors = self.doctors! + self.doctorWrapper!.doctors!
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.doctors?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let numberOfRows = tableView.numberOfRows(inSection: section)
        for row in 0..<numberOfRows {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) {
                cell.accessoryType = row == indexPath.row ? .checkmark : .none
            }
        }
        
        if (doctors?.count)! > 0 {
            let cell = tableView.cellForRow(at: indexPath)
            selectedDoctor = doctors?[indexPath.row]
            cell?.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fontStyle = UIFont(name: "Avenir-Light", size: 16.0)
        let cellIdentifier = "DoctorCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = doctors?[indexPath.row].person?.name
        cell.textLabel?.font = fontStyle
        
        return cell
    }

    @IBAction func showDateTimePicker(sender: AnyObject) {
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: current, minimumDate: min, maximumDate: max)
        
        picker.highlightColor = UIColor(red: 106.0/255.0, green: 196.0/255.0, blue: 59.0/255.0, alpha: 1)
        picker.doneButtonTitle = "Done"
        picker.todayButtonTitle = "Today"
        
        picker.completionHandler = { date in
            self.current = date
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
            self.selectedDate.text = formatter.string(from: date)
        }
    }
    
    @IBAction func bookAppintment() {
        if selectedDate.text == "Date" || selectedDoctor == nil {
            alert.show("Opps!", alertDescription: "We can't proceed because one of the fields is blank. Please note that all fields are required.")
        } else {
            
            if currentUser != nil {
                
                let patientId = String(currentUser.id)
                let doctorId = selectedDoctor?.id!
                let date = selectedDate.text
                
                Appointment.create(patientId: patientId, doctorId: doctorId!, date: date!, completionHandler: {
                    result in
                        if let error = result.error {
                            self.isLoadingDoctor = false
                            self.alert.show("Error", alertDescription: "Could not store the data")
                        } else {
                            self.alert.show("Success!", alertDescription: "Appointment successfully booked")
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    
                })
            } else {
                alert.show("Opps!", alertDescription: "We can't proceed because you need to login.")
            }
        }
    }
    
    func setupView() {
        let fontStyle = UIFont(name: "Avenir-Light", size: 16.0)
        labelNewAppointment.font = fontStyle
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        
        backgroundImage.addSubview(blurEffectView)
    }
}
