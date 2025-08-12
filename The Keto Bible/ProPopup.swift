//
//  ProPopup.swift
//  The Keto Hack
//
//  Created by Laura Day on 14/4/20.
//  Copyright © 2020 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring
import SwiftMessages
import SnapKit


@objc protocol ProPopupDelegate: AnyObject {
    func annualContinuePressed()
    func monthlyContinuePressed()
    func closePressed()
}

class ProPopup : UIView, UITextViewDelegate  {

    @objc var delegate : ProPopupDelegate?
    let bg = UIView()
    let container = UIView()
    let containerTop = UIView()

    let title = UILabel()

    var annualContainer : SubscribeContainerView!
    var monthlyContainer : SubscribeContainerView!
    
    var restorePurchasesBtn = SpringButton()
    var continueButton = SpringButton()
    var errorView : MessageView!

    let gradientLayer = CAGradientLayer()

    let privacyTextView = UITextView()
    let closeBtn = SpringButton()

    
    init() {
        super.init(frame: CGRect.zero)
        
        self.errorView = MessageView.viewFromNib(layout: .cardView)
                                              errorView.configureTheme(.warning)
                                              errorView.configureDropShadow()
                                              errorView.button?.isHidden = true
                                              errorView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                                              (errorView.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        self.backgroundColor = .clear
        
        self.bg.backgroundColor = UIColor(red:0.29, green:0.29, blue:0.29, alpha:0.4)
        
        
        self.bg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closePopup)))
        
        self.addSubview(bg);
        bg.snp.makeConstraints { (make) in
            make.edges.equalTo(snp.edges)
        }
        
        
        SubscriptionManager.sharedInstance.loadProducts {
            self.updateButtons()
        }
        
        
        self.addSubview(container);
        if UIDevice.current.type != .iPhone5 && UIDevice.current.type != .iPhone5C && UIDevice.current.type != .iPhone5S && UIDevice.current.type != .iPhoneSE {
            container.layer.cornerRadius = 25.0;
        }
        container.clipsToBounds = true;
                
        
        container.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
            if UIDevice.current.type == .iPhone6Plus || UIDevice.current.type == .iPhone6SPlus || UIDevice.current.type == .iPhone7Plus || UIDevice.current.type == .iPhone8Plus {
                make.height.equalTo(self.snp.height).multipliedBy(0.8)
                make.width.equalTo(self.snp.width).multipliedBy(0.85)
            } else if UIDevice.current.type == .iPhone6 || UIDevice.current.type == .iPhone6S || UIDevice.current.type == .iPhone7 || UIDevice.current.type == .iPhone6S || UIDevice.current.type == .iPhone8 {
                make.height.equalTo(self.snp.height).multipliedBy(0.95)
                make.width.equalTo(self.snp.width).multipliedBy(0.85)
            } else if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhoneSE {
                make.height.equalTo(self.snp.height)
                make.width.equalTo(self.snp.width)
            } else if StyleManager.isIpad() {
                make.height.equalTo(self.snp.height).multipliedBy(0.65)
                make.width.equalTo(self.snp.width).multipliedBy(0.65)

            } else {
                make.height.equalTo(self.snp.height).multipliedBy(0.75)
                make.width.equalTo(self.snp.width).multipliedBy(0.85)
            }
        }
        
        
        //only apply the blur if the user hasn't disabled transparency effects
        if !UIAccessibility.isReduceTransparencyEnabled {
            container.backgroundColor = .clear

            let blurEffect = UIBlurEffect(style: .extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.container.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            container.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
            
            //container.layer.opacity = 0.4
        } else {
            container.backgroundColor = .white
        }
        
        self.addSubview(containerTop);
        if UIDevice.current.type != .iPhone5 && UIDevice.current.type != .iPhone5C && UIDevice.current.type != .iPhone5S && UIDevice.current.type != .iPhoneSE {
                   containerTop.layer.cornerRadius = 25.0;
        }
        containerTop.clipsToBounds = true;
                
        
        containerTop.snp.makeConstraints { (make) in
            make.edges.equalTo(container.snp.edges)
        }
        containerTop.backgroundColor = .white
        containerTop.layer.opacity = 0.3
        
        
        self.title.text = "Try Our Pro Version!"
        
        self.title.textAlignment = .center
        title.font = UIFont(name: "Avenir-Heavy", size: 28)
        let boldFont = UIFont(name: "Avenir-Black", size: 28)
        title.changeFont(ofText: "Pro Version", with: boldFont!)
        title.adjustsFontSizeToFitWidth = true
        title.textColor = .black
        title.numberOfLines = 2
        
        self.addSubview(title)
        self.title.snp.makeConstraints { (make) in
            make.centerX.equalTo(container.snp.centerX)
            if StyleManager.isIpad() {
                make.top.equalTo(self.container.snp.top).offset(80)
            } else {
                make.top.equalTo(self.container.snp.top).offset(30)
            }
            make.width.equalTo(self.container.snp.width).offset(-50)
            make.height.equalTo(80)
        }
        
        let optionLbl = UILabel()
        optionLbl.text = "Choose an option"
        optionLbl.textColor = .black
        optionLbl.font = UIFont(name: "Avenir-Black", size: 18)
        optionLbl.numberOfLines = 1
        optionLbl.adjustsFontSizeToFitWidth = true
        
        self.addSubview(optionLbl)
        optionLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(container.snp.centerX)
            make.top.equalTo(self.title.snp.bottom).offset(0)
        }
       
        self.annualContainer = SubscribeContainerView(showTop: true)
        self.monthlyContainer = SubscribeContainerView(showTop: false)
        
        self.annualContainer.setAnnualBtn()
        self.monthlyContainer.setMonthlyBtn()
        
        self.addSubview(annualContainer)
        annualContainer.snp.makeConstraints { (make) in
            make.top.equalTo(optionLbl.snp.bottom).offset(20)
            make.height.equalTo(92)
            if StyleManager.isIpad() {
                make.width.equalTo(370)
            } else {
                make.width.equalTo(270)
            }
            make.centerX.equalTo(self.snp.centerX)
        }
        
        self.addSubview(monthlyContainer)
        monthlyContainer.snp.makeConstraints { (make) in
            make.top.equalTo(annualContainer.snp.bottom).offset(15)
            make.height.equalTo(82)
            make.width.equalTo(annualContainer.snp.width)
            make.centerX.equalTo(self.snp.centerX)

        }
        
        annualContainer.setSelected(selected: true)
        monthlyContainer.setSelected(selected: false)
              
        annualContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(annualSelected)))
        monthlyContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(monthlySelected)))

        self.addSubview(restorePurchasesBtn)
        restorePurchasesBtn.setTitle("Restore Purchases", for: .normal)
        restorePurchasesBtn.setTitleColor(.white, for: .normal)
        if StyleManager.isIpad() {
            restorePurchasesBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 21)
        } else {
            restorePurchasesBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 15)
        }
        restorePurchasesBtn.setTitleColor(.black, for: .normal)
        restorePurchasesBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.container.snp.centerX)
            make.top.equalTo(self.monthlyContainer.snp.bottom).offset(3)
        }
               
        self.restorePurchasesBtn.addTarget(self, action: #selector(restorePressed), for: .touchUpInside)
        
        
        self.continueButton.backgroundColor = .black
        self.continueButton.setTitleColor(.white, for: .normal)
        self.continueButton.setTitle("START FREE TRIAL", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 12)
        
        self.continueButton.layer.cornerRadius = 9
        self.addSubview(continueButton)
        continueButton.snp.makeConstraints { (make) in
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhoneSE  {
                make.top.equalTo(restorePurchasesBtn.snp.bottom)
            } else {
                make.top.equalTo(restorePurchasesBtn.snp.bottom).offset(20)

            }
            
            make.width.equalTo(monthlyContainer.snp.width)
            make.height.equalTo(35)
            make.centerX.equalTo(self.snp.centerX)
        }
        self.continueButton.addTarget(self, action: #selector(continuePressed), for: .touchUpInside)
        
        self.applyPrivacyText()
        self.privacyTextView.textColor = .black
        self.privacyTextView.textAlignment = .center
        self.privacyTextView.backgroundColor = .clear
        self.privacyTextView.showsVerticalScrollIndicator = false
        self.addSubview(privacyTextView)
        privacyTextView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.container.snp.centerX)
            make.bottom.equalTo(self.container.snp.bottom).offset(-10)
            make.height.equalTo(130)
            if StyleManager.isIpad() {
                make.width.equalTo(self.continueButton.snp.width)
            } else {
                make.width.equalTo(self.container.snp.width).offset(-50)
            }
        }
            
        privacyTextView.isEditable = false
        privacyTextView.isSelectable = true
        
        privacyTextView.delegate = self

        closeBtn.setImage(UIImage(named: "closeIcon"), for: .normal)
        self.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { (make) in
            make.top.equalTo(container.snp.top).offset(20)
            make.left.equalTo(container.snp.left).offset(15)
        }
        closeBtn.addTarget(self, action: #selector(closeBtnPressed), for: .touchUpInside)
        
        
    }
    
    @objc func closeBtnPressed() {
        self.closeBtn.pop {
            PopupController.closePopup(self)
        }
    }
    
    func applyPrivacyText() {
        var finePrintStr : String?
        
        let privacyPolicyStr = "Privacy Policy"
        let termsStr = "Terms of Use"
        let billingTermsStr = "Billing Terms"

        finePrintStr = "After the 7-day free trial this subscription automatically renews unless canceled at least 24-hours before the end of the trial period. Your Apple ID account will be charged for renewal within 24 hours before the end of the trial period, for the cost indicated above. You can manage and cancel your subscriptions by going to your App Store account settings after purchase. By continuing you accept our Privacy Policy, Terms of Use, and Billing Terms."
        
        let mainRange =  NSMakeRange(0, (finePrintStr! as NSString).length)
        let privacyStrRange = (finePrintStr! as NSString).range(of: privacyPolicyStr)
        let termsRange = (finePrintStr! as NSString).range(of: termsStr)
        let billingRange = (finePrintStr! as NSString).range(of: billingTermsStr)
        let attributedString = NSMutableAttributedString(string: finePrintStr!)
        
        let newPrivacyFont = UIFont(name: "Avenir-Book", size: 11)!
        attributedString.addAttribute(NSAttributedString.Key.font, value: newPrivacyFont, range: mainRange)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 0.5
        paragraphStyle.lineHeightMultiple = 0.8
        paragraphStyle.alignment = .center
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: mainRange)
        
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyStrRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: billingRange)
        
        attributedString.addAttribute(NSAttributedString.Key.link, value: DataManager.privacyPolicyURL, range: privacyStrRange)
        attributedString.addAttribute(NSAttributedString.Key.link, value: DataManager.privacyPolicyURL, range: termsRange)
        attributedString.addAttribute(NSAttributedString.Key.link, value: DataManager.privacyPolicyURL, range: billingRange)
        
        
        privacyTextView.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([ NSAttributedString.Key.foregroundColor.rawValue: UIColor.black ])

        
        privacyTextView.attributedText = attributedString
    }
    
    
    func disableButtons() {
        self.restorePurchasesBtn.isEnabled = false
        self.continueButton.isEnabled = false
    }
       
    func enableButtons() {
         self.restorePurchasesBtn.isEnabled = true
        self.continueButton.isEnabled = true
    }
    
    @objc func continuePressed() {
        self.continueButton.pop {
            //self.disableButtons()
            if self.annualContainer.isSelected() {
                self.purchaseAnnual()
            } else if self.monthlyContainer.isSelected() {
                self.purchaseMonthly()
            }
        }
    }
       
    
    @objc func restorePressed() {
        self.disableButtons()
        self.restorePurchasesBtn.pop {
            SubscriptionManager.sharedInstance.restore(showAlerts: true) { (restoreSuccessful, error) in
                self.enableButtons()
                if error != nil {
                    self.errorView.configureContent(title: "Error Restoring", body:error!.description)
                    SwiftMessages.show(view: self.errorView)
                }
            }
        }
    }
    
    @objc func closePopup() {
        PopupController.closePopup(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func showLoadingIndicator(show: Bool) {
           self.continueButton.loadingIndicator(show)
           if show {
            self.continueButton.setTitle("", for: .normal)
           } else {
            self.continueButton.setTitle("START FREE TRIAL", for: .normal)
           }
       }
    
    
    
    @objc func annualSelected() {
        annualContainer.setSelected(selected: true)
        monthlyContainer.setSelected(selected: false)
    }
    
    func purchaseAnnual() {
        self.showLoadingIndicator(show: true)
        SubscriptionManager.sharedInstance.purchaseYearly(completion: { (details, error) in
            
            self.showLoadingIndicator(show: false)
            if error == nil {
                NotificationCenter.default.post(name: SubscriptionManager.purchaseComplete, object: nil)
                PopupController.closePopup(self)
            } else {
                if error! != "" {
                    UserManager.shared.hasPro(proVersion: false)
                    self.errorView.configureContent(title: "Error", body:error!.description)
                    SwiftMessages.show(view: self.errorView)
                    print(error!.description)
                }
                
            }
        })
    }
    
    func purchaseMonthly() {
        self.showLoadingIndicator(show: true)
               SubscriptionManager.sharedInstance.purchaseMonthly(completion: { (details, error) in
                   
                   self.showLoadingIndicator(show: false)
                   if error == nil {
                       NotificationCenter.default.post(name: SubscriptionManager.purchaseComplete, object: nil)
                       PopupController.closePopup(self)
                   } else {
                       if error! != "" {
                           UserManager.shared.hasPro(proVersion: false)
                           self.errorView.configureContent(title: "Error", body:error!.description)
                           SwiftMessages.show(view: self.errorView)
                           print(error!.description)
                       }
                       
                   }
               })
    }
    
    @objc func monthlySelected() {
        annualContainer.setSelected(selected: false)
        monthlyContainer.setSelected(selected: true)
    }
    
    func updateButtons() {
        monthlyContainer.setMonthlyBtn()
        annualContainer.setAnnualBtn()
    }
    
     func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let privacyURL = URL
        
        UIApplication.shared.open(privacyURL, options: [:]) { (result) in
            //
        }

        return true
        
    }
    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
