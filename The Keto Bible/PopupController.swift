//
//  PopupController.swift
//  The Keto Hack
//
//  Created by Laura Day on 14/4/20.
//  Copyright © 2020 Laura Day. All rights reserved.
//

import Foundation
import UIKit

class PopupController: NSObject {
    
    static func showPopup(_ popup: UIView) {
        
        let window: UIWindow? = (UIApplication.shared.windows[0])
        window?.addSubview(popup)
        
        popup.snp.makeConstraints{ (make) in
            make.edges.equalTo(window!)
        }
        
        popup.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            popup.alpha = 1
        })
    }
    
    static func showPopup(_ popup: UIView, inView: UIView?) {
        
        inView?.addSubview(popup)
        popup.snp.makeConstraints{ (make) in
            make.edges.equalTo(inView!)
        }
        
        popup.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            popup.alpha = 1
        })
    }
    
    static func closePopup(_ popup: UIView) {
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            popup.alpha = 0
        }, completion: {(_ finished: Bool) -> Void in
            popup.removeFromSuperview()
        })
        
    }
}
