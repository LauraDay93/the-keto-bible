//
//  ContentType.swift
//  The Keto Bible
//
//  Created by Laura Day on 8/5/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit

enum ContentType: String, CustomStringConvertible {
    
    case home = "HomeIcon"
    
    func next() -> ContentType {
        switch self {
        case .home:
            return .home
        }
    }
    
    var image: UIImage {
        let image =  UIImage(named: rawValue)!
        return image
    }
    
    var description: String {
        switch self {
        case .home:
            return "All Recipes"
        }
    }
}
