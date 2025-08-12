//
//  SettingsVC.swift
//  The Keto Bible
//
//  Created by Laura Day on 1/8/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring
import SwiftMessages
import FirebaseAuth

class SettingsVC : UIViewController  {

    var titleLbl = UILabel()
    var menuBtn = SpringButton()
    var meBtn : SettingsButton!
    var favBtn : SettingsButton!
    var notifBtn : SettingsButton!
    var genBtn : SettingsButton!
    var helpBtn : SettingsButton!
    var passwordBtn : SettingsButton!
    var logoutBtn : SettingsButton!
    
    var messageViewCorrect : MessageView!
    
    static let loggedOutNotif = NSNotification.Name(rawValue: "LogoutPressedNotif")



    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil


        
        self.meBtn = SettingsButton(iconImg: UIImage(named: "nameIcon")!, title: "Me", desc: UserManager.shared.getUserName())
        self.favBtn = SettingsButton(iconImg: UIImage(named: "favsIcon")!, title: "Favourites", desc: "Clear All")
        self.notifBtn = SettingsButton(iconImg: UIImage(named: "notifIcon")!, title: "Notifications", desc: "All") //todo
        
        if UserManager.shared.getWifiSync() {
            self.genBtn = SettingsButton(iconImg: UIImage(named: "generalIcon")!, title: "General", desc: "Sync only on wifi")
        } else {
            self.genBtn = SettingsButton(iconImg: UIImage(named: "generalIcon")!, title: "General", desc: "Sync Always")
        }
        self.helpBtn = SettingsButton(iconImg: UIImage(named: "helpIcon")!, title: "Help", desc: "Contact Us")
        self.passwordBtn = SettingsButton(iconImg: UIImage(named: "passwordIcon")!, title: "Password", desc: "Reset Password")
        self.logoutBtn = SettingsButton(iconImg: UIImage(named: "logoutIcon")!, title: "Logout", desc: UserManager.shared.getEmail())
        
        self.messageViewCorrect = MessageView.viewFromNib(layout: .cardView)
        messageViewCorrect.configureTheme(.success)
        messageViewCorrect.configureDropShadow()
        messageViewCorrect.button?.isHidden = true
        messageViewCorrect.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (messageViewCorrect.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        self.view.backgroundColor = .white
       let ketoBibleStr : String = StyleManager.titleString

       let ketoBibleText = NSMutableAttributedString(string: ketoBibleStr, attributes: [NSAttributedString.Key.font: StyleManager.topTitleFont!])
       if StyleManager.isKeto {
           ketoBibleText.addAttributes([ NSAttributedString.Key.font : StyleManager.topTitleFontBold! ], range: NSMakeRange(4, 4));
       } else {
           ketoBibleText.addAttributes([ NSAttributedString.Key.font : StyleManager.topTitleFontBold! ], range: NSMakeRange(4, 5));
       }
       ketoBibleText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: NSMakeRange(0, ketoBibleStr.count))
       
