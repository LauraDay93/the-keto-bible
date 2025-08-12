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

class GettingStartedVC2 : UIViewController, UIScrollViewDelegate  {
    
    var titleLbl = UILabel()
    var bgVC : UIImageView!
    var scrollView : UIScrollView!
    
    var backBtn = SpringButton()
    
    var nxtBtn = SpringButton()

    
    let whiteContainer = UIView()
    let whiteContainer2 = UIView()
    let whiteContainer3 = UIView()
    let whiteContainer4 = UIView()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        self.view.backgroundColor = .white
        
        self.bgVC = UIImageView(image: UIImage(named: "gettingStartedBG"))
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
        
        if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone6 || UIDevice.current.type == .iPhone6S || UIDevice.current.type == .iPhone7 || UIDevice.current.type == .iPhone8 || UIDevice.current.type == .iPhone11Pro || UIDevice.current.type == .iPhone12mini || UIDevice.current.type == .iPhoneSE {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+300)
        } else if  UIDevice.current.type == .iPhone6Plus || UIDevice.current.type == .iPhone6SPlus || UIDevice.current.type == .iPhone7Plus || UIDevice.current.type == .iPhone8Plus || UIDevice.current.type == .iPhone12 || UIDevice.current.type == .iPhone12Pro || UIDevice.current.type == .iPhoneX || UIDevice.current.type == .iPhoneXS || UIDevice.current.type == .iPhoneXR {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+140)
        }else {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }
        
        scrollView.contentOffset.x = 0
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)



        titleLbl.text = "Getting Started"
        titleLbl.font = UIFont(name: "Avenir-Black", size: 24)
        titleLbl.textColor = .black
        self.scrollView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints{ (make) in
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone6 || UIDevice.current.type == .iPhone6S || UIDevice.current.type == .iPhone7 || UIDevice.current.type == .iPhone8 || UIDevice.current.type == .iPhone6Plus || UIDevice.current.type == .iPhone6SPlus || UIDevice.current.type == .iPhone7Plus || UIDevice.current.type == .iPhone8Plus || UIDevice.current.type == .iPhoneSE {
                make.top.equalTo(self.scrollView.snp.top).offset(20)
            } else {
                make.top.equalTo(self.scrollView.snp.top).offset(40)
            }
            make.centerX.equalTo(self.scrollView.snp.centerX)
        }
        
        
        let subTitle = UILabel()
        subTitle.text = "2 of 2"
        subTitle.font = UIFont(name: "Avenir-Book", size: 14)
        subTitle.textColor = .black
        self.scrollView.addSubview(subTitle)
        subTitle.snp.makeConstraints{ (make) in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(5)
            make.centerX.equalTo(self.scrollView.snp.centerX)
        }
        
        
        let stringTxt = "It is seen that large fasting periods aren’t necessary for success with the ketogenic diet, however as ketosis progresses you can start to implement intermittent fasting as you naturally begin to feel less hungry. Getting into Ketosis is made more efficient through depletion of glycogen stores, which means that it’s important to stay active as you make the change to a keto diet. The keto diet works best when the focus is on getting basic nutrition in, being mindful of carbohydrates and fiber and focusing on including diverse sources of fats and protein. Carbohydrate molecules are really good at storing water in the muscles and the abdomen too, so when you start to limit carbohydrates the fluid retention of the body also changes. This means that maintaining hydration with water consumption and boosting absorption with use of electrolytes is essential. It is important to be mindful of electrolyte supplements though, as they will need to be sugarfree to fit the keto parameters."
        
        
        let mainDescLbl = UILabel()
        mainDescLbl.textColor = .black
        mainDescLbl.textAlignment = .center
        mainDescLbl.numberOfLines = 0

        mainDescLbl.setLineHeight(lineHeight: 0.9)
        mainDescLbl.lineBreakMode = .byTruncatingTail
        var textFont : UIFont!
        if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhoneSE {
            textFont = UIFont(name: "Avenir-Book", size: 11)
        }else {
            textFont = UIFont(name: "Avenir-Book", size: 14)
        }
        let paragraphStyle = NSMutableParagraphStyle()
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
            make.top.equalTo(subTitle.snp.bottom).offset(20)
        }
        
        let titleLbl2 = UILabel()
        titleLbl2.text = "Reminders"
        titleLbl2.font = UIFont(name: "Avenir-Black", size: 24)
        titleLbl2.textColor = .black
        self.scrollView.addSubview(titleLbl2)
        titleLbl2.snp.makeConstraints{ (make) in
            make.top.equalTo(mainDescLbl.snp.bottom).offset(40)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        for container in [whiteContainer, whiteContainer2, whiteContainer3, whiteContainer4] {
            container.backgroundColor = .white
            container.layer.borderWidth = 1
            container.layer.cornerRadius = 20
            container.layer.borderColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 0.17).cgColor
        }
                
        var containerHeight = 85
        var containerWidth = 330
        
        let reminderLbl = UILabel()
        let reminderLbl2 = UILabel()
        let reminderLbl3 = UILabel()
        let reminderLbl4 = UILabel()



        for label in [reminderLbl, reminderLbl2, reminderLbl3, reminderLbl4] {
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhoneSE {
                 containerHeight = 100
                 containerWidth = 260
                label.font = UIFont(name: "Avenir-Book", size: 10)
            } else {
                label.font = UIFont(name: "Avenir-Book", size: 12)
            }
            
            label.lineBreakMode = .byTruncatingTail
            label.numberOfLines = 0
            label.textColor = .black
        }
         
        self.scrollView.addSubview(whiteContainer)
        whiteContainer.snp.makeConstraints { (make) in
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
            make.centerX.equalTo(self.scrollView.snp.centerX)
            make.top.equalTo(mainDescLbl.snp.bottom).offset(20)
        }
        
        
        let reminderIcon = UIImageView(image: UIImage(named: "reminderIcon.png"))
        reminderLbl.text = "The restriction of carbohydrates is quite strict with the keto diet. You will aim to eat a maximum of 50g of carbohydrates per day."
        
        whiteContainer.addSubview(reminderIcon)
        reminderIcon.snp.makeConstraints { (make) in
            make.left.equalTo(whiteContainer.snp.left).offset(10)
            make.centerY.equalTo(whiteContainer.snp.centerY)
        }
        
        whiteContainer.addSubview(reminderLbl)
        reminderLbl.snp.makeConstraints { (make) in
            make.right.equalTo(whiteContainer.snp.right).offset(-5)
            make.centerY.equalTo(whiteContainer.snp.centerY)
            make.left.equalTo(reminderIcon.snp.right).offset(10)
            make.height.equalTo(self.whiteContainer.snp.height).offset(-15)
        }
        
        self.scrollView.addSubview(whiteContainer2)
        whiteContainer2.snp.makeConstraints { (make) in
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
            make.centerX.equalTo(self.scrollView.snp.centerX)
            make.top.equalTo(whiteContainer.snp.bottom).offset(20)
        }
        
        let reminderIcon2 = UIImageView(image: UIImage(named: "reminderIcon.png"))
        reminderLbl2.text = "The restriction of carbohydrates is quite strict with the keto diet. You will aim to eat a maximum of 50g of carbohydrates per day."
        
        whiteContainer2.addSubview(reminderIcon2)
        reminderIcon2.snp.makeConstraints { (make) in
            make.left.equalTo(whiteContainer2.snp.left).offset(10)
            make.centerY.equalTo(whiteContainer2.snp.centerY)
        }
        
        whiteContainer2.addSubview(reminderLbl2)
        reminderLbl2.snp.makeConstraints { (make) in
            make.right.equalTo(whiteContainer2.snp.right).offset(-5)
            make.centerY.equalTo(whiteContainer2.snp.centerY)
            make.left.equalTo(reminderIcon2.snp.right).offset(10)
            make.height.equalTo(self.whiteContainer2.snp.height).offset(-15)
        }
        
        
        self.scrollView.addSubview(whiteContainer3)
        whiteContainer3.snp.makeConstraints { (make) in
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
            make.centerX.equalTo(self.scrollView.snp.centerX)
            make.top.equalTo(whiteContainer2.snp.bottom).offset(20)
        }
        
        let reminderIcon3 = UIImageView(image: UIImage(named: "reminderIcon.png"))
        reminderLbl3.text = "It is important to track your intake of all foods, as excessive protein consumption can also lead to gluconeogenesis (the building of carbohydrate molecules) and can pull you out of a ketotic state."
        
        whiteContainer3.addSubview(reminderIcon3)
        reminderIcon3.snp.makeConstraints { (make) in
            make.left.equalTo(whiteContainer3.snp.left).offset(10)
            make.centerY.equalTo(whiteContainer3.snp.centerY)
        }
        
        whiteContainer3.addSubview(reminderLbl3)
        reminderLbl3.snp.makeConstraints { (make) in
            make.right.equalTo(whiteContainer3.snp.right).offset(-5)
            make.centerY.equalTo(whiteContainer3.snp.centerY)
            make.left.equalTo(reminderIcon3.snp.right).offset(10)
            make.height.equalTo(self.whiteContainer3.snp.height).offset(-15)
        }

        self.scrollView.addSubview(whiteContainer4)
        whiteContainer4.snp.makeConstraints { (make) in
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
            make.centerX.equalTo(self.scrollView.snp.centerX)
            make.top.equalTo(whiteContainer3.snp.bottom).offset(20)
        }
        
        let reminderIcon4 = UIImageView(image: UIImage(named: "reminderIcon.png"))
        reminderLbl4.text = "The focus is on total restriction of carbohydrates, eating a moderate amount of protein and getting most of the daily intake of calories from fats."
        
        whiteContainer4.addSubview(reminderIcon4)
        reminderIcon4.snp.makeConstraints { (make) in
            make.left.equalTo(whiteContainer4.snp.left).offset(10)
            make.centerY.equalTo(whiteContainer4.snp.centerY)
        }
        
        whiteContainer4.addSubview(reminderLbl4)
        reminderLbl4.snp.makeConstraints { (make) in
            make.right.equalTo(whiteContainer4.snp.right).offset(-5)
            make.centerY.equalTo(whiteContainer4.snp.centerY)
            make.left.equalTo(reminderIcon4.snp.right).offset(10)
            make.height.equalTo(self.whiteContainer4.snp.height).offset(-15)
        }
        
        
        
        self.nxtBtn.backgroundColor = .black
        self.nxtBtn.setTitle("Next", for: .normal)
        
        if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhoneSE {
            self.nxtBtn.layer.cornerRadius = 15
            self.nxtBtn.titleLabel?.font = UIFont(name: "Avenir-Book", size: 13)
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
            make.top.equalTo(whiteContainer4.snp.bottom).offset(30)
        }
        self.nxtBtn.addTarget(self, action: #selector(nextBtnPressed), for: .touchUpInside)
        
        

        
    }
    
    @objc func nextBtnPressed() {
        self.nxtBtn.pop {
            self.navigationController?.pushViewController(FastingVC(), animated: true)
        }
    }
    
    

    @objc func backButtonSelected() {
        self.navigationController?.popViewController(animated: true)
    }
       
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    
}
