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

class TipsVC : UIViewController, UIScrollViewDelegate  {
    
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

        self.bgVC = UIImageView(image: UIImage(named: "tipsBG"))
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

        var yellowBGWidth = 360
        if UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5 {
            yellowBGWidth = 260
        }
        
        self.headingBGView.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.32, alpha:0.6)
               self.scrollView.addSubview(headingBGView)
               self.headingBGView.snp.makeConstraints { (make) in
                   make.top.equalTo(self.titleLbl.snp.bottom).offset(30)
                   make.left.equalTo(self.scrollView.snp.left)
                   make.width.equalTo(yellowBGWidth)
                   make.height.equalTo(57)
               }
               
        let topTitle = UILabel()
        topTitle.adjustsFontSizeToFitWidth = true
        topTitle.numberOfLines = 1
        topTitle.text = "What is the Ketogenic Diet?"
        topTitle.textAlignment = .center
        topTitle.textColor = .black
        topTitle.font = StyleManager.tipsHeadingFont
        self.headingBGView.addSubview(topTitle)
        topTitle.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.headingBGView.snp.centerY)
            make.left.equalTo(self.headingBGView.snp.left).offset(10)
            make.right.equalTo(self.headingBGView.snp.right).offset(-10)
        }
        
        
        let whiteBG1 = UIImageView(image: UIImage(named: "whiteBG"))
        self.scrollView.addSubview(whiteBG1)
        whiteBG1.snp.makeConstraints { (make) in
            make.top.equalTo(self.headingBGView.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.left).offset(-15)
            make.right.equalTo(self.view.snp.right).offset(10)

        }
        
        
        let descriptionLbl = UILabel()
        descriptionLbl.textColor = .black
        descriptionLbl.numberOfLines = 0
        descriptionLbl.font = StyleManager.tipsDescFont
        descriptionLbl.textAlignment = .left
        descriptionLbl.text = "Our bodies are fuelled primary by glucose (or blood sugar). We usually get glucose from carbohydrates, like bread and fruit. If our glucose levels drop really low, one could actually even pass out. If our glucose levels drop, our body finds other sources for energy, and one of these processes is called ketogenesis. Our liver starts to break down fat into an energy source we can use, called ketones. So simply, once we lower our carb intake to extremely low levels, our bodies enter ketogenesis. Once we’ve gotten into ketogenesis and our ketone levels are high, our body is in “ketosis”, in which are body starts to use fat for energy, in turn burning stored fat. You can get into ketosis by either fasting or keeping your carb intake to less than 20grams per day. When following a traditional keto diet, you should try and get 5% of your calories from carbs, 20% from protein, and 75% from fat. However, there are 3 other forms of the keto diet that individuals follow. The Cyclical Keto Diet involves high carb refeeds (like 5 low carb days and 2 high), the Targeted Keto Diet involves adding carbs around workouts, and the High-protein Keto Diet which involves 60% fat, 35% protein, and 5% carbs."
        
        self.scrollView.addSubview(descriptionLbl)
        descriptionLbl.snp.makeConstraints { (make) in
            if StyleManager.isIpad() {
                make.top.equalTo(whiteBG1.snp.top).offset(45)

            } else {
                make.top.equalTo(whiteBG1.snp.top).offset(35)

            }
            make.left.equalTo(whiteBG1.snp.left).offset(33)
            make.right.equalTo(whiteBG1.snp.right).offset(-22)
        }

        
        let headingBGView2 = UIView()
        headingBGView2.backgroundColor = UIColor(red:1.00, green:0.98, blue:0.32, alpha:0.6)
        self.scrollView.addSubview(headingBGView2)
        headingBGView2.snp.makeConstraints { (make) in
            make.top.equalTo(whiteBG1.snp.bottom).offset(23)
            make.right.equalTo(self.view.snp.right)
            make.width.equalTo(yellowBGWidth)
            make.height.equalTo(57)
        }
        
        let topTitle2 = UILabel()
        topTitle2.adjustsFontSizeToFitWidth = true
        topTitle2.numberOfLines = 1
        topTitle2.text = "How do I enter Ketosis?"
        topTitle2.textAlignment = .center
        topTitle2.textColor = .black
        topTitle2.font = StyleManager.tipsHeadingFont
        headingBGView2.addSubview(topTitle2)
        topTitle2.snp.makeConstraints { (make) in
            make.centerY.equalTo(headingBGView2.snp.centerY)
            make.left.equalTo(headingBGView2.snp.left).offset(10)
            make.right.equalTo(headingBGView2.snp.right).offset(-10)
        }

        let whiteBG2 = UIImageView(image: UIImage(named: "whiteBG2"))
        self.scrollView.addSubview(whiteBG2)
        whiteBG2.snp.makeConstraints { (make) in
            make.top.equalTo(headingBGView2.snp.bottom).offset(20)
            make.left.equalTo(self.view.snp.left).offset(-15)
            make.right.equalTo(self.view.snp.right).offset(10)
        }
        
        let descriptionLbl2 = UILabel()
        descriptionLbl2.textColor = .black
        descriptionLbl2.numberOfLines = 0
        descriptionLbl2.font = StyleManager.tipsDescFont
        descriptionLbl2.textAlignment = .left
        descriptionLbl2.text = "As mentioned above, when our bodies are in a state of prolonged fasting, there are 2 hormones present; insulin and glucagon. When we deprive our body of food and energy, our insulin levels drop dramatically, and our glucagon levels rise. This is how ketones are produced. As soon as we introduce carbs, our insulin levels rise, which is why the keto diet is extremely low carb. \n\n When we don’t have any food, first our body feeds off any glucose from previously ingested food, and then it starts to feed off our liver glycogen stores. Once our liver glycogen stores are empty, that’s when the body starts to convert amino acids into glucose. Without getting too technical, this is when our glucose starts to go to our brain (helping increase brain function), and our body frees fatty acids from our fat stores. \n\n The longer you can sustain ketosis, the more adapted your body becomes, and you become less reliant on glucose.  Our bodies adapt and as fatty acids and ketones become our bodies main fuel source, it also helps prevent any further breakdown of muscle tissue or lean muscle mass."
               
        self.scrollView.addSubview(descriptionLbl2)
        descriptionLbl2.snp.makeConstraints { (make) in
            if StyleManager.isIpad() {
                make.top.equalTo(whiteBG2.snp.top).offset(45)

            } else {
                make.top.equalTo(whiteBG2.snp.top).offset(35)

            }
            make.left.equalTo(whiteBG2.snp.left).offset(33)
            make.right.equalTo(whiteBG2.snp.right).offset(-25)
        }
        
        
    }

    @objc func menuButtonSelected() {
           panel?.openLeft(animated: true)
       }
       
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    
}
