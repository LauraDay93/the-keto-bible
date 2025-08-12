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

class IntroKetoVC : UIViewController, UIScrollViewDelegate  {
    
    var titleLbl = UILabel()
    var bgVC : UIImageView!
    var scrollView : UIScrollView!
    
    var menuBtn = SpringButton()
    
    var nxtBtn = SpringButton()

        
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
        scrollView.isScrollEnabled = false
        
        if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone6 || UIDevice.current.type == .iPhone6S || UIDevice.current.type == .iPhone7  || UIDevice.current.type == .iPhone8 {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 300)

        } else {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        }
        scrollView.contentOffset.x = 0

        self.bgVC = UIImageView(image: UIImage(named: "ketoIntroBG"))
        self.bgVC.contentMode = .scaleAspectFill
        self.bgVC.clipsToBounds = true
        self.scrollView.addSubview(bgVC)
        bgVC.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.snp.edges)
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


        
        let stringTxt = "Generally, the hardest part about making lasting diet changes is staying motivated and consistent through the process. Some days being mindful of food intake and exercise and nourishing nutrients comes second nature, other days it takes all your will not to go completely off track! Just know that it takes time and effort to learn how to make your goals suit your lifestyle, and it definitely requires support and guidance. The Keto Hack is your support system, your fall back plan and your teacher all in one - and we live in your pocket! We want to make shifting to the keto lifestyle simple and rewarding! Check out our recipes and learn how to create your own menu plan and start achieving your goals!"
        
        let mainLogo = UIImageView(image: UIImage(named: "fullLogo"))
        self.scrollView.addSubview(mainLogo)
        mainLogo.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone6 || UIDevice.current.type == .iPhone6S || UIDevice.current.type == .iPhone7 || UIDevice.current.type == .iPhone8 || UIDevice.current.type == .iPhoneSE  {
                make.top.equalTo(self.view.snp.top).offset(100)
                make.width.equalTo(mainLogo.frame.width/1.7)
                make.height.equalTo(mainLogo.frame.height/1.7)
            }else if UIDevice.current.type == .iPhone6Plus || UIDevice.current.type == .iPhone6SPlus || UIDevice.current.type == .iPhone7Plus || UIDevice.current.type == .iPhone8Plus {
                make.top.equalTo(self.view.snp.top).offset(100)
            } else {
                make.top.equalTo(self.view.snp.top).offset(175)
            }
        }
        
        let mainDescLbl = UILabel()
        mainDescLbl.textColor = .black
        mainDescLbl.textAlignment = .center
        mainDescLbl.numberOfLines = 0

        
        mainDescLbl.lineBreakMode = .byTruncatingTail
        
        let paragraphStyle = NSMutableParagraphStyle()
        var textFont : UIFont!
        if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhoneSE  {
            paragraphStyle.lineHeightMultiple = 1
            textFont = UIFont(name: "Avenir-Book", size: 11)
        }else {
            textFont = UIFont(name: "Avenir-Book", size: 14)

        }
        
        mainDescLbl.setLineHeight(lineHeight: 0.9)
        paragraphStyle.lineSpacing = 0.9
        paragraphStyle.lineHeightMultiple = 1.3
        
        paragraphStyle.alignment = .center
        let attributedString = NSMutableAttributedString(string: stringTxt)
        let mainRange =  NSMakeRange(0, (stringTxt as NSString).length)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: mainRange)
        attributedString.addAttributes([ NSAttributedString.Key.font : textFont! ], range: mainRange);
        mainDescLbl.attributedText = attributedString
        self.scrollView.addSubview(mainDescLbl)
        mainDescLbl.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.snp.width).offset(-40)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(mainLogo.snp.bottom).offset(20)
        }
        
        self.nxtBtn.backgroundColor = .black
        self.nxtBtn.setTitle("Next", for: .normal)
        if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhoneSE {
            self.nxtBtn.layer.cornerRadius = 15
            self.nxtBtn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 11)
        } else {
            self.nxtBtn.layer.cornerRadius = 25
            self.nxtBtn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 13)
        }
        
        self.scrollView.addSubview(self.nxtBtn)
        self.nxtBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhoneSE {
                make.width.equalTo(200)
                make.height.equalTo(35)

            } else {
                make.width.equalTo(315)
                make.height.equalTo(55)

            }
            make.top.equalTo(mainDescLbl.snp.bottom).offset(30)
        }
        self.nxtBtn.addTarget(self, action: #selector(nextBtnPressed), for: .touchUpInside)
        
        

        
    }
    
    @objc func nextBtnPressed () {
        self.nxtBtn.pop {
            
            self.navigationController?.pushViewController(WhatIsKetoVC(), animated: true)
        }
    }

    @objc func menuButtonSelected() {
           panel?.openLeft(animated: true)
       }
       
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    
}
