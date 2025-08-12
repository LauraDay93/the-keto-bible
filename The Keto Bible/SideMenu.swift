//
//  SideMenu.swift
//  The Keto Hack
//
//  Created by Laura Day on 24/2/20.
//  Copyright © 2020 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring

class SideMenu : UIViewController  {

    let homeVC = LandingFeedVC()
    let favsVC = FavouritesVC()
    let settingsVC = SettingsVC()
    let tipsVC = TipsVC()
    let ketoIntroVC = IntroKetoVC()
    let carbsVC = CarbsSubsVC()
    
    var topIcon : UIImageView!
    var nameLbl = UILabel()
    var allBtn = SpringButton()
    var favsBtn = SpringButton()
    var shoppingBtn = SpringButton()
    var basicsBtn = SpringButton()
    var subsBtn = SpringButton()
    var tipsBtn = SpringButton()
    var settingsBtn = SpringButton()
    
    let horizLine1 = UIView()
    let horizLine2 = UIView()
    let horizLine3 = UIView()
    let horizLine4 = UIView()
    let horizLine5 = UIView()
    let horizLine6 = UIView()

    
    var leftOffset = 80
    var topOffset = 20
    
    var bottomLbl = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(setAllPressed), name: DataManager.browseAllPressed, object: nil)

        
        if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhoneSE {
            topOffset = 13
        }
        
        
        self.view.backgroundColor = .black
        self.topIcon = UIImageView(image: UIImage(named: "menuIconTop"))
        
        self.view.addSubview(topIcon)
        topIcon.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(80)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        print(UserManager.shared.getUserName())
        self.nameLbl.text = UserManager.shared.getUserName()
        if self.nameLbl.text == "" {
            self.nameLbl.text = "The Keto Hack"
        }
        self.nameLbl.textColor = .white
        self.nameLbl.font = StyleManager.menuNameFont
        self.view.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.topIcon.snp.bottom).offset(15)
        }
        
        self.allBtn.setImage(UIImage(named: "allRec_sel"), for: .normal)
        self.allBtn.setTitle("All Recipes", for: .normal)
        
        self.view.addSubview(self.allBtn)
       self.allBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(40)
            make.top.equalTo(self.topIcon.snp.bottom).offset(60)
        }
        
        self.allBtn.addTarget(self, action: #selector(setAllPressed), for: .touchUpInside)
        
        self.view.addSubview(horizLine1)
        horizLine1.snp.makeConstraints { (make) in
            make.top.equalTo(self.allBtn.snp.bottom).offset(topOffset)
            make.width.equalTo(self.view.snp.width).offset(-40)
            make.height.equalTo(2)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        self.favsBtn.setImage(UIImage(named: "fav_unsel"), for: .normal)
        self.favsBtn.setTitle("My Favourites", for: .normal)
        self.favsBtn.addTarget(self, action: #selector(setFavsPressed), for: .touchUpInside)
        self.view.addSubview(self.favsBtn)
        self.favsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(leftOffset)
            make.top.equalTo(self.horizLine1.snp.bottom).offset(topOffset)
        }
        
        
        
        for btn in [allBtn, favsBtn, shoppingBtn, basicsBtn, subsBtn, tipsBtn, settingsBtn]
        {
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
            btn.titleLabel?.font = StyleManager.menuFontUnsel
            btn.setTitleColor(.white, for: .normal)

        }
        self.allBtn.titleLabel?.font = StyleManager.menuFontSel

        
        for line in [horizLine1, horizLine2, horizLine3, horizLine4, horizLine5, horizLine6] {
            line.backgroundColor = .white
            line.layer.opacity = 0.6
        }
        
        self.view.addSubview(horizLine2)
        horizLine2.snp.makeConstraints { (make) in
            make.top.equalTo(self.favsBtn.snp.bottom).offset(topOffset)
            make.width.equalTo(self.view.snp.width).offset(-40)
            make.height.equalTo(2)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        
        self.shoppingBtn.setImage(UIImage(named: "shopping_unsel"), for: .normal)
        //self.shoppingBtn.setTitle("Foods To Avoid", for: .normal)
        self.shoppingBtn.setTitle("Shopping List", for: .normal)
        self.shoppingBtn.addTarget(self, action: #selector(setShoppingPressed), for: .touchUpInside)
        self.view.addSubview(self.shoppingBtn)
        self.shoppingBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(leftOffset)
            make.top.equalTo(self.horizLine2.snp.bottom).offset(topOffset)
        }
        
        
        self.view.addSubview(horizLine3)
        horizLine3.snp.makeConstraints { (make) in
            make.top.equalTo(self.shoppingBtn.snp.bottom).offset(topOffset)
            make.width.equalTo(self.view.snp.width).offset(-40)
            make.height.equalTo(2)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        
        self.basicsBtn.setImage(UIImage(named: "basic_unsel"), for: .normal)
        
        //self.basicsBtn.setTitle("Keto Basics", for: .normal)
        self.basicsBtn.setTitle("Supplements", for: .normal)

        self.basicsBtn.addTarget(self, action: #selector(setBasicsPressed), for: .touchUpInside)
        self.view.addSubview(self.basicsBtn)
        self.basicsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(leftOffset)
            make.top.equalTo(self.horizLine3.snp.bottom).offset(topOffset)
        }
        
        self.view.addSubview(horizLine4)
        horizLine4.snp.makeConstraints { (make) in
            make.top.equalTo(self.basicsBtn.snp.bottom).offset(topOffset)
            make.width.equalTo(self.view.snp.width).offset(-40)
            make.height.equalTo(2)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        
        self.subsBtn.setImage(UIImage(named: "subs_unsel"), for: .normal)
        self.subsBtn.setTitle("Substitutes", for: .normal)
        self.subsBtn.addTarget(self, action: #selector(setSubsPressed), for: .touchUpInside)
        self.view.addSubview(self.subsBtn)
        self.subsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(leftOffset)
            make.top.equalTo(self.horizLine4.snp.bottom).offset(topOffset)
        }
               
               
        self.view.addSubview(horizLine5)
        horizLine5.snp.makeConstraints { (make) in
            make.top.equalTo(self.subsBtn.snp.bottom).offset(topOffset)
            make.width.equalTo(self.view.snp.width).offset(-40)
            make.height.equalTo(2)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        
        self.tipsBtn.setImage(UIImage(named: "tips_unsel"), for: .normal)
        self.tipsBtn.setTitle("Intro To Keto", for: .normal)
        self.tipsBtn.addTarget(self, action: #selector(setTipsPressed), for: .touchUpInside)
        self.view.addSubview(self.tipsBtn)
        self.tipsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(leftOffset)
            make.top.equalTo(self.horizLine5.snp.bottom).offset(topOffset)
        }
        
        
        
         self.view.addSubview(horizLine6)
         horizLine6.snp.makeConstraints { (make) in
             make.top.equalTo(self.tipsBtn.snp.bottom).offset(topOffset)
             make.width.equalTo(self.view.snp.width).offset(-40)
             make.height.equalTo(2)
             make.centerX.equalTo(self.view.snp.centerX)
         }
         
         
         self.settingsBtn.setImage(UIImage(named: "settings_unsel"), for: .normal)
         self.settingsBtn.setTitle("Settings", for: .normal)
         self.settingsBtn.addTarget(self, action: #selector(setSettingsPressed), for: .touchUpInside)
         self.view.addSubview(self.settingsBtn)
         self.settingsBtn.snp.remakeConstraints { (make) in
             make.left.equalTo(self.view.snp.left).offset(leftOffset)
             make.top.equalTo(self.horizLine6.snp.bottom).offset(topOffset)
         }
               
        
    }

    
    
    @objc func setAllPressed() {
        self.resetConstraints()
        
            self.allBtn.titleLabel?.font = StyleManager.menuFontSel

            self.allBtn.snp.remakeConstraints { (make) in
                make.left.equalTo(self.view.snp.left).offset(40)
                make.top.equalTo(self.topIcon.snp.bottom).offset(60)
        }
        
        
        
        
        let vc = LandingFeedVC()
        vc.firstLaunch = false
        if panel!.center is UINavigationController {
            let view = panel!.center as! UINavigationController
            view.pushViewController(vc, animated: true)
            panel!.center(view)
        }
        
        
    }

    
    @objc func setFavsPressed() {
        self.resetConstraints()
        
        self.favsBtn.titleLabel?.font = StyleManager.menuFontSel
        self.favsBtn.setImage(UIImage(named: "fav_sel"), for: .normal)
            
        self.favsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(40)
            make.top.equalTo(self.horizLine1.snp.bottom).offset(self.topOffset)
        }
        
        let vc = FavouritesVC()
        
        if panel!.center is UINavigationController {
            let view = panel!.center as! UINavigationController
            view.pushViewController(vc, animated: true)
            panel!.center(view)

        }
        
        

    }
    
    @objc func setShoppingPressed() {
        self.resetConstraints()
        
        self.shoppingBtn.titleLabel?.font = StyleManager.menuFontSel
        self.shoppingBtn.setImage(UIImage(named: "shopping_sel"), for: .normal)
        
        self.shoppingBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(40)
            make.top.equalTo(self.horizLine2.snp.bottom).offset(self.topOffset)
        }
        
        
        //let vc = FoodsToAvoidVC()
        let vc = ShoppingListVC()
        
        if panel!.center is UINavigationController {
            let view = panel!.center as! UINavigationController
            view.pushViewController(vc, animated: true)
            panel!.center(view)
        }


    }
    
    @objc func setBasicsPressed() {
        self.resetConstraints()
           
        self.basicsBtn.titleLabel?.font = StyleManager.menuFontSel
        self.basicsBtn.setImage(UIImage(named: "basic_sel"), for: .normal)
           
        self.basicsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(40)
            make.top.equalTo(self.horizLine3.snp.bottom).offset(self.topOffset)
        }
        
        let vc = SuppsVC()
            if panel!.center is UINavigationController {
                let view = panel!.center as! UINavigationController
                view.pushViewController(vc, animated: true)
                panel!.center(view)
        }

        

    }
    
    @objc func setSubsPressed() {
        self.resetConstraints()
        
        self.subsBtn.titleLabel?.font = StyleManager.menuFontSel
        self.subsBtn.setImage(UIImage(named: "subs_sel"), for: .normal)
        
        self.subsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(40)
            make.top.equalTo(self.horizLine4.snp.bottom).offset(self.topOffset)
        }
        
        let vc = CarbsSubsVC()
        if panel!.center is UINavigationController {
            let view = panel!.center as! UINavigationController
            view.pushViewController(vc, animated: true)
            panel!.center(view)
        }

    }

    @objc func setTipsPressed() {
        self.resetConstraints()
        
        self.tipsBtn.titleLabel?.font = StyleManager.menuFontSel
        self.tipsBtn.setImage(UIImage(named: "tips_sel"), for: .normal)
        
        self.tipsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(40)
            make.top.equalTo(self.horizLine5.snp.bottom).offset(self.topOffset)
        }
        
        //let vc = TipsVC()
        let vc = IntroKetoVC()
        if panel!.center is UINavigationController {
            let view = panel!.center as! UINavigationController
            view.pushViewController(vc, animated: true)
            panel!.center(view)

        }
           

    }
    
    @objc func setSettingsPressed() {
        self.resetConstraints()
        
        self.settingsBtn.titleLabel?.font = StyleManager.menuFontSel
        self.settingsBtn.setImage(UIImage(named: "settings_sel"), for: .normal)
        
        self.settingsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(40)
            make.top.equalTo(self.horizLine6.snp.bottom).offset(self.topOffset)
        }
        
        let vc = SettingsVC()
        if panel!.center is UINavigationController {
            let view = panel!.center as! UINavigationController
            view.pushViewController(vc, animated: true)
            panel!.center(view)
        }

    }

    
    
    func resetConstraints() {
        self.allBtn.setImage(UIImage(named: "allRec_unsel"), for: .normal)
        self.allBtn.titleLabel?.font = StyleManager.menuFontUnsel
        self.allBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(leftOffset)
            make.top.equalTo(self.topIcon.snp.bottom).offset(60)

        }
        
        self.favsBtn.setImage(UIImage(named: "fav_unsel"), for: .normal)
        self.favsBtn.titleLabel?.font = StyleManager.menuFontUnsel
        self.favsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(leftOffset)
            make.top.equalTo(self.horizLine1.snp.bottom).offset(topOffset)

        }
        
        self.shoppingBtn.setImage(UIImage(named: "shopping_unsel"), for: .normal)
        self.shoppingBtn.titleLabel?.font = StyleManager.menuFontUnsel
        self.shoppingBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(leftOffset)
            make.top.equalTo(self.horizLine2.snp.bottom).offset(topOffset)

        }
        
        self.basicsBtn.setImage(UIImage(named: "basic_unsel"), for: .normal)
        self.basicsBtn.titleLabel?.font = StyleManager.menuFontUnsel
        self.basicsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(leftOffset)
            make.top.equalTo(self.horizLine3.snp.bottom).offset(topOffset)

        }
        
        self.subsBtn.setImage(UIImage(named: "subs_unsel"), for: .normal)
        self.subsBtn.titleLabel?.font = StyleManager.menuFontUnsel
        self.subsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(leftOffset)
            make.top.equalTo(self.horizLine4.snp.bottom).offset(topOffset)

        }
        
        self.tipsBtn.setImage(UIImage(named: "tips_unsel"), for: .normal)
        self.tipsBtn.titleLabel?.font = StyleManager.menuFontUnsel
        self.tipsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(leftOffset)
            make.top.equalTo(self.horizLine5.snp.bottom).offset(topOffset)

        }
        
        self.settingsBtn.setImage(UIImage(named: "settings_unsel"), for: .normal)
        self.settingsBtn.titleLabel?.font = StyleManager.menuFontUnsel
        self.settingsBtn.snp.remakeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(leftOffset)
            make.top.equalTo(self.horizLine6.snp.bottom).offset(topOffset)

        }
        
    }

}
