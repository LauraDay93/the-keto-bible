//
//  FoodsToAvoidVC.swift
//  The Keto Bible
//
//  Created by Laura Day on 25/10/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring

class SuppsVC : UIViewController, UIScrollViewDelegate  {
    
    var titleLbl = UILabel()
    var backButton = SpringButton()
    var bgVC : UIImageView!
    var scrollView : UIScrollView!
    
    var headingBGView = UIView()
    
    var menuBtn = SpringButton()
    
    var showBackBtn : Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        navigationController?.interactivePopGestureRecognizer?.delegate = nil


        self.scrollView = UIScrollView()
        self.scrollView.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ (make) in
            make.edges.equalTo(self.view.snp.edges)
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 3000)
        scrollView.contentOffset.x = 0

        if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S || UIDevice().type == .iPhoneSE {
            self.bgVC = UIImageView(image: UIImage(named: "suppsScreen5"))
        } else if StyleManager.isIpad() {
            self.bgVC = UIImageView(image: UIImage(named: "suppsIpad"))
        } else {
            self.bgVC = UIImageView(image: UIImage(named: "suppsScreen"))
        }
        self.bgVC.contentMode = .scaleAspectFill
        self.bgVC.clipsToBounds = true
        self.scrollView.addSubview(bgVC)
        bgVC.snp.makeConstraints { (make) in
            if StyleManager.isIpad() {
                make.edges.equalTo(self.scrollView.snp.edges)
            } else {
                make.top.equalTo(self.scrollView.snp.top).offset(-75)
                make.bottom.equalTo(self.scrollView.snp.bottom).offset(40)
                make.left.equalTo(self.view.snp.left).offset(0)
                make.right.equalTo(self.view.snp.right).offset(0)
            }

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

        if showBackBtn {
            self.menuBtn.isHidden = true
        }
        
        
        let backIcon = UIImage(named: "BackButton")
        
        backButton.setImage(backIcon, for: .normal)
        
        
        self.scrollView.addSubview(backButton)
        self.backButton.snp.makeConstraints{ (make) in
            make.centerY.equalTo(self.titleLbl.snp.centerY)
            make.left.equalTo(self.scrollView.snp.left).offset(4)
        }
        backButton.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        if !showBackBtn {
            self.backButton.isHidden = true
        }

    }
    
    
    @objc func backBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func menuButtonSelected() {
        panel?.openLeft(animated: true)
    }
    

}
