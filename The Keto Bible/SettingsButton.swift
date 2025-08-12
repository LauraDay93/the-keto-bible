//
//  SettingsButton.swift
//  The Keto Bible
//
//  Created by Laura Day on 1/8/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring
import SnapKit

class SettingsButton : SpringButton {
    
    
    let iconImg : UIImage!
    let title : String!
    let desc : String!
    
    var icon = UIImageView()
    var titleLbl = UILabel()
    var descLbl = UILabel()
    
    required init(iconImg: UIImage, title: String, desc: String) {
        self.iconImg = iconImg
        self.title = title
        self.desc = desc
        super.init(frame: .zero)

        
        self.backgroundColor = .white
        self.addShadowToButton()
        
        self.layer.cornerRadius = 15
        
        self.icon.image = iconImg
        self.addSubview(self.icon)
        self.icon.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(20)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        self.addSubview(titleLbl)
        titleLbl.text = title
        titleLbl.textColor = .black
        titleLbl.font = StyleManager.settingsBtnTitleFont
        self.addSubview(self.titleLbl)
        self.titleLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.icon.snp.right).offset(20)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        self.addSubview(descLbl)
        descLbl.textColor = .black
        descLbl.text = desc
        descLbl.font = StyleManager.settingsBtnDescFont
        self.addSubview(self.descLbl)
        self.descLbl.snp.makeConstraints { (make) in
            make.right.equalTo(self.snp.right).offset(-30)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        
    
        
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
