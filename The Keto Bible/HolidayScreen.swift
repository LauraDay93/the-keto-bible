//
//  EatingOutVC.swift
//  The Keto Bible
//
//  Created by Laura Day on 31/10/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring

class HolidayScreenVC: UIViewController, UIScrollViewDelegate  {
    
    var titleLbl = UILabel()
    var backButton = SpringButton()
    var bgVC : UIImageView!
    var scrollView : UIScrollView!
    
    var headingBGView = UIView()
    
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
        

        if StyleManager.isIpad() {
            self.bgVC = UIImageView(image: UIImage(named: "holidaysScreenIpad"))
        } else if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S || UIDevice().type == .iPhoneSE {
            self.bgVC = UIImageView(image: UIImage(named: "holidaysScreen5"))
        } else if StyleManager.isPlusDevice() || UIDevice().type == .iPhoneXR || UIDevice().type == .iPhone11ProMax || UIDevice().type == .iPhone11 || UIDevice().type == .iPhone12ProMax || UIDevice().type == .iPhone12 {
            self.bgVC = UIImageView(image: UIImage(named: "holidaysScreenPlus"))
        } else {
            self.bgVC = UIImageView(image: UIImage(named: "holidaysScreen"))
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.bgVC.image!.size.height)

        
        self.bgVC.contentMode = .scaleAspectFill
        self.bgVC.clipsToBounds = true
        self.scrollView.addSubview(bgVC)
        bgVC.snp.makeConstraints { (make) in
            make.top.equalTo(self.scrollView.snp.top).offset(-45)
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.scrollView.snp.bottom).offset(40)
            make.width.equalTo(self.view.snp.width)
        }
        
        self.scrollView.isScrollEnabled = true
        
        
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
        
        
        let backIcon = UIImage(named: "BackButton")
        
        backButton.setImage(backIcon, for: .normal)
        
        
        self.scrollView.addSubview(backButton)
        self.backButton.snp.makeConstraints{ (make) in
            make.centerY.equalTo(self.titleLbl.snp.centerY)
            make.left.equalTo(self.scrollView.snp.left).offset(4)
        }
        backButton.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

    }
    
    
    @objc func backBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }


}
