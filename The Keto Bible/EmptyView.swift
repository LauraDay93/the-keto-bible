//
//  File.swift
//  The Keto Hack
//
//  Created by Laura Day on 14/7/20.
//  Copyright © 2020 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Spring
import FAPanels



class EmptyView: UIView {
    
    
    
    var emptyImageView = UIImageView()
    var titleLbl = UILabel()
    var descLbl = UILabel()
    
    var browseButton = SpringButton()

    init() {
    super.init(frame: CGRect.zero)

        self.backgroundColor = .white
        self.addSubview(emptyImageView)
        
        emptyImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.snp.centerX)
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhoneSE || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone6 || UIDevice.current.type == .iPhone6S || UIDevice.current.type == .iPhone7  || UIDevice.current.type == .iPhone8 {
                make.top.equalTo(self.snp.top).offset(20)
            } else {
                make.top.equalTo(self.snp.top).offset(80)
            }
        }
        
        titleLbl.font = UIFont(name: "Avenir-Heavy", size: 33)
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.numberOfLines = 1
        titleLbl.textColor = .black
        titleLbl.textAlignment = .center
        
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhoneSE || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone5S {
                make.top.equalTo(self.emptyImageView.snp.bottom).offset(15)
            } else {
                make.top.equalTo(self.emptyImageView.snp.bottom).offset(30)
            }
            make.centerX.equalTo(self.snp.centerX)
            make.left.equalTo(self.snp.left).offset(30)
            make.right.equalTo(self.snp.right).offset(-30)
        }
        
        descLbl.font = UIFont(name: "Avenir-Heavy", size: 16)
        descLbl.adjustsFontSizeToFitWidth = true
        descLbl.numberOfLines = 2
        descLbl.textColor = .black
        descLbl.textAlignment = .center
        
        self.addSubview(descLbl)
        descLbl.snp.makeConstraints { (make) in
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhoneSE || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone5S {
                make.top.equalTo(self.titleLbl.snp.bottom).offset(15)
            } else {
                make.top.equalTo(self.titleLbl.snp.bottom).offset(30)
            }
            make.centerX.equalTo(self.snp.centerX)
            make.left.equalTo(self.snp.left).offset(30)
            make.right.equalTo(self.snp.right).offset(-30)
        }
        
        self.browseButton.backgroundColor = .black
        self.browseButton.setTitleColor(.white, for: .normal)
        self.browseButton.layer.cornerRadius = 9
        self.browseButton.addShadowToButton()
        self.browseButton.setTitle("BROWSE RECIPES", for: .normal)
        
        self.addSubview(browseButton)
        browseButton.snp.makeConstraints { (make) in
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhoneSE || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone5S {
                make.top.equalTo(self.descLbl.snp.bottom).offset(20)
            } else {
                make.top.equalTo(self.descLbl.snp.bottom).offset(40)
            }
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(270 )
            make.height.equalTo(41)
        }
        browseButton.addTarget(self, action: #selector(browseBtnPressed), for: .touchUpInside)
        browseButton.titleLabel?.font = UIFont(name: "Avenir-Black", size: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView (image: UIImage, title: String, description: String) {
        self.emptyImageView.image = image
        self.titleLbl.text = title
        self.descLbl.text = description
    }
    
    @objc func browseBtnPressed() {
        browseButton.pop {
            NotificationCenter.default.post(name: DataManager.browseAllPressed, object: nil)
        }
    }
    
}
