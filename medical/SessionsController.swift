//
//  ViewController.swift
//  medical
//
//  Created by Luay Suarna on 3/1/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit
import Alamofire

class SessionsController: UIViewController {
    
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var titleApp: UILabel!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    let alertMessage = AlertMessage()
    let authToken    = SessionModel.getAuthToken()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup View
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let token = SessionModel.getAuthToken()
        
        if token != "" {
            self.performSegue(withIdentifier: "moveSigned", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login() {
        if emailField.text == "" || passwordField.text == "" {
            alertMessage.show("Opps!", alertDescription: "We can't proceed because one of the fields is blank. Please note that all fields are required.")
        } else {
            signIn()
        }
        
    }
    
    func setupView() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let fontTitleApp = UIFont(name: "Avenir-Light", size: 30.0)
        let fontButton = UIFont(name: "Avenir-Light", size: 18.0)
        var emailFrameRect = emailField.frame
        var passwordFrameRect = passwordField.frame
        
        backgroundImage.addSubview(blurEffectView)
        titleApp.font = fontTitleApp
        emailFrameRect.size.height = 45
        passwordFrameRect.size.height = 45
        
        submitButton.titleLabel?.font = fontButton
        emailField.frame = emailFrameRect
        passwordField.frame = passwordFrameRect
    }
    
    func signIn() {
        Alamofire.request(SessionRoute.login(email: emailField.text!, password: passwordField.text!)).responseJSON { response in
            
            if response.result.value == nil {
                self.alertMessage.show("Opps!", alertDescription: "We can't proceed. Please check again your account")
            } else {
                if let responseJson = response.result.value as? [String: Any] {
                    let status = responseJson["status"] as! Bool
                    let message = responseJson["message"] as! String
                    
                    if status {
                        let user = responseJson["data"] as! [String: Any]
                        let authToken = user["token"] as! String
                        
                        SessionModel.setAuthToken(authToken as NSString)
                        SessionModel.setCurrentUser(user)
                        
                        self.resetFields()
                        self.performSegue(withIdentifier: "moveSigned", sender: nil)
                    } else {
                        self.alertMessage.show("Opps!", alertDescription: message)
                    }
                }
            }
        }
    }
    
    func resetFields() {
        emailField.text = ""
        passwordField.text = ""
    }
}

