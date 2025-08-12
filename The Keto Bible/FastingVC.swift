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

class FastingVC : UIViewController, UIScrollViewDelegate  {
    
    var titleLbl = UILabel()
    var bgVC : UIImageView!
    var scrollView : UIScrollView!
    
    var backBtn = SpringButton()
    
    var nxtBtn = SpringButton()

    
    let whiteContainer = UIView()
    let whiteContainer2 = UIView()
    let whiteContainer3 = UIView()
    let whiteContainer4 = UIView()
    let whiteContainer5 = UIView()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        self.view.backgroundColor = .white
        
        self.bgVC = UIImageView(image: UIImage(named: "fastingBG"))
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
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone6 || UIDevice.current.type == .iPhone6S || UIDevice.current.type == .iPhone7 || UIDevice.current.type == .iPhone8 || UIDevice.current.type == .iPhone11Pro || UIDevice.current.type == .iPhoneSE{
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+380)
        } else if  UIDevice.current.type == .iPhone6Plus || UIDevice.current.type == .iPhone6SPlus || UIDevice.current.type == .iPhone7Plus || UIDevice.current.type == .iPhone8Plus || UIDevice.current.type == .iPhone12mini || UIDevice.current.type == .iPhoneX || UIDevice.current.type == .iPhoneXS || UIDevice.current.type == .iPhoneXR {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+220)
        }else if UIDevice.current.type == .iPhone12 || UIDevice.current.type == .iPhone12Pro  {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+130)
        }else {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+100)
        }

        scrollView.contentOffset.x = 0


        titleLbl.text = "Fasting"
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
        
        
        let stringTxt = "The Keto diet works fantastically with intermittent fasting, which is essentially limiting the window of hours in the day where you consume food. The most viable and beneficial eating window associated with intermittent fasting is seen to be between 6-8 hours. This means that if your first meal is at 12pm, you’ll have your last meal between 6-8pm that same day. With the Keto diet, the increased protein and fat intake changes the hunger signalling to the brain and in most people, the feeling of being full, or “satiated”, lasts a lot longer. Introducing intermittent fasting whilst eating a keto diet can occur naturally as you progress. Intermittent fasting is also effective in reducing the total number of calories consumed in a day, which also assists weight loss. Individuals who use intermittent fasting whilst in ketosis don’t experience large fluctuations in blood sugar, which can be experienced when eating high carbohydrate diets, this makes fasting more sustainable and beneficial for overall health promotion. "
        
        
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
            make.top.equalTo(titleLbl.snp.bottom).offset(20)
        }
        
        let titleLbl2 = UILabel()
        titleLbl2.text = "Key Fasting Tips"
        titleLbl2.font = UIFont(name: "Avenir-Black", size: 24)
        titleLbl2.textColor = .black
        self.scrollView.addSubview(titleLbl2)
        titleLbl2.snp.makeConstraints{ (make) in
            make.top.equalTo(mainDescLbl.snp.bottom).offset(40)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        for container in [whiteContainer, whiteContainer2, whiteContainer3, whiteContainer4, whiteContainer5] {
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
        let reminderLbl5 = UILabel()



        for label in [reminderLbl, reminderLbl2, reminderLbl3, reminderLbl4, reminderLbl5] {
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhoneSE {
                 containerHeight = 80
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
        
        
        let reminderIcon = UIImageView(image: UIImage(named: "fastingTipIcon.png"))

        reminderLbl.text = "If you have reached a plateau with your goals, try implementing fasting to see if that kick starts results again."
        
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
        
        let reminderIcon2 = UIImageView(image: UIImage(named: "fastingTipIcon.png"))
        reminderLbl2.text = "You don’t have to eat this way everyday, start with implementing a couple of days a week and see how it feels."
        
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
        
        let reminderIcon3 = UIImageView(image: UIImage(named: "fastingTipIcon.png"))
        reminderLbl3.text = "Start with a window you know will be easy to fit into your lifestyle, such as 11am-7pm or 10am-5pm."
        
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
        
        let reminderIcon4 = UIImageView(image: UIImage(named: "fastingTipIcon.png"))
        reminderLbl4.text = "Once you know if intermittent fasting is helping you, try shortening your eating window or changing your time frame."
        
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
        
        self.scrollView.addSubview(whiteContainer5)
        whiteContainer5.snp.makeConstraints { (make) in
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
            make.centerX.equalTo(self.scrollView.snp.centerX)
            make.top.equalTo(whiteContainer4.snp.bottom).offset(20)
        }
        
        let reminderIcon5 = UIImageView(image: UIImage(named: "fastingTipIcon.png"))
        reminderLbl5.text = "Drink plenty of water in the morning and try carbohydrate free drinks such as green tea or black coffee."
        
        whiteContainer5.addSubview(reminderIcon5)
        reminderIcon5.snp.makeConstraints { (make) in
            make.left.equalTo(whiteContainer5.snp.left).offset(10)
            make.centerY.equalTo(whiteContainer5.snp.centerY)
        }
        
        whiteContainer5.addSubview(reminderLbl5)
        reminderLbl5.snp.makeConstraints { (make) in
            make.right.equalTo(whiteContainer5.snp.right).offset(-5)
            make.centerY.equalTo(whiteContainer5.snp.centerY)
            make.left.equalTo(reminderIcon5.snp.right).offset(10)
            make.height.equalTo(self.whiteContainer5.snp.height).offset(-15)
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
            make.top.equalTo(whiteContainer5.snp.bottom).offset(30)
        }
        self.nxtBtn.addTarget(self, action: #selector(nextBtnPressed), for: .touchUpInside)
        
        

        
    }
    
    @objc func nextBtnPressed() {
        self.nxtBtn.pop {
            self.navigationController?.pushViewController(AthleticVC(), animated: true)
        }
    }
    

    @objc func backButtonSelected() {
        self.navigationController?.popViewController(animated: true)
    }
       
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    
}
