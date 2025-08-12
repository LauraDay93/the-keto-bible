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

class BenefitsKetoVC : UIViewController, UIScrollViewDelegate  {
    
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
        
        self.bgVC = UIImageView(image: UIImage(named: "benefitsBG"))
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
        if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C  || UIDevice.current.type == .iPhoneSE {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 220, right: 0)
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        }
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentOffset.x = 0



        titleLbl.text = "Benefits of The Keto Diet"
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
        
        for container in [whiteContainer, whiteContainer2, whiteContainer3, whiteContainer4, whiteContainer5] {
            container.backgroundColor = .white
            container.layer.borderWidth = 1
            container.layer.cornerRadius = 20
            container.layer.borderColor = UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 0.17).cgColor
        }
                
        var containerHeight = 96
        var containerWidth = 360
        let benefit1Icon = UIImageView(image: UIImage(named: "benefit1Icon.png"))
        let benefit1Lbl = UILabel()
        let benefit2Icon = UIImageView(image: UIImage(named: "benefit2Icon.png"))
        let benefit2Lbl = UILabel()
        let benefit3Icon = UIImageView(image: UIImage(named: "benefit3Icon.png"))
        let benefit3Lbl = UILabel()
        let benefit4Icon = UIImageView(image: UIImage(named: "benefit4Icon.png"))
        let benefit4Lbl = UILabel()
        let benefit5Icon = UIImageView(image: UIImage(named: "benefit5Icon.png"))
        let benefit5Lbl = UILabel()
        
        for label in [benefit1Lbl, benefit2Lbl, benefit3Lbl, benefit4Lbl, benefit5Lbl] {
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhone5S || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhoneSE {
                 containerHeight = 100
                 containerWidth = 260
                label.font = UIFont(name: "Avenir-Book", size: 10)
            } else {
                label.font = UIFont(name: "Avenir-Book", size: 12)
            }
            
            label.lineBreakMode = .byTruncatingTail
            label.numberOfLines = 0
            benefit2Lbl.textColor = .black
        }
        
        
        self.scrollView.addSubview(whiteContainer)
        whiteContainer.snp.makeConstraints { (make) in
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(titleLbl.snp.bottom).offset(20)
        }


        benefit1Lbl.text = "Eating a Keto diet gives you more energy! Energy slumps associated with carb utilization are eliminated and you can better maintain a constant energy state throughout the day, even with intense exercise."
        
        whiteContainer.addSubview(benefit1Icon)
        benefit1Icon.snp.makeConstraints { (make) in
            make.left.equalTo(whiteContainer.snp.left).offset(10)
            make.centerY.equalTo(whiteContainer.snp.centerY)
        }
        
        whiteContainer.addSubview(benefit1Lbl)
        benefit1Lbl.snp.makeConstraints { (make) in
            make.right.equalTo(whiteContainer.snp.right).offset(-5)
            make.centerY.equalTo(whiteContainer.snp.centerY)
            make.left.equalTo(benefit1Icon.snp.right).offset(10)
            make.height.equalTo(self.whiteContainer.snp.height).offset(-15)
        }
        

        self.scrollView.addSubview(whiteContainer2)
        whiteContainer2.snp.makeConstraints { (make) in
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(whiteContainer.snp.bottom).offset(20)
        }

        benefit2Lbl.text = "Ketosis promotes high-density lipoprotein (HDL) levels which is the good cholesterol. HDL is known as the good cholesterol because it activates anti-inflammatory pathways and works to protect the heart from disease."
        
        whiteContainer2.addSubview(benefit2Icon)
        benefit2Icon.snp.makeConstraints { (make) in
            make.left.equalTo(whiteContainer2.snp.left).offset(10)
            make.centerY.equalTo(whiteContainer2.snp.centerY)
        }
        
        whiteContainer2.addSubview(benefit2Lbl)
        benefit2Lbl.snp.makeConstraints { (make) in
            make.right.equalTo(whiteContainer2.snp.right).offset(-5)
            make.centerY.equalTo(whiteContainer2.snp.centerY)
            make.left.equalTo(benefit2Icon.snp.right).offset(10)
            make.height.equalTo(self.whiteContainer2.snp.height).offset(-15)
        }
        

        self.scrollView.addSubview(whiteContainer3)
        whiteContainer3.snp.makeConstraints { (make) in
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(whiteContainer2.snp.bottom).offset(20)
        }
        
        

        benefit3Lbl.text = "The Keto diet lowers risk of coronary heart disease by decreasing circulating triglycerides, which are disease causing fat molecules that circulate in the blood stream."
        
        whiteContainer3.addSubview(benefit3Icon)
        benefit3Icon.snp.makeConstraints { (make) in
            make.left.equalTo(whiteContainer3.snp.left).offset(10)
            make.centerY.equalTo(whiteContainer3.snp.centerY)
        }
        
        whiteContainer3.addSubview(benefit3Lbl)
        benefit3Lbl.snp.makeConstraints { (make) in
            make.right.equalTo(whiteContainer3.snp.right).offset(-5)
            make.centerY.equalTo(whiteContainer3.snp.centerY)
            make.left.equalTo(benefit3Icon.snp.right).offset(10)
            make.height.equalTo(self.whiteContainer3.snp.height).offset(-15)
        }

        
        self.scrollView.addSubview(whiteContainer4)
        whiteContainer4.snp.makeConstraints { (make) in
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(whiteContainer3.snp.bottom).offset(20)
        }
        
        
        benefit4Lbl.text = "A diet rich in fats supports hormone balance and appetite regulation as fats make you feel fuller for longer."
        
        whiteContainer4.addSubview(benefit4Icon)
        benefit4Icon.snp.makeConstraints { (make) in
            make.left.equalTo(whiteContainer4.snp.left).offset(10)
            make.centerY.equalTo(whiteContainer4.snp.centerY)
        }
        
        whiteContainer4.addSubview(benefit4Lbl)
        benefit4Lbl.snp.makeConstraints { (make) in
            make.right.equalTo(whiteContainer4.snp.right).offset(-5)
            make.centerY.equalTo(whiteContainer4.snp.centerY)
            make.left.equalTo(benefit4Icon.snp.right).offset(10)
            make.height.equalTo(self.whiteContainer4.snp.height).offset(-15)
        }

        self.scrollView.addSubview(whiteContainer5)
        whiteContainer5.snp.makeConstraints { (make) in
            make.width.equalTo(containerWidth)
            make.height.equalTo(containerHeight)
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(whiteContainer4.snp.bottom).offset(20)
        }
        

        benefit5Lbl.text = "A diet rich in fats is great for the health and vitality of the skin."
        
        whiteContainer5.addSubview(benefit5Icon)
        benefit5Icon.snp.makeConstraints { (make) in
            make.left.equalTo(whiteContainer5.snp.left).offset(10)
            make.centerY.equalTo(whiteContainer5.snp.centerY)
        }
        
        whiteContainer5.addSubview(benefit5Lbl)
        benefit5Lbl.snp.makeConstraints { (make) in
            make.right.equalTo(whiteContainer5.snp.right).offset(-5)
            make.centerY.equalTo(whiteContainer5.snp.centerY)
            make.left.equalTo(benefit5Icon.snp.right).offset(10)
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
            self.navigationController?.pushViewController(GettingStartedVC(), animated: true)
        }
    }

    @objc func backButtonSelected() {
        self.navigationController?.popViewController(animated: true)
       }
       
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    
}
