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
import SnapKit

class AthleticVC : UIViewController, UIScrollViewDelegate  {
    
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
        
        self.bgVC = UIImageView(image: UIImage(named: "athleticBG"))
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
        if UIDevice.current.type == .iPhone6 || UIDevice.current.type == .iPhone6S || UIDevice.current.type == .iPhone7 || UIDevice.current.type == .iPhone8 || UIDevice.current.type == .iPhone6Plus || UIDevice.current.type == .iPhone6SPlus || UIDevice.current.type == .iPhone7Plus || UIDevice.current.type == .iPhone8Plus || UIDevice.current.type == .iPhone12ProMax {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 110, right: 0)
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        }
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scrollView.contentOffset.x = 0



        titleLbl.text = "Athletic Performance"
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
        

        
        let stringTxt = "Traditionally, carbohydrates have been deemed superior for athletic performance from both an aesthetic and sport specific perspective. This comes from the ability of the human microbiome to utilise carbohydrates from the diet and form glycogen stores to quickly fuel muscle contraction and initiate movement. Bodybuilders generally use carbohydrates to fuel muscle building as carbohydrates also bind water within the muscle and make muscle bellies appear fuller. When the body then becomes fat-adapted, as is seen when in ketosis, the body would then start to burn fat at a high proportion to carbohydrate as it is becomes better at breaking down stored fat and mobilising fat from the metabolism. In the initial stages of switching to a ketogenic diet, some people report increased muscle soreness and potentially some decrements in performance. However, after the first few weeks eating in a ketogenic way, most people have regained full strength potential and often report less fatigue after a work out. Athletic performance trials have repeatedly tested this theory and have proven that aerobic performance, cardiovascular performance, and strength were not compromised by eating a keto diet. In some studies it was shown that athletes were able to perform to the best of their abilities and continue to make gains in all areas after switching to the keto diet.  People who respond well to the Keto diet also don’t lose lean muscle gains or ability to build muscle, despite the lack of carbohydrates. The Keto diet provides ample protein for muscle fibre synthesis and the fat-adaption process means that the body is more efficient at burning stored fat, promoting weight-loss and improved body composition. "
        
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
            make.bottom.equalTo(self.scrollView.snp.bottom)
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
    
    @objc func nextBtnPressed() {
        self.nxtBtn.pop {
            self.navigationController?.pushViewController(ExerciseVC(), animated: true)
        }
    }
    

    @objc func backButtonSelected() {
        self.navigationController?.popViewController(animated: true)
    }
       
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    
}
