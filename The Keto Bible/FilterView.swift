//
//  FilterView.swift
//  The Keto Bible
//
//  Created by Laura Day on 11/3/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Spring


protocol FiltersViewDelegate: class {
    func resetPressed();
    func searchPressed(filteredRecipes: [RecipeItem]?);

}

class FilterView: UIView {

    
    weak var delegate : FiltersViewDelegate?

    
    let filterBGView = UIView()
    let topGrey = UIView()
    
    let filterTitle = UILabel()
    let resetBtn = SpringButton()
    let searchBtn = SpringButton()
    
    let lookingForLbl = UILabel()
    let breakfastBtn = SpringButton()
    let lunchBtn = SpringButton()
    let dinnerBtn = SpringButton()
    let drinksBtn = SpringButton()
    let snacksBtn = SpringButton()

    let carbsLbl = UILabel()
    let carbsAmtLbl = UILabel()
    let carbsSlider = UISlider()
    let carbsAmtLeftLbl = UILabel()
    let carbsAmtRightLbl = UILabel()

    
    let avoidingLbl = UILabel()
    let fishBtn = SpringButton()
    let meatBtn = SpringButton()
    let dairyBtn = SpringButton()

    let cookingTimeLbl = UILabel()
    let cookingAmtLbl = UILabel()
    let cookingTimeSlider = UISlider()
    let cookAmtLeftLbl = UILabel()
    let cookAmtRightLbl = UILabel()



