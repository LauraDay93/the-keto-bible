//
//  OpeningAnimation.swift
//  The Keto Bible
//
//  Created by Laura Day on 11/2/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import Hero
import UIKit
import ViewAnimator

class OpeningAnimationViewController: UIViewController {

    let logoView = UIImageView(image: UIImage(named: "KTBFullLogo"))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        
        self.hero.isEnabled = true
        self.view.hero.id = "openingView"
        logoView.hero.isEnabled = true
        logoView.hero.id = "logoView"
        

        
        let scale = CGFloat(logoView.image!.size.height) / CGFloat(logoView.image!.size.width)
        
        
        
        self.view.addSubview(logoView)
        logoView.snp.makeConstraints{ (make) in
            make.centerY.equalTo(self.view.snp.centerY)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(5)
            make.height.equalTo(5*scale)
            
        }
        

        UIView.animate(withDuration: 2.0, animations: {() -> Void in
            self.logoView.transform = CGAffineTransform(scaleX: 60.5, y: 60.5)
        }, completion: {(_ finished: Bool) -> Void in
            UIView.animate(withDuration: 2.0, animations: {() -> Void in
                self.logoView.transform = CGAffineTransform(scaleX: 55.5, y: 55.5)
            }, completion: {(_ finished: Bool) -> Void in
                self.navigationController!.pushViewController(LoginViewController(), animated: true)

            })
        })
        
        
    }


}

