//
//  StepsCell.swift
//  The Keto Bible
//
//  Created by Laura Day on 5/4/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class StepCell : UICollectionViewCell {
    
    
    
    let stepNumberLbl = UILabel()
    let stepLbl = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stepNumberLbl.font = UIFont(name: "Avenir-Light", size: 20)
        stepNumberLbl.textColor = UIColor(red:0.69, green:0.69, blue:0.69, alpha:1.00)
        stepNumberLbl.numberOfLines = 1
        stepNumberLbl.textAlignment = .left
        
        self.addSubview(stepNumberLbl)
        stepNumberLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(30)
            make.width.equalTo(self.contentView.snp.width).offset(-60)
            make.top.equalTo(self.contentView.snp.top)
            make.height.equalTo(30)
        }
        
        
        if UIDevice().type == .iPhone5 ||  UIDevice().type == .iPhone5C ||  UIDevice().type == .iPhone5S ||  UIDevice().type == .iPhoneSE {
            stepLbl.font = UIFont(name: "Avenir-Light", size: 16)
        } else {
            stepLbl.font = UIFont(name: "Avenir-Light", size: 19)
        }
        stepLbl.lineBreakMode = .byTruncatingTail
        stepLbl.textColor = .black
        stepLbl.adjustsFontSizeToFitWidth = true
        stepLbl.numberOfLines = 5
        stepLbl.textAlignment = .left
        
        self.addSubview(stepLbl)
        stepLbl.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left).offset(30)
            make.width.equalTo(self.contentView.snp.width).offset(-60)
            make.top.equalTo(self.stepNumberLbl.snp.bottom)
            make.height.equalTo(140)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateCellForItem(stepNumber : Int, step: String) {
        
        stepNumberLbl.text = "STEP " + String(describing: stepNumber)
        stepLbl.text = step
    }



}
