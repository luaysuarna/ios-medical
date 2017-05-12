//
//  BaseViewController.swift
//  medical
//
//  Created by Luay Suarna on 3/6/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
    
    var currentUser = CurrentUser(SessionModel.getCurrentUser())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        
        actionMenu(index)
    }
    
    func actionMenu(_ index: Int32) {
        if currentUser.role == "Doctor" {
            switch(index){
            case 0:
                self.openViewControllerBasedOnIdentifier("Welcome")
                break
            case 1:
                self.openViewControllerBasedOnIdentifier("Appointment")
                break
            case 2:
                self.openViewControllerBasedOnIdentifier("Appointment")
                break
            case 3:
                SessionModel.setAuthToken("")
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                break
            default:
                print("default\n", terminator: "")
            }
        } else if currentUser.role == "Nurse" {
            switch(index){
            case 0:
                self.openViewControllerBasedOnIdentifier("Welcome")
                break
            case 1:
                self.openViewControllerBasedOnIdentifier("Welcome")
                break
            case 2:
                self.openViewControllerBasedOnIdentifier("Welcome")
                break
            case 3:
                self.openViewControllerBasedOnIdentifier("Welcome")
                break
            case 4:
                SessionModel.setAuthToken("")
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                break
            default:
                print("default\n", terminator: "")
            }
        } else if currentUser.role == "Patient" {
            switch(index){
            case 0:
                self.openViewControllerBasedOnIdentifier("Welcome")
                break
            case 1:
                self.openViewControllerBasedOnIdentifier("Appointment")
                break
            case 2:
                SessionModel.setAuthToken("")
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                break
            default:
                print("default\n", terminator: "")
            }
        } else if currentUser.role == "Cashier" {
            switch(index){
            case 0:
                self.openViewControllerBasedOnIdentifier("Welcome")
                break
            case 1:
                self.openViewControllerBasedOnIdentifier("Purchase")
                break
            case 2:
                self.openViewControllerBasedOnIdentifier("Cashier")
                break
            case 3:
                SessionModel.setAuthToken("")
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                break
            default:
                print("default\n", terminator: "")
            }
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        print("Added navigation Bar")
        
        let btnShowMenu = UIButton(type: UIButtonType.system)
        btnShowMenu.setImage(self.defaultMenuImage(), for: UIControlState())
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
    }
    
    func defaultMenuImage() -> UIImage {
        var defaultMenuImage = UIImage()
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return defaultMenuImage;
    }
    
    func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuController
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChildViewController(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
}
