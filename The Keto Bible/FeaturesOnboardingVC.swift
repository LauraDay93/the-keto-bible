//
//  FeaturesOnboardingVC.swift
//  The Keto Bible
//
//  Created by Laura Day on 3/11/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import paper_onboarding
import Spring
import SnapKit


class FeaturesOnboardingVC: UIViewController, PaperOnboardingDataSource {

    var skipButton = SpringButton()
    
    var freeTrialBtn = SpringButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let onboarding = PaperOnboarding()
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)

        // add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
          let constraint = NSLayoutConstraint(item: onboarding,
                                              attribute: attribute,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: attribute,
                                              multiplier: 1,
                                              constant: 0)
          view.addConstraint(constraint)
        }
        
        self.view.addSubview(skipButton)
        skipButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(40)
            make.right.equalTo(self.view.snp.right).offset(-15)
        }
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 15)
        skipButton.isHidden = true
        skipButton.addTarget(self, action: #selector(skipPressed), for: .touchUpInside)

        
        self.view.addSubview(freeTrialBtn)
        freeTrialBtn.backgroundColor = .white
        freeTrialBtn.layer.cornerRadius = 11
        freeTrialBtn.setTitleColor(StyleManager.mainColor, for: .normal)
        freeTrialBtn.setTitle("Continue", for: .normal)
        freeTrialBtn.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 17)
        freeTrialBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5C ||  UIDevice().type == .iPhone5S || UIDevice().type == .iPhoneSE {
                make.height.equalTo(44)
                make.top.equalTo(self.view.snp.bottom).offset(-140)

            } else {
                make.height.equalTo(54)
                make.top.equalTo(self.view.snp.bottom).offset(-150)

            }
            make.width.equalTo(213)

        }
        self.freeTrialBtn.layer.opacity = 0
        freeTrialBtn.addTarget(self, action: #selector(trialPressed), for: .touchUpInside)
        
        
    }
    @objc func trialPressed() {
        freeTrialBtn.pop {
            UserManager.shared.setShowedFeatures()
            self.navigationController?.pushViewController(LandingFeedVC(), animated: true)
        }
    }
    
    @objc func skipPressed() {
        self.skipButton.pop {
            UserManager.shared.setShowedFeatures()
            self.navigationController?.pushViewController(LandingFeedVC(), animated: true)
        }
    }

    func onboardingItem(at index: Int) -> OnboardingItemInfo {

      let titleFont = UIFont(name: "Avenir-Black", size: 28)
      let descFont = UIFont(name: "Avenir-Book", size: 15)

        var descString : String!
        var descString4 : String!

        if StyleManager.isKeto {
            descString = "Nearly 100 Keto Friendly Recipes with new recipes added every week."
            descString4 = "New to Keto? Unique categories and tips & tricks\n to help you along the way!"
        } else {
            descString = "Nearly 100 Plant Based Recipes with new recipes added every week."
            descString4 = "New to the Plant Based World? Unique categories and\n tips & tricks to help you along the way!"
        }
        
      return [
        OnboardingItemInfo(informationImage: UIImage(named: "features1")!,
                                      title: "Recipes",
                                description: descString,
                                pageIcon:    UIImage(named: "featuresIcon")!,
                                color: StyleManager.featuresColor1,
                                 titleColor: UIColor.white,
                           descriptionColor: UIColor.white,
                                  titleFont: titleFont!,
                            descriptionFont: descFont!),

        OnboardingItemInfo(informationImage:UIImage(named: "features2")!,
                                    title: "Filtering",
                                    description: "Filter to cater to you and your \nallergen or dietary needs.",
                                    pageIcon:    UIImage(named: "features2Icon")!,
                                    color: StyleManager.featuresColor2,
                                    titleColor: UIColor.white,
                                    descriptionColor: UIColor.white,
                                    titleFont: titleFont!,
                                    descriptionFont: descFont!),

       OnboardingItemInfo(informationImage: UIImage(named: "features3")!,
                                    title: "Favourites",
                                    description: "Save your favourite recipes for quick and \neasy access later.",
                                    pageIcon:    UIImage(named: "features3Icon")!,
                                    color: StyleManager.featuresColor3,
                                    titleColor: UIColor.white,
                                    descriptionColor: UIColor.white,
                                    titleFont: titleFont!,
                                    descriptionFont: descFont!),
       
       OnboardingItemInfo(informationImage: UIImage(named: "features4")!,
                                    title: "Tips & Tricks",
                                    description: descString4,
                                    pageIcon:    UIImage(named: "features4Icon")!,
                                    color: StyleManager.featuresColor4,
                                    titleColor: UIColor.white,
                                    descriptionColor: UIColor.white,
                                    titleFont: titleFont!,
                                    descriptionFont: descFont!),
       
       OnboardingItemInfo(informationImage: UIImage(named: "features5")!,
                                    title: "Coming Soon",
                                    description: "Intermittent fasting timer, meal planners, \ntracking, and more! ",
                                    pageIcon:    UIImage(named: "features5Icon")!,
                                    color: StyleManager.featuresColor5,
                                    titleColor: UIColor.white,
                                    descriptionColor: UIColor.white,
                                    titleFont: titleFont!,
                                    descriptionFont: descFont!),
        ][index]
    }

    func onboardingItemsCount() -> Int {
       return 5
     }


}

extension FeaturesOnboardingVC: PaperOnboardingDelegate {

    func onboardingWillTransitonToIndex(_ index: Int) {
        
        if index > 0 {
            skipButton.isHidden = false
        }
        
        if index == 4 {
            skipButton.isHidden = true
            
            UIView.animate(withDuration: 1) {
                self.freeTrialBtn.layer.opacity = 1
            }
            
        } else {
            self.freeTrialBtn.layer.opacity = 0

        }

     }

}