    init() {
        super.init(frame: CGRect.zero)

        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        
        self.filterBGView.backgroundColor = .white
        self.addSubview(filterBGView)
        filterBGView.snp.makeConstraints{ (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom).offset(100)
            switch UIDevice().type {
            case .iPhone8, .iPhone7, .iPhone6S, .iPhone6, .iPhoneSE, .iPhone5S:
                make.top.equalTo(self.snp.top).offset(100)
            default:
                make.top.equalTo(self.snp.centerY).offset(-200)
            }
        }
        
        filterBGView.layer.cornerRadius = 21
        self.topGrey.layer.cornerRadius = 21
        filterBGView.clipsToBounds = true
        filterBGView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        topGrey.clipsToBounds = true
        topGrey.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        self.topGrey.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.95, alpha:1.00)
        self.filterBGView.addSubview(topGrey)
        self.topGrey.snp.makeConstraints{ (make) in
            make.top.equalTo(self.filterBGView.snp.top)
            make.left.equalTo(self.filterBGView.snp.left)
            make.right.equalTo(self.filterBGView.snp.right)
            if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
                make.height.equalTo(35)
            } else {
                make.height.equalTo(55)
            }
        }
        
        let chooseStr = "Choose your filters"
        let chooseStrText = NSMutableAttributedString(string: chooseStr, attributes: [NSAttributedString.Key.font: StyleManager.filtersTitle])
        chooseStrText.addAttributes([ NSAttributedString.Key.font : StyleManager.filtersTitleBold ], range: NSMakeRange(7, 4));
        chooseStrText.addAttributes([NSAttributedString.Key.foregroundColor : StyleManager.mainColor], range: NSMakeRange(0, chooseStr.count))

        filterTitle.attributedText = chooseStrText
        self.topGrey.addSubview(filterTitle)
        filterTitle.snp.makeConstraints{ (make) in
            make.left.equalTo(self.topGrey.snp.left).offset(20)
            make.centerY.equalTo(self.topGrey.snp.centerY)
        }
        
        self.resetBtn.setTitle("Reset", for: .normal)
        self.searchBtn.setTitle("Search!", for: .normal)
        
        self.resetBtn.setTitleColor(UIColor(red:0.69, green:0.69, blue:0.69, alpha:1.00), for: .normal)
        self.searchBtn.setTitleColor(StyleManager.mainColor, for: .normal)
        
        self.resetBtn.titleLabel?.font = StyleManager.searchResetFont
        self.searchBtn.titleLabel?.font = StyleManager.searchResetFont

        self.topGrey.addSubview(resetBtn)
        self.topGrey.addSubview(searchBtn)
        
        self.searchBtn.snp.makeConstraints{ (make) in
            make.right.equalTo(self.topGrey.snp.right).offset(-20)
            make.centerY.equalTo(self.topGrey.snp.centerY)
        }
        
        self.resetBtn.snp.makeConstraints{ (make) in
            make.right.equalTo(self.searchBtn.snp.left).offset(-10)
            make.centerY.equalTo(self.topGrey.snp.centerY)
        }

        self.resetBtn.addTarget(self, action: #selector(resetPressed), for: .touchUpInside)
        self.searchBtn.addTarget(self, action: #selector(searchPressed), for: .touchUpInside)

        
        self.lookingForLbl.text = "Looking for.."
        self.carbsLbl.text = "With net carbs less than.."
        self.avoidingLbl.text = "avoiding.."
        self.cookingTimeLbl.text = "With a cooking time less than.."

        for label in [lookingForLbl, carbsLbl, avoidingLbl, cookingTimeLbl] {
            label.font = StyleManager.filterSubtitleFont
            label.textColor = StyleManager.mainColor
            self.filterBGView.addSubview(label)
        }
        
        self.lookingForLbl.snp.makeConstraints{ (make) in
            make.left.equalTo(self.filterBGView.snp.left).offset(15)
            make.top.equalTo(self.topGrey.snp.bottom).offset(15)
        }
        
        for button in [breakfastBtn, lunchBtn, dinnerBtn, drinksBtn, snacksBtn, fishBtn, meatBtn, dairyBtn] {
            button.backgroundColor = .white
            button.layer.applySketchShadow(
                color: StyleManager.mainColor,
                alpha: 0.16,
                x: 1,
                y: 3,
                blur: 10,
                spread: 0)
            button.layer.cornerRadius = 16
            button.titleLabel?.font = StyleManager.filterBtnFont
            self.filterBGView.addSubview(button)
            button.setTitleColor(StyleManager.mainColor, for: .normal)
        }
        
        var buttonWidth = 105
        
        if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5C || UIDevice().type == .iPhoneSE {
            buttonWidth = 95
        }
        
        let buttonHeight = 30
        let btnOffset = 10

        self.lunchBtn.setTitle("Lunch", for: .normal)
        self.lunchBtn.addTarget(self, action: #selector(lunchBtnPressed), for: .touchUpInside)
        self.lunchBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.filterBGView.snp.centerX)
            make.top.equalTo(self.lookingForLbl.snp.bottom).offset(15)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        self.dinnerBtn.setTitle("Dinner", for: .normal)
        self.dinnerBtn.addTarget(self, action: #selector(dinnerBtnPressed), for: .touchUpInside)
        self.dinnerBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.lunchBtn.snp.right).offset(btnOffset)
            make.top.equalTo(self.lookingForLbl.snp.bottom).offset(15)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        self.breakfastBtn.setTitle("Breakfast", for: .normal)
        self.breakfastBtn.addTarget(self, action: #selector(breakfastBtnPressed), for: .touchUpInside)
        self.breakfastBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.lunchBtn.snp.left).offset(-btnOffset)
            make.top.equalTo(self.lookingForLbl.snp.bottom).offset(15)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        self.drinksBtn.setTitle("Drinks", for: .normal)
        self.drinksBtn.addTarget(self, action: #selector(drinksBtnPressed), for: .touchUpInside)
        self.drinksBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.lunchBtn.snp.left).offset(-3)
            make.top.equalTo(self.lunchBtn.snp.bottom).offset(10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        self.snacksBtn.setTitle("Snacks", for: .normal)
        self.snacksBtn.addTarget(self, action: #selector(snacksBtnPressed), for: .touchUpInside)
        self.snacksBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.dinnerBtn.snp.left).offset(-3)
            make.top.equalTo(self.lunchBtn.snp.bottom).offset(10)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        self.carbsLbl.snp.makeConstraints{ (make) in
            make.left.equalTo(self.filterBGView.snp.left).offset(15)
            make.top.equalTo(self.snacksBtn.snp.bottom).offset(20)
        }
        
        self.carbsAmtLbl.font = StyleManager.carbsAmtLblFont
        self.carbsAmtLbl.textColor = StyleManager.mainColor
        self.filterBGView.addSubview(carbsAmtLbl)
        self.carbsAmtLbl.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.filterBGView.snp.centerX)
            if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
                make.top.equalTo(self.carbsLbl.snp.bottom).offset(5)
            } else {
                make.top.equalTo(self.carbsLbl.snp.bottom).offset(10)
            }
        }
        
        self.carbsSlider.minimumValue = 0
        self.carbsSlider.maximumValue = 60
        self.carbsAmtLbl.text = "25 grams"
        self.carbsSlider.setValue(25, animated: false)
        self.carbsSlider.thumbTintColor = StyleManager.mainColor
        carbsSlider.minimumTrackTintColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.00)
        carbsSlider.maximumTrackTintColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.00)
        carbsSlider.addTarget(self, action: #selector(carbsSliderChanged), for: .valueChanged)

        
        self.filterBGView.addSubview(carbsSlider)
        self.carbsSlider.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.filterBGView.snp.centerX)
            if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
                make.top.equalTo(self.carbsAmtLbl.snp.bottom).offset(5)
            } else {
                make.top.equalTo(self.carbsAmtLbl.snp.bottom).offset(15)
            }
            make.left.equalTo(self.filterBGView.snp.left).offset(30)
            make.right.equalTo(self.filterBGView.snp.right).offset(-30)
        }
        
        self.carbsAmtRightLbl.textColor = StyleManager.mainColor
        self.carbsAmtLeftLbl.textColor = StyleManager.mainColor
        self.carbsAmtLeftLbl.text = "0"
        self.carbsAmtRightLbl.text = "60"
        self.carbsAmtLeftLbl.font = UIFont(name: "Avenir-Light", size: 12)
        self.carbsAmtRightLbl.font = UIFont(name: "Avenir-Light", size: 12)
        self.filterBGView.addSubview(carbsAmtRightLbl)
        self.filterBGView.addSubview(carbsAmtLeftLbl)
        
        self.carbsAmtLeftLbl.snp.makeConstraints{ (make) in
            make.top.equalTo(self.carbsSlider.snp.bottom).offset(3)
            make.left.equalTo(self.carbsSlider.snp.left)
        }
        
        self.carbsAmtRightLbl.snp.makeConstraints{ (make) in
            make.top.equalTo(self.carbsSlider.snp.bottom).offset(3)
            make.right.equalTo(self.carbsSlider.snp.right)
        }
        
        self.avoidingLbl.snp.makeConstraints{ (make) in
            if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
                make.top.equalTo(self.carbsAmtLeftLbl.snp.bottom).offset(7)
            } else {
                make.top.equalTo(self.carbsAmtLeftLbl.snp.bottom).offset(15)
            }
            make.left.equalTo(self.carbsLbl.snp.left)
        }
        
        self.meatBtn.setTitle("Meat", for: .normal)
        self.meatBtn.addTarget(self, action: #selector(meatBtnPressed), for: .touchUpInside)
        self.meatBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.filterBGView.snp.centerX)
            if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE{
                make.top.equalTo(self.avoidingLbl.snp.bottom).offset(5)
            } else {
                make.top.equalTo(self.avoidingLbl.snp.bottom).offset(15)
            }
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        self.fishBtn.setTitle("Fish", for: .normal)
        self.fishBtn.addTarget(self, action: #selector(fishBtnPressed), for: .touchUpInside)
        self.fishBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.meatBtn.snp.left).offset(-5)
            make.top.equalTo(self.meatBtn.snp.top)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        self.dairyBtn.setTitle("Dairy", for: .normal)
        self.dairyBtn.addTarget(self, action: #selector(dairyBtnPressed), for: .touchUpInside)
        self.dairyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.meatBtn.snp.right).offset(5)
            make.top.equalTo(self.fishBtn.snp.top)
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
        }
        
        self.cookingTimeLbl.snp.makeConstraints{ (make) in
            make.top.equalTo(self.fishBtn.snp.bottom).offset(15)
            make.left.equalTo(self.avoidingLbl.snp.left)
        }

        
        self.cookingAmtLbl.font = StyleManager.carbsAmtLblFont
        self.cookingAmtLbl.textColor = StyleManager.mainColor
        self.filterBGView.addSubview(cookingAmtLbl)
        self.cookingAmtLbl.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.filterBGView.snp.centerX)
            make.top.equalTo(self.cookingTimeLbl.snp.bottom).offset(10)
        }
        
        self.cookingTimeSlider.minimumValue = 5
        self.cookingTimeSlider.maximumValue = 60
        self.cookingAmtLbl.text = "10 minutes"
        self.cookingTimeSlider.setValue(10, animated: false)
        self.cookingTimeSlider.thumbTintColor = StyleManager.mainColor
        cookingTimeSlider.minimumTrackTintColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.00)
        cookingTimeSlider.maximumTrackTintColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.00)
        cookingTimeSlider.addTarget(self, action: #selector(cookingSliderChanged), for: .valueChanged)
        
        
        self.filterBGView.addSubview(cookingTimeSlider)
        self.cookingTimeSlider.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.filterBGView.snp.centerX)
            if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 {
                make.top.equalTo(self.cookingAmtLbl.snp.bottom).offset(0)
            } else if UIDevice().type == .iPhoneSE {
                make.top.equalTo(self.cookingAmtLbl.snp.bottom).offset(-5)
            } else {
                make.top.equalTo(self.cookingAmtLbl.snp.bottom).offset(15)
            }
            make.left.equalTo(self.filterBGView.snp.left).offset(30)
            make.right.equalTo(self.filterBGView.snp.right).offset(-30)
        }
        
        self.cookAmtRightLbl.textColor = StyleManager.mainColor
        self.cookAmtLeftLbl.textColor = StyleManager.mainColor
        self.cookAmtLeftLbl.text = "5 min"
        self.cookAmtRightLbl.text = "60 min"
        self.cookAmtLeftLbl.font = UIFont(name: "Avenir-Light", size: 12)
        self.cookAmtRightLbl.font = UIFont(name: "Avenir-Light", size: 12)
        self.filterBGView.addSubview(cookAmtRightLbl)
        self.filterBGView.addSubview(cookAmtLeftLbl)
        
        self.cookAmtLeftLbl.snp.makeConstraints{ (make) in
            make.top.equalTo(self.cookingTimeSlider.snp.bottom).offset(3)
            make.left.equalTo(self.cookingTimeSlider.snp.left)
        }
        
        self.cookAmtRightLbl.snp.makeConstraints{ (make) in
            make.top.equalTo(self.cookingTimeSlider.snp.bottom).offset(3)
            make.right.equalTo(self.cookingTimeSlider.snp.right)
        }
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    @objc func resetPressed() {
        self.resetButtons()
        self.delegate?.resetPressed()
    }
    
    func resetButtons() {
        for button in [breakfastBtn, lunchBtn, dinnerBtn, drinksBtn, snacksBtn, fishBtn, meatBtn, dairyBtn] {
            button.isSelected = false
        }
        self.carbsSlider.setValue(25, animated: false)
        self.carbsSliderChanged()
        self.cookingTimeSlider.setValue(10, animated: false)
        self.cookingSliderChanged()
        
        self.setButtonState()

    }
    
    @objc func searchPressed() {
        
        var cat1 = ""
        var cat2 = ""
        var cat3 = ""
        var cat4 = ""
        var cat5 = ""
        
        if self.breakfastBtn.isSelected {
            cat1 = "breakfast"
        }
        
        if self.lunchBtn.isSelected {
            cat2 = "lunch"
        }

        if self.dinnerBtn.isSelected {
            cat3 = "dinner"
        }
        
        if self.drinksBtn.isSelected {
            cat4 = "drinks"
        }
        
        if self.snacksBtn.isSelected {
            cat5 = "snack"
        }
        
        let cookingTime = Int(self.cookingTimeSlider.value)
        let carbsAmount = Int(self.carbsSlider.value)
        
        DataManager.sharedInstance.loadCustomFilter(category1: cat1, category2: cat2, category3: cat3, category4: cat4, category5: cat5, cookingTime: cookingTime, meat: self.meatBtn.isSelected, dairy: self.dairyBtn.isSelected, fish: self.fishBtn.isSelected, carbs: carbsAmount) { (filteredRecipes) in
            self.delegate?.searchPressed(filteredRecipes: filteredRecipes)
        }
        
    }

    @objc func breakfastBtnPressed() {
        self.breakfastBtn.isSelected = !self.breakfastBtn.isSelected
        self.setButtonState()
    }
    
    func setButtonState() {
        
        for button in [breakfastBtn, lunchBtn, dinnerBtn, drinksBtn, snacksBtn, meatBtn, dairyBtn, fishBtn] {
            if button.isSelected {
                button.backgroundColor = StyleManager.mainColor
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(StyleManager.mainColor, for: .normal)
            }
        }
    }
    
    @objc func lunchBtnPressed() {
        self.lunchBtn.isSelected = !self.lunchBtn.isSelected
        self.setButtonState()
    }
    
    @objc func dinnerBtnPressed() {
        self.dinnerBtn.isSelected = !self.dinnerBtn.isSelected
        self.setButtonState()
    }
    
    @objc func drinksBtnPressed() {
        self.drinksBtn.isSelected = !self.drinksBtn.isSelected
        self.setButtonState()

    }
    
    @objc func snacksBtnPressed() {
        self.snacksBtn.isSelected = !self.snacksBtn.isSelected
        self.setButtonState()
    }

    @objc func carbsSliderChanged() {
        let carbsValue = Int(carbsSlider.value.rounded())
        self.carbsAmtLbl.text = String(describing: carbsValue) + " grams"
    }
    
    @objc func cookingSliderChanged() {
        let cookingValue = Int(cookingTimeSlider.value.rounded())
        self.cookingAmtLbl.text = String(describing: cookingValue) + " minutes"
    }
    
    @objc func meatBtnPressed() {
        self.meatBtn.isSelected = !self.meatBtn.isSelected
        self.setButtonState()
    }
    
    @objc func fishBtnPressed() {
        self.fishBtn.isSelected = !self.fishBtn.isSelected
        self.setButtonState()
    }
    
    @objc func dairyBtnPressed() {
        self.dairyBtn.isSelected = !self.dairyBtn.isSelected
        self.setButtonState()
    }
    
    

}
