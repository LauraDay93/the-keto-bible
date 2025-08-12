//
//  SubscribeVC.swift
//  The Keto Bible
//
//  Created by Laura Day on 1/9/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring
import SwiftMessages

class SubscribeVC : UIViewController  {
    

    let bg = UIImageView(image: UIImage(named: "subscribeBG"))
    let logoImg = UIImage(named: "KTBLogo.pdf")

    let topTitleLbl = UILabel()

    let optionLbl = UILabel()

    
    var annualBtn = SubscribeButtonView()
    var monthlyBtn = SubscribeButtonView()
        
    var restoreBtn = SpringButton()
    
    let privacyTextView = UITextView()

    
    var errorView : MessageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorView = MessageView.viewFromNib(layout: .cardView)
                                              errorView.configureTheme(.warning)
                                              errorView.configureDropShadow()
                                              errorView.button?.isHidden = true
                                              errorView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
                                              (errorView.backgroundView as? CornerRoundingView)?.cornerRadius = 10

        
        self.updateButtons()


        
        self.view.addSubview(bg)
        bg.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(-3)
            make.right.equalTo(self.view.snp.right).offset(3)
            make.top.equalTo(self.view.snp.top).offset(-3)
            make.bottom.equalTo(self.view.snp.bottom).offset(3)
        }
        
        let logoImgView = UIImageView(image: logoImg)
        self.view.addSubview(logoImgView)
        logoImgView.snp.makeConstraints{ (make) in
            switch UIDevice().type {
            case .iPhone8, .iPhone6, .iPhone6S, .iPhone7, .iPhoneSE, .iPhone5C, .iPhone5S, .iPhone5:
                make.top.equalTo(self.view.snp.top).offset(30)
            case .iPhone8Plus, .iPhone7Plus, .iPhone6Plus, .iPhone6SPlus:
                make.top.equalTo(self.view.snp.top).offset(70)
            default:
                make.top.equalTo(self.view.snp.top).offset(120)
            }
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        
        if StyleManager.isKeto {
            topTitleLbl.text = "Try your Keto Hack \n7 Day Free Trial"

        } else {
            topTitleLbl.text = "Try your Vegan Hack \n7 Day Free Trial"

        }
        topTitleLbl.textColor = .white
        topTitleLbl.textAlignment = .center
        
        if UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5 ||  UIDevice().type == .iPhoneSE {
            topTitleLbl.font = UIFont(name: "Avenir-Book", size: 23)
                       let boldFont = UIFont(name: "Avenir-Black", size: 23)
                       topTitleLbl.changeFont(ofText: "7 Day Free Trial", with: boldFont!)
            
        } else {

           topTitleLbl.font = StyleManager.mainTitleFont
           topTitleLbl.changeFont(ofText: "7 Day Free Trial", with: StyleManager.mainTitleFontBold!)


        }
        
        topTitleLbl.numberOfLines = 2
        
        self.view.addSubview(topTitleLbl)
        topTitleLbl.snp.makeConstraints{ (make) in
            if StyleManager.isKeto {
                make.top.equalTo(logoImgView.snp.bottom).offset(15)
            } else {
                make.top.equalTo(logoImgView.snp.bottom).offset(0)
            }
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        
        self.optionLbl.text = "Choose An Option"
        self.optionLbl.textColor = .white
        if StyleManager.isIpad() {
            self.optionLbl.font = UIFont(name: "Avenir-Black", size: 25)
        } else {
            self.optionLbl.font = UIFont(name: "Avenir-Black", size: 18)
        }
        
        self.view.addSubview(optionLbl)
        optionLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            if UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
                make.top.equalTo(self.topTitleLbl.snp.bottom).offset(15)
            } else {
                make.top.equalTo(self.topTitleLbl.snp.bottom).offset(30)

            }
        }
        

        annualBtn.addTarget(self, action: #selector(annualBtnPressed), for: .touchUpInside)
    
        self.view.addSubview(annualBtn)
        annualBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            if StyleManager.isIpad() {
                make.width.equalTo(451)
                make.height.equalTo(130)

            } else {
                make.width.equalTo(281)
                make.height.equalTo(80)
            }
            if UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
                make.top.equalTo(optionLbl.snp.bottom).offset(15)
            } else {
                make.top.equalTo(optionLbl.snp.bottom).offset(25)
            }
        }

        
        monthlyBtn.addTarget(self, action: #selector(monthlyBtnPressed), for: .touchUpInside)

        self.view.addSubview(monthlyBtn)
        monthlyBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            if StyleManager.isIpad() {
                make.width.equalTo(451)
                make.height.equalTo(130)
            } else {
                make.width.equalTo(281)
                make.height.equalTo(80)
            }
            
            if UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
                make.top.equalTo(annualBtn.snp.bottom).offset(20)
            } else {
                make.top.equalTo(annualBtn.snp.bottom).offset(40)

            }
        }
        
        self.view.addSubview(restoreBtn)
        restoreBtn.setTitle("Restore Purchases", for: .normal)
        restoreBtn.setTitleColor(.white, for: .normal)
        if StyleManager.isIpad() {
            restoreBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 21)
        } else {
            restoreBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 15)
        }
        restoreBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.monthlyBtn.snp.bottom).offset(5)
        }
        
        self.restoreBtn.addTarget(self, action: #selector(restorePressed), for: .touchUpInside)
        
        self.applyPrivacyText()
        self.privacyTextView.textColor = .white
        self.privacyTextView.textAlignment = .center
        self.privacyTextView.backgroundColor = .clear
        self.privacyTextView.showsVerticalScrollIndicator = false
        self.view.addSubview(privacyTextView)
        privacyTextView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            if UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
                make.top.equalTo(self.restoreBtn.snp.bottom).offset(5)
                make.height.equalTo(130)
                make.width.equalTo(self.view.snp.width).offset(-20)
            } else if UIDevice().type == .iPhone8Plus || UIDevice().type == .iPhone8Plus || UIDevice().type == .iPhone8Plus || UIDevice().type == .iPhone7Plus || UIDevice().type == .iPhone6Plus || UIDevice().type == .iPhone6SPlus {
                make.bottom.equalTo(self.view.snp.bottom).offset(-20)
                make.height.equalTo(130)
                make.width.equalTo(self.view.snp.width).offset(-50)
            } else if StyleManager.isIpad() {
                make.bottom.equalTo(self.view.snp.bottom).offset(-10)
                make.height.equalTo(90)
                make.width.equalTo(self.view.snp.width).offset(-50)
            } else {
                make.bottom.equalTo(self.view.snp.bottom).offset(-20)
                make.height.equalTo(150)
                make.width.equalTo(self.view.snp.width).offset(-50)

            }

        }
        privacyTextView.isEditable = false
        privacyTextView.isSelectable = true
        privacyTextView.isScrollEnabled = true

        self.updateButtons()
        SubscriptionManager.sharedInstance.loadProducts {
            self.updateButtons()
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
        
        let newPrivacyFont = UIFont(name: "Avenir-Book", size: 13)!
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
        
        
        privacyTextView.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([ NSAttributedString.Key.foregroundColor.rawValue: UIColor.white ])

        
        privacyTextView.attributedText = attributedString
    }
    
    
    
    
    func updateButtons() {
        
        let annualProduct = SubscriptionManager.sharedInstance.getYearlyProduct()
        
        if annualProduct != nil {
            let priceYear = Double(truncating: annualProduct!.price)
            let productPrice = String(format:"%.2f", priceYear)
            let currency = annualProduct?.priceLocale.currencySymbol
            let priceStr = currency! + productPrice
            let annualString = "then "  + priceStr + " billed annually"
            
            
            annualBtn.setTitles(top: "Annual", bottom: annualString)

        }

    
        let monthlyProduct = SubscriptionManager.sharedInstance.getMonthlyProduct()
        
        if monthlyProduct != nil {
                let productPriceMonthly = String(format:"%.2f", Double(truncating: monthlyProduct!.price))
                let currencyMonth = monthlyProduct?.priceLocale.currencySymbol
                let priceStrMonth = currencyMonth! + productPriceMonthly
                let monthlyString = "then "  + priceStrMonth + " billed monthly"
            
                monthlyBtn.setTitles(top: "Monthly", bottom: monthlyString)


        }
        
        
    }
    
      
    @objc func annualBtnPressed() {
        self.annualBtn.pop {
            self.disableButtons()
            self.showLoadingIndicatorAnnual(show: true)
            SubscriptionManager.sharedInstance.purchaseYearly(completion: { (details, error) in
                self.showLoadingIndicatorAnnual(show: false)
                self.enableButtons()
                if error == nil {
                    NotificationCenter.default.post(name: SubscriptionManager.purchaseComplete, object: nil)
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
    }
    
    @objc func monthlyBtnPressed() {
        self.monthlyBtn.pop {
            self.disableButtons()
            self.showLoadingIndicatorMonthly(show: true)
            SubscriptionManager.sharedInstance.purchaseMonthly(completion: { (details, error) in
                self.showLoadingIndicatorMonthly(show: false)
                self.enableButtons()
                
                if error == nil {
                    NotificationCenter.default.post(name: SubscriptionManager.purchaseComplete, object: nil)
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
    }
    
    func showLoadingIndicatorMonthly(show: Bool) {
        self.monthlyBtn.loadingIndicator(show)
        if show {
            self.monthlyBtn.setTitles(top: "", bottom: "")
            self.monthlyBtn.freeTrialLbl.text = ""
        } else {
            self.updateButtons()
            self.monthlyBtn.freeTrialLbl.text = "7 Day Free Trial"

        }


    }
    
    func showLoadingIndicatorAnnual(show: Bool) {
           self.annualBtn.loadingIndicator(show)
           if show {
               self.annualBtn.setTitles(top: "", bottom: "")
               self.annualBtn.freeTrialLbl.text = ""
           } else {
               self.updateButtons()
                self.annualBtn.freeTrialLbl.text = "7 Day Free Trial"
           }
       }
    
    
    
    
    func disableButtons() {
        self.monthlyBtn.isEnabled = false
        self.annualBtn.isEnabled = false
        
    }
    
    func enableButtons() {
        self.monthlyBtn.isEnabled = true
        self.annualBtn.isEnabled = true
    }
    
    @objc func restorePressed() {
        self.disableButtons()
        self.restoreBtn.pop {
            SubscriptionManager.sharedInstance.restore(showAlerts: true) { (restoreSuccessful, error) in
                self.enableButtons()
                if error != nil {
                    UserManager.shared.hasPro(proVersion: false)
                    self.errorView.configureContent(title: "Error Restoring", body:error!.description)
                    SwiftMessages.show(view: self.errorView)
                }
            }
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

