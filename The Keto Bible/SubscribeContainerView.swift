//
//  SubscribeContainerView.swift
//  The Keto Hack
//
//  Created by Laura Day on 14/4/20.
//  Copyright © 2020 Laura Day. All rights reserved.
//


import UIKit
import Spring
import SnapKit

class SubscribeContainerView: SpringView {


    let borderColor = UIColor(red:0.76, green:0.75, blue:0.75, alpha:1.00)
    let borderColorSelected = UIColor.black

    let topLabel = UILabel()
    let durationTitleLbl = UILabel()
    let trialLabel = UILabel()
    let priceLabel = UILabel()
    let whiteBox = UIView()


    var selected = false


    init(showTop: Bool) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        
        
        
        

        whiteBox.backgroundColor = .white
        whiteBox.layer.opacity = 0.8
        whiteBox.layer.cornerRadius = 5
        whiteBox.layer.borderWidth = 2.0
        whiteBox.layer.borderColor = borderColor.cgColor

        self.addSubview(whiteBox)
        
        if showTop {
            self.addSubview(topLabel)
            topLabel.backgroundColor = .white
            topLabel.layer.borderColor = UIColor.black.cgColor
            topLabel.layer.borderWidth = 0.5
            topLabel.snp.makeConstraints { (make) in
                make.centerX.equalTo(snp.centerX)
                make.top.equalTo(snp.top).offset(6)
                make.width.equalTo(160)
                make.height.equalTo(20)
            }
        }
        topLabel.layer.cornerRadius = 10
        topLabel.clipsToBounds = true
        topLabel.textColor = .black
        topLabel.font = UIFont(name: "Avenir-Heavy", size: 9)
        topLabel.text = "Most Popular"
        topLabel.textAlignment = .center

        
        if showTop {
            whiteBox.snp.makeConstraints { (make) in
                make.left.equalTo(snp.left)
                make.right.equalTo(snp.right)
                make.bottom.equalTo(snp.bottom)
                make.top.equalTo(topLabel.snp.centerY)
            }
        } else {
            whiteBox.snp.makeConstraints { (make) in
                make.left.equalTo(snp.left)
                make.right.equalTo(snp.right)
                make.bottom.equalTo(snp.bottom)
                make.top.equalTo(snp.top)
            }
        }
        
        
        durationTitleLbl.font = UIFont(name: "Avenir-Black", size: 13)
        durationTitleLbl.textColor = .gray
        durationTitleLbl.textAlignment = .center
        self.addSubview(durationTitleLbl)
        
        
        trialLabel.text = "7 Day Free Trial"
        trialLabel.textColor = .black
        trialLabel.textAlignment = .center
        trialLabel.font = UIFont(name: "Avenir-Black", size: 18)
        self.addSubview(trialLabel)
        trialLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.whiteBox.snp.centerX)
            make.centerY.equalTo(self.whiteBox.snp.centerY)
        }
        
        durationTitleLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            if showTop {
                make.bottom.equalTo(trialLabel.snp.top).offset(1)
            } else {
                make.bottom.equalTo(trialLabel.snp.top).offset(-1)
            }
            
        }
        
 
        priceLabel.textColor = .gray
        priceLabel.font = UIFont(name: "Avenir-Light", size: 11)
        self.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(whiteBox.snp.centerX)
            make.top.equalTo(trialLabel.snp.bottom).offset(1)
        }
        
        let saveBadge = UIImageView(image: UIImage(named: "save30Badge"))
        
        if showTop {
            self.addSubview(saveBadge)
            saveBadge.snp.makeConstraints { (make) in
                make.left.equalTo(whiteBox.snp.left).offset(4)
                make.top.equalTo(whiteBox.snp.top).offset(4)

            }
        }

    }
    
    func setAnnualBtn() {
        durationTitleLbl.text = "Annual"
        let annualProduct = SubscriptionManager.sharedInstance.getYearlyProduct()
        if annualProduct != nil {
            let priceYear = Double(truncating: annualProduct!.price)
            let productPrice = String(format:"%.2f", priceYear)
            let currency = annualProduct?.priceLocale.currencySymbol
            let priceStr = currency! + productPrice
            let annualString = "then "  + priceStr + " billed annually"
            priceLabel.text = annualString
        }
    }
    
    func setMonthlyBtn() {
        durationTitleLbl.text = "Monthly"

        let monthlyProduct = SubscriptionManager.sharedInstance.getMonthlyProduct()
        
        if monthlyProduct != nil {
            let productPriceMonthly = String(format:"%.2f", Double(truncating: monthlyProduct!.price))
            let currencyMonth = monthlyProduct?.priceLocale.currencySymbol
            let priceStrMonth = currencyMonth! + productPriceMonthly
            let monthlyString = "then "  + priceStrMonth + " billed monthly"
            
            priceLabel.text = monthlyString
        }
    }



    func setSelected(selected: Bool) {
        self.selected = selected

        if selected {
            whiteBox.layer.borderColor = borderColorSelected.cgColor
        } else {
            whiteBox.layer.borderColor = borderColor.cgColor
        }

    }

    func isSelected() -> Bool {
        return self.selected
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
