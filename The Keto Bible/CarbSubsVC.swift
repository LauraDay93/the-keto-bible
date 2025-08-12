//
//  TipsVC.swift
//  The Keto Bible
//
//  Created by Laura Day on 7/10/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring

class CarbsSubsVC : UIViewController, UIScrollViewDelegate  {
    
    var titleLbl = UILabel()
    var bgVC : UIImageView!
    var scrollView : UIScrollView!
    var menuBtn = SpringButton()

    
    var headingBGView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        self.view.backgroundColor = .white
        
        self.scrollView = UIScrollView()
        self.scrollView.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ (make) in
            make.edges.equalTo(self.view.snp.edges)
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 3000)
        scrollView.contentOffset.x = 0

        self.bgVC = UIImageView(image: UIImage(named: "carbsBG"))
        self.bgVC.contentMode = .scaleAspectFill
        self.bgVC.clipsToBounds = true
        self.scrollView.addSubview(bgVC)
        bgVC.snp.makeConstraints { (make) in
            make.top.equalTo(self.scrollView.snp.top).offset(-75)
            make.bottom.equalTo(self.scrollView.snp.bottom).offset(40)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)

        }
        
        
       let ketoBibleStr : String = StyleManager.titleString

       let ketoBibleText = NSMutableAttributedString(string: ketoBibleStr, attributes: [NSAttributedString.Key.font: StyleManager.topTitleFont!])
       if StyleManager.isKeto {
           ketoBibleText.addAttributes([ NSAttributedString.Key.font : StyleManager.topTitleFontBold! ], range: NSMakeRange(4, 4));
       } else {
           ketoBibleText.addAttributes([ NSAttributedString.Key.font : StyleManager.topTitleFontBold! ], range: NSMakeRange(4, 5));
       }
       ketoBibleText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: NSMakeRange(0, ketoBibleStr.count))
       
        titleLbl.attributedText = ketoBibleText
        self.scrollView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints{ (make) in
            make.top.equalTo(self.scrollView.snp.top).offset(20)
            make.centerX.equalTo(self.scrollView.snp.centerX)
        }
        
        let menuIcon = UIImage(named: "menuIcon.pdf")
        menuBtn.setImage(menuIcon, for: .normal)

       self.view.addSubview(menuBtn)
              self.menuBtn.snp.makeConstraints{ (make) in
                  make.centerY.equalTo(self.titleLbl.snp.centerY)
                  make.right.equalTo(self.view.snp.right).offset(-20)
              }
              
              self.menuBtn.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)
        
        var yellowBGWidth = 314
        if UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5 {
            //yellowBGWidth = 260
        } else if StyleManager.isIpad() {
            yellowBGWidth = 514
        }
        
        self.headingBGView.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.32, alpha:0.6)
               self.scrollView.addSubview(headingBGView)
               self.headingBGView.snp.makeConstraints { (make) in
                   make.top.equalTo(self.titleLbl.snp.bottom).offset(30)
                   make.right.equalTo(self.view.snp.right)
    
                   make.width.equalTo(yellowBGWidth)
                   make.height.equalTo(57)
               }
               
        let topTitle1 = UILabel()
        topTitle1.adjustsFontSizeToFitWidth = true
        topTitle1.numberOfLines = 1
        topTitle1.text = "Bread Substitutes"
        topTitle1.textAlignment = .center
        topTitle1.textColor = .black
        topTitle1.font = StyleManager.tipsHeadingFont
        self.headingBGView.addSubview(topTitle1)
        topTitle1.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.headingBGView.snp.centerY)
            make.left.equalTo(self.headingBGView.snp.left).offset(10)
            make.right.equalTo(self.headingBGView.snp.right).offset(-10)
        }
        
        let paragraph1 = UILabel()
        let paragraph2 = UILabel()
        let paragraph3 = UILabel()
        let paragraph4 = UILabel()
        let paragraph5 = UILabel()
        let paragraph6 = UILabel()
        let paragraph7 = UILabel()


        for label in [paragraph1, paragraph2, paragraph3, paragraph4, paragraph5, paragraph6, paragraph7] {
            label.textColor = .black
            label.font = StyleManager.carbsParagraphFont
            label.textAlignment = .center
            label.numberOfLines = 4

        }
        
        
        paragraph1.numberOfLines = 6
        paragraph1.text = "Eggplant and Zucchini \n Simply cut into round slices, toss in oil, herbs, bake and enjoy! Need extra fats? Top with cheese, butter or other goodies and spice it up."
        paragraph1.changeFont(ofText: "Eggplant and Zucchini", with: StyleManager.carbsBoldFont)
        self.scrollView.addSubview(paragraph1)
        paragraph1.snp.makeConstraints { (make) in
            make.top.equalTo(headingBGView.snp.bottom).offset(15)
            make.right.equalTo(self.view.snp.right).offset(-15)
            if StyleManager.isIpad() {
                make.width.equalTo(408)
            } else {
                make.width.equalTo(208)
            }
            make.height.equalTo(140)
        }
        
        paragraph2.text = "Cauliflower Bread \n One of the most popular carb substitutes! Simply buy the pre made bread when you’re in a rush or try making our cauliflower bread recipe!"
        paragraph2.numberOfLines = 5
        paragraph2.adjustsFontSizeToFitWidth = true
        paragraph2.changeFont(ofText: "Cauliflower Bread", with: StyleManager.carbsBoldFont)
        self.scrollView.addSubview(paragraph2)
        paragraph2.snp.makeConstraints { (make) in
            make.top.equalTo(paragraph1.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-10)
            if StyleManager.isIpad() {
                make.width.equalTo(470)
            } else {
                make.width.equalTo(270)
            }
            make.height.equalTo(100)
        }
        
        
        paragraph3.text = "Portobello Mushrooms\nIf making a sandwich or burger, try swapping the bread for portobello mushrooms!"
        paragraph3.changeFont(ofText: "Portobello Mushrooms", with: StyleManager.carbsBoldFont)
        self.scrollView.addSubview(paragraph3)
        paragraph3.snp.makeConstraints { (make) in
            make.top.equalTo(paragraph2.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right)
            if StyleManager.isIpad() {
                make.width.equalTo(484)
            } else {
                make.width.equalTo(284)
            }
            make.height.equalTo(100)
        }
        
        paragraph4.text = "Lettuce Wraps\n Looking for a tortilla substitute? Swap out the tortillas with a lettuce wrap for a carb-free alternative!"
        paragraph4.changeFont(ofText: "Lettuce Wraps", with: StyleManager.carbsBoldFont)
        self.scrollView.addSubview(paragraph4)
        paragraph4.snp.makeConstraints { (make) in
            make.top.equalTo(paragraph3.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-15)
            if StyleManager.isIpad() {
                make.width.equalTo(585)
            } else {
                make.width.equalTo(285)
            }
            make.height.equalTo(100)
        }

        
        let headingBGView2 = UIView()
        headingBGView2.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.32, alpha:0.6)
        self.scrollView.addSubview(headingBGView2)
        headingBGView2.snp.makeConstraints { (make) in
            make.top.equalTo(paragraph4.snp.bottom).offset(17)
            make.left.equalTo(self.view.snp.left)
            if StyleManager.isIpad() {
                make.width.equalTo(527)
            } else {
                make.width.equalTo(327)
                
            }
            make.height.equalTo(57)
        }
        
        let topTitle2 = UILabel()
        topTitle2.adjustsFontSizeToFitWidth = true
        topTitle2.numberOfLines = 1
        topTitle2.text = "Pasta Substitutes"
        topTitle2.textAlignment = .center
        topTitle2.textColor = .black
        topTitle2.font = StyleManager.tipsHeadingFont
        headingBGView2.addSubview(topTitle2)
        topTitle2.snp.makeConstraints { (make) in
            make.centerY.equalTo(headingBGView2.snp.centerY)
            make.left.equalTo(headingBGView2.snp.left).offset(10)
            make.right.equalTo(headingBGView2.snp.right).offset(-10)
        }
        
        paragraph5.text = "Cauliflower Rice\n Either chop and steam cauliflower, or buy it pre-made in a bag. the absolute perfect substitute for pasta or rice!"
        paragraph5.changeFont(ofText: "Cauliflower Rice", with: StyleManager.carbsBoldFont)
        self.scrollView.addSubview(paragraph5)
        paragraph5.snp.makeConstraints { (make) in
            make.top.equalTo(headingBGView2.snp.bottom).offset(15)
            make.right.equalTo(self.view.snp.right).offset(-10)
            if StyleManager.isIpad() {
                make.width.equalTo(590)
            } else {
                make.width.equalTo(290)
            }
            make.height.equalTo(100)
        }
        
        let headingBGView3 = UIView()
        headingBGView3.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.32, alpha:0.6)
        self.scrollView.addSubview(headingBGView3)
        headingBGView3.snp.makeConstraints { (make) in
            make.top.equalTo(paragraph5.snp.bottom).offset(20)
            make.right.equalTo(self.view.snp.right)
            if StyleManager.isIpad() {
                make.width.equalTo(527)
            } else {
                make.width.equalTo(327)
            }
            make.height.equalTo(57)
        }
        
        let topTitle3 = UILabel()
        topTitle3.adjustsFontSizeToFitWidth = true
        topTitle3.numberOfLines = 1
        topTitle3.text = "Rice Substitutes"
        topTitle3.textAlignment = .center
        topTitle3.textColor = .black
        topTitle3.font = StyleManager.tipsHeadingFont
        headingBGView3.addSubview(topTitle3)
        topTitle3.snp.makeConstraints { (make) in
            make.centerY.equalTo(headingBGView3.snp.centerY)
            make.left.equalTo(headingBGView3.snp.left).offset(10)
            make.right.equalTo(headingBGView3.snp.right).offset(-10)
        }
        
        paragraph6.text = "Zucchini Noodles \nZoodles! Cut zucchini into pasta shaped strings, and use just as you would pasta."
        paragraph6.changeFont(ofText: "Zucchini Noodles", with: StyleManager.carbsBoldFont)
        self.scrollView.addSubview(paragraph6)
        paragraph6.snp.makeConstraints { (make) in
            make.top.equalTo(headingBGView3.snp.bottom).offset(15)
            make.right.equalTo(self.view.snp.right).offset(-10)
            if StyleManager.isIpad() {
                make.width.equalTo(520)
                make.height.equalTo(90)
            } else {
                make.width.equalTo(320)
                make.height.equalTo(70)
            }
        }
        
        paragraph7.text = "Spaghetti Squash \nNo instruction needed! Bake your squash and scoop out!"
        paragraph7.changeFont(ofText: "Spaghetti Squash", with: StyleManager.carbsBoldFont)
        self.scrollView.addSubview(paragraph7)
        paragraph7.snp.makeConstraints { (make) in
            make.top.equalTo(paragraph6.snp.bottom).offset(5)
            make.right.equalTo(self.view.snp.right).offset(-10)
            if StyleManager.isIpad() {
                make.width.equalTo(520)
            } else {
                make.width.equalTo(320)
            }
            make.height.equalTo(100)
        }
        
    }
    
    @objc func menuButtonSelected() {
        panel?.openLeft(animated: true)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    
}