        titleLbl.attributedText = ketoBibleText
        self.view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints{ (make) in
            make.top.equalTo(self.view.snp.top).offset(StyleManager.topOffset)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
       
         let menuIcon = UIImage(named: "menuIcon.pdf")
         menuBtn.setImage(menuIcon, for: .normal)

        self.view.addSubview(menuBtn)
        self.menuBtn.snp.makeConstraints{ (make) in
            make.centerY.equalTo(self.titleLbl.snp.centerY)
            make.right.equalTo(self.view.snp.right).offset(-20)
        }
        
        self.menuBtn.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)

        
        let settingsTitle = UILabel()
        settingsTitle.text = "Your settings"
        settingsTitle.textColor = UIColor(red:0.23, green:0.23, blue:0.23, alpha:1.00)
        settingsTitle.font = StyleManager.ingredLblFont
        self.view.addSubview(settingsTitle)
        settingsTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.left).offset(20)
        }
        
        let offset = 15
        let btnGap = 20
        var btnHeigh = 63
        
        if UIDevice().type == .iPhone8 || UIDevice().type == .iPhone7 || UIDevice().type == .iPhone6 || UIDevice().type == .iPhone6S {
            btnHeigh = 53
        } else if UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE || UIDevice().type == .iPhone5S{
            btnHeigh = 40
        }
         
        self.view.addSubview(meBtn)
        meBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(offset)
            make.right.equalTo(self.view.snp.right).offset(-offset)
            make.height.equalTo(btnHeigh)
            make.top.equalTo(settingsTitle.snp.bottom).offset(20)
        }
        meBtn.addTarget(self, action: #selector(meBtnPressed), for: .touchUpInside)
        
        self.view.addSubview(favBtn)
        favBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(offset)
            make.right.equalTo(self.view.snp.right).offset(-offset)
            make.height.equalTo(btnHeigh)
            make.top.equalTo(meBtn.snp.bottom).offset(btnGap)
        }
        favBtn.addTarget(self, action: #selector(favsBtnPressed), for: .touchUpInside)

        
        self.view.addSubview(notifBtn)
        notifBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(offset)
            make.right.equalTo(self.view.snp.right).offset(-offset)
            make.height.equalTo(btnHeigh)
            make.top.equalTo(favBtn.snp.bottom).offset(btnGap)
        }
        notifBtn.addTarget(self, action: #selector(notifBtnPressed), for: .touchUpInside)

        
        self.view.addSubview(genBtn)
        genBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(offset)
            make.right.equalTo(self.view.snp.right).offset(-offset)
            make.height.equalTo(btnHeigh)
            make.top.equalTo(notifBtn.snp.bottom).offset(btnGap)
        }
        genBtn.addTarget(self, action: #selector(genBtnPressed), for: .touchUpInside)

        
        self.view.addSubview(helpBtn)
        helpBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(offset)
            make.right.equalTo(self.view.snp.right).offset(-offset)
            make.height.equalTo(btnHeigh)
            make.top.equalTo(genBtn.snp.bottom).offset(btnGap)
        }
        helpBtn.addTarget(self, action: #selector(helpBtnPressed), for: .touchUpInside)

        
        self.view.addSubview(passwordBtn)
        passwordBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(offset)
            make.right.equalTo(self.view.snp.right).offset(-offset)
            make.height.equalTo(btnHeigh)
            make.top.equalTo(helpBtn.snp.bottom).offset(btnGap)
        }
        passwordBtn.addTarget(self, action: #selector(passBtnPressed), for: .touchUpInside)

        
        self.view.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(offset)
            make.right.equalTo(self.view.snp.right).offset(-offset)
            make.height.equalTo(btnHeigh)
            make.top.equalTo(passwordBtn.snp.bottom).offset(btnGap)
        }
        logoutBtn.addTarget(self, action: #selector(logoutBtnPressed), for: .touchUpInside)

        
        
        
    }
    
    @objc func menuButtonSelected() {
           panel?.openLeft(animated: true)
       }
       
    
    @objc func meBtnPressed() {
        //version 2.0
        /*self.meBtn.pop {
        } */
    }
    
    @objc func favsBtnPressed() {
        
        
        self.favBtn.pop {
            DataManager.sharedInstance.removeAllFavs()
            self.messageViewCorrect.configureContent(title: "Favourites Removed", body: "All favourites have now been cleared.")
            SwiftMessages.show(view: self.messageViewCorrect)
        }
    }
    
    @objc func notifBtnPressed() {
        self.notifBtn.pop {
            print("v2.0")
            if self.notifBtn.descLbl.text == "All" {
                self.notifBtn.descLbl.text = "All Notifications Off"
            } else {
                self.notifBtn.descLbl.text = "All"
            }
        }
    }
    
    @objc func genBtnPressed() {
        self.genBtn.pop {
            if self.genBtn.descLbl.text == "Sync Always" {
                self.genBtn.descLbl.text = "Sync only on wifi"
                UserManager.shared.setWifiSync(sync: true)
            } else {
                self.genBtn.descLbl.text = "Sync Always"
                UserManager.shared.setWifiSync(sync: false)
            }
        }
    }
    
    @objc func helpBtnPressed() {
        self.helpBtn.pop {
            self.messageViewCorrect.configureContent(title: "Contact Us", body: "Please email us at contact@theketohack.com.au")
            SwiftMessages.show(view: self.messageViewCorrect)
        }
    }
    
    @objc func passBtnPressed() {
        self.passwordBtn.pop {
            Auth.auth().sendPasswordReset(withEmail: UserManager.shared.getEmail()) { error in
                if error == nil {
                    self.messageViewCorrect.configureContent(title: "Email Sent", body: "Password reset email sent. ")
                    SwiftMessages.show(view: self.messageViewCorrect)
                } else {
                    print("error: " + error!.localizedDescription)
                }
            }
        }
    }
    
    @objc func logoutBtnPressed() {
        self.logoutBtn.pop {
            NotificationCenter.default.post(name: SettingsVC.loggedOutNotif, object: nil)
        }
    }

}
