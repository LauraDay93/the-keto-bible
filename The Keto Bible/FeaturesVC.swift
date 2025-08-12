//
//  featuresVC.swift
//  The Keto Bible
//
//  Created by Laura Day on 2/9/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring


class FeaturesVC : UIViewController  {
    
    
    let titleLbl = UILabel()
    let desc = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(titleLbl)
        self.view.addSubview(desc)
        self.view.backgroundColor = .clear
        
        
        titleLbl.textColor = .white
        titleLbl.font = StyleManager.featuresTitleFont
        desc.textColor = .white
        
        titleLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.left.equalTo(self.view.snp.left).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.top.equalTo(self.view.snp.top).offset(5)
        }
        
        desc.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.left.equalTo(self.view.snp.left).offset(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            if UIDevice().type == .iPhoneSE || UIDevice().type == .iPhone6 || UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S {
                make.top.equalTo(self.view.snp.top).offset(35)
            } else {
                make.top.equalTo(self.view.snp.top).offset(50)
            }
        }


    }
    
    func setupForIndex(index: Int) {
        desc.numberOfLines = 3

        
        
        switch index{
        case 0:
            titleLbl.text = "Weekly Recipes"
            titleLbl.textAlignment = .center
            desc.setLineHeight(lineHeight: 0.5)
            desc.textAlignment = .center
            desc.text = "Nearly 100 Keto Recipes with new recipes added every week."
            desc.font = StyleManager.featuresDescFont
            desc.changeFont(ofText: "every week.", with: StyleManager.featuresTitleFont)
            desc.changeFont(ofText: "Nearly 100", with: StyleManager.featuresTitleFont)
        case 1:
            titleLbl.text = "All About Keto"
            titleLbl.textAlignment = .center
            desc.setLineHeight(lineHeight: 0.5)
            desc.textAlignment = .center
            desc.text = "Learn the \n tips & tricks \n of the Keto Diet."
            desc.font = StyleManager.featuresDescFont
            desc.changeFont(ofText: "tips & tricks", with: StyleManager.featuresTitleFont)
        case 2:
            titleLbl.text = "Favourites"
            titleLbl.textAlignment = .center
            desc.setLineHeight(lineHeight: 0.5)
            desc.textAlignment = .center
            desc.text = "Save your \n favourites for easy\n access anytime!"
            desc.font = StyleManager.featuresDescFont
            desc.changeFont(ofText: "favourites", with: StyleManager.featuresTitleFont)
            desc.changeFont(ofText: "anytime!", with: StyleManager.featuresTitleFont)
        case 3:
            titleLbl.text = "Filtering"
            titleLbl.textAlignment = .center
            desc.setLineHeight(lineHeight: 0.5)
            desc.textAlignment = .center
            desc.text = "Filter to cater to you and your allergen or dietary needs."
            desc.font = StyleManager.featuresDescFont
            desc.changeFont(ofText: "allergen or dietary needs.", with: StyleManager.featuresTitleFont)
        default:
            print("default")
        }
        
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
}
