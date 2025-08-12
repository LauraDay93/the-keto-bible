//
//  SubscribeButton.swift
//  The Keto Bible
//
//  Created by Laura Day on 5/11/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring
import SnapKit


class SubscribeButtonView : SpringButton {
    
    var topTitle = UILabel()
    var freeTrialLbl = UILabel()
    var priceLbl = UILabel()
    
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.55)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5

        topTitle.textColor = UIColor(red:0.38, green:0.38, blue:0.38, alpha:1.0)
        if StyleManager.isIpad() {
            topTitle.font = UIFont(name: "Avenir-Black", size: 20)

        } else {
            topTitle.font = UIFont(name: "Avenir-Black", size: 13)
        }
        self.addSubview(topTitle)
        topTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp.top).offset(8)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        freeTrialLbl.textColor = .white
        freeTrialLbl.text = "7 Day Free Trial"
        if StyleManager.isIpad() {
            freeTrialLbl.font = UIFont(name: "Avenir-Black", size: 30)
        } else {
            freeTrialLbl.font = UIFont(name: "Avenir-Black", size: 22)
        }
        self.addSubview(freeTrialLbl)
        freeTrialLbl.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        priceLbl.textColor = topTitle.textColor
        if StyleManager.isIpad() {
            priceLbl.font = UIFont(name: "Avenir-Light", size: 20)
        } else {
            priceLbl.font = UIFont(name: "Avenir-Light", size: 13)
        }
        self.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-8)
            make.centerX.equalTo(self.snp.centerX)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setTitles(top: String, bottom: String) {
        topTitle.text = top
        priceLbl.text = bottom
    }
    
}
