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

class WhatIsKetoVC : UIViewController, UIScrollViewDelegate  {
    
    var titleLbl = UILabel()
    var bgVC : UIImageView!
    var scrollView : UIScrollView!
    
    var backBtn = SpringButton()
    
    var nxtBtn = SpringButton()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        self.view.backgroundColor = .white
        
        self.bgVC = UIImageView(image: UIImage(named: "whatIsKetoBG"))
        self.bgVC.contentMode = .scaleAspectFill
        self.bgVC.clipsToBounds = true
        self.view.addSubview(bgVC)
        bgVC.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.snp.edges)
        }
        
        
        
        let backIcon = UIImage(named: "BackButton.pdf")
        backBtn.setImage(backIcon, for: .normal)

       self.view.addSubview(backBtn)
       self.backBtn.snp.makeConstraints{ (make) in
        make.top.equalTo(self.view.snp.top).offset(StyleManager.topOffset)
           make.left.equalTo(self.view.snp.left).offset(20)
       }
       
       self.backBtn.addTarget(self, action: #selector(backButtonSelected), for: .touchUpInside)


        
        self.scrollView = UIScrollView()
        self.scrollView.backgroundColor = .clear
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ (make) in
            make.top.equalTo(backBtn.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)

        }
        
        if UIDevice.current.type == .iPhone6 || UIDevice.current.type == .iPhone6S || UIDevice.current.type == .iPhone7 || UIDevice.current.type == .iPhone8 || UIDevice.current.type == .iPhone6Plus || UIDevice.current.type == .iPhone6SPlus || UIDevice.current.type == .iPhone7Plus || UIDevice.current.type == .iPhone8Plus  {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+180)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        } else {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        }
        scrollView.contentOffset.x = 0



        titleLbl.text = "What is the Keto Diet?"
        titleLbl.font = UIFont(name: "Avenir-Black", size: 24)
        titleLbl.textColor = .black
        self.scrollView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints{ (make) in
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone6 || UIDevice.current.type == .iPhone6S || UIDevice.current.type == .iPhone7  || UIDevice.current.type == .iPhone8 || UIDevice.current.type == .iPhone6Plus || UIDevice.current.type == .iPhone6SPlus || UIDevice.current.type == .iPhone7Plus || UIDevice.current.type == .iPhone8Plus || UIDevice.current.type == .iPhoneSE {
                make.top.equalTo(self.scrollView.snp.top).offset(20)
            } else {
                make.top.equalTo(self.scrollView.snp.top).offset(40)
            }
            make.centerX.equalTo(self.scrollView.snp.centerX)
        }
        

        
        let stringTxt = "The ketogenic diet is considered highly effective in promoting weight-loss in a general population, but can also have significant benefits for athletic performance and chronic disease management too! There is more to losing weight than simply eating less and moving more, and the ketogenic diet is based on altering physiological processes to induce large scale changes, which include weight loss and promote lean muscle gains. Essentially, the keto diet changes the way the body uses energyIn normal circumstances the human body is built to use carbohydrates as energy. Our microbiome is responsible for converting the food that enters the small intestine into substrates called short-chain-fatty-acids (SCFAs), such as butyrate, acetate and propionate. The body then uses these SCFAs to power all other physiological processes. Any carbohydrate that isn’t used by the body as an immediate energy source is then stored in the muscles as glycogen or in the body as fat, a process called lipogenesis. Ketosis involves switching the way that the body harvests energy from carbohydrates to harvesting it from fats. Ketosis is the metabolic process of the body using fat for energy when it no longer has a supply of glucose from carbohydrates. Ketosis is so named because of the increased production of ketones when carbohydrates are restricted. Basically, the liver produces ketones from protein and fat breakdown and uses then uses these ketones for fuel instead of carbohydrates. In ketosis your body is burning fat instead of glucose for energy. Fats also fuel the brain, which is actually 60% fat! The brain is efficient in utilising ketones for energy and studies have shown that ketosis can be neuroprotective and work to improve memory and slow cognitive decline."
        
        let mainDescLbl = UILabel()
        mainDescLbl.textColor = .black
        mainDescLbl.textAlignment = .center
        mainDescLbl.numberOfLines = 0

        mainDescLbl.setLineHeight(lineHeight: 0.9)
        mainDescLbl.lineBreakMode = .byTruncatingTail
        let paragraphStyle = NSMutableParagraphStyle()

        var textFont : UIFont!
        if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhoneSE  {
            paragraphStyle.lineHeightMultiple = 1
            textFont = UIFont(name: "Avenir-Book", size: 11)
        }else {
            textFont = UIFont(name: "Avenir-Book", size: 14)
        }
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
            make.top.equalTo(titleLbl.snp.bottom).offset(20)
            make.bottom.equalTo(self.scrollView.snp.bottom)
        }
        
        self.nxtBtn.backgroundColor = .black
        self.nxtBtn.setTitle("Next", for: .normal)
        
        if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhoneSE  {
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
    
    @objc func nextBtnPressed() {
        self.nxtBtn.pop {
            self.navigationController?.pushViewController(BenefitsKetoVC(), animated: true)
        }
    }
    
    

    @objc func backButtonSelected() {
        self.navigationController?.popViewController(animated: true)
    }
       
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    
}
