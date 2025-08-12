//
//  IngredientCollectionView.swift
//  The Keto Hack
//
//  Created by Laura Day on 20/11/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit


class IngredientCollectionView: UICollectionView {

    
    /*override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
       /* //WAY to hacky - have to do it per device
        print("point y: " + String(describing: point.y))
        if point.y > 10 && point.y < 105 {
            return self
        }*/
        
        print("hit test")
        print(event)
        print(point)
        return nil
    }
    
    override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        print(event)
        print(touches)
        return false
    }*/
}

