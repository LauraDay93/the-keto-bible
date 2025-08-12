//
//  StyleManager.swift
//  The Keto Bible
//
//  Created by Laura Day on 4/2/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import Spring
import UIKit

class StyleManager : NSObject {

    static var mainTitleFont = UIFont(name: "Avenir-Book", size: 28)
    static var mainTitleFontBold = UIFont(name: "Avenir-Black", size: 28)
    static let ketoBundleID = "com.tkb.theketohack"
    static let veganBundleID = "com.Laura-Day.The-Vegan-Hack"

    static var featuresColor1 : UIColor {
        if self.isKeto {
            return UIColor(red:0.62, green:0.72, blue:1.00, alpha:1.0)
        } else {
            return UIColor(red:0.27, green:0.49, blue:0.00, alpha:1.0)

        }
    }
    
    static var featuresColor2 : UIColor {
        if self.isKeto {
            return UIColor(red:0.99, green:0.73, blue:0.47, alpha:1.0)
        } else {
            return UIColor(red:1.00, green:0.66, blue:0.22, alpha:1.0)
        }
    }

    static var featuresColor3 : UIColor {
        if self.isKeto {
            return UIColor(red:0.58, green:0.75, blue:0.67, alpha:1.0)
        } else {
            return UIColor(red:0.78, green:0.78, blue:0.21, alpha:1.0)
        }
    }
    
    static var featuresColor4 : UIColor {
        if self.isKeto {
            return UIColor(red:0.57, green:0.75, blue:0.76, alpha:1.0)
        } else {
            return UIColor(red:0.55, green:0.27, blue:0.07, alpha:1.0)

        }
    }

    static var featuresColor5 : UIColor {
        if self.isKeto {
            return     UIColor(red:0.58, green:0.75, blue:0.67, alpha:1.0)

        } else {
            return UIColor(red:0.61, green:0.15, blue:0.26, alpha:1.0)


        }
    }
    static var isKeto : Bool {
        return Bundle.main.bundleIdentifier == ketoBundleID
    }
    
    static var isVegan : Bool {
        return Bundle.main.bundleIdentifier == veganBundleID
    }
    
    static var titleString : String {
        
        if self.isKeto {
            return "THE KETO HACK"
        } else {
            return "THE VEGAN HACK"
        }
    }
    static var mainColor : UIColor {
        
        if self.isKeto {
            return UIColor.black
        } else {
            return UIColor(red:0.59, green:0.69, blue:0.15, alpha:1.0)


        }
    }
    
    static var buttonFont : UIFont {
        if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE{
            return UIFont(name: "Avenir-Book", size: 16)!
        } else {
            return UIFont(name: "Avenir-Book", size: 19)!
        }
    }
    
    static var menuNameFont = UIFont(name: "Avenir-Heavy", size: 16)
    

    
    static var buttonFontBold : UIFont {
        if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
            return UIFont(name: "Avenir-Black", size: 20)!
        } else {
            return UIFont(name: "Avenir-Black", size: 22)!
        }
        
    }
    
    static var menuFontSel = UIFont(name: "Avenir-Heavy", size: 18)
    static var menuFontUnsel = UIFont(name: "Avenir-Heavy", size: 13)
    
    static var savingsFont = UIFont(name: "Avenir-Book", size: 13)
    static var savingsFontBold = UIFont(name: "Avenir-Black", size: 13)

    static var noResultsFont = UIFont(name: "Avenir-Book", size: 27)
    static var noResultsFontBold = UIFont(name: "Avenir-Black", size: 27)

    
    static var textFieldFont : UIFont {
        if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
            return UIFont(name: "Avenir-Book", size: 12)!
        } else {
            return UIFont(name: "Avenir-Book", size: 14)!
        }
    }
    
    
    static var btnFont = UIFont(name: "Avenir-Medium", size: 14)
    static var signUpColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0)


    static var btnHeight = 43
    static var cornerRadius : CGFloat = 20
    static var popTime : CGFloat = 0.7
    
    static var smallBtnHeight = 38

    
    static var topTitleFont = UIFont(name: "Avenir-Book", size: 22)
    static var topTitleFontBold = UIFont(name: "Avenir-Black", size: 22)

    static var categoryFont = UIFont(name: "Avenir-Light", size: 14)
    
    static var likesFont = UIFont(name: "Avenir-Medium", size: 18)
    static var carbsCellLbl = UIFont(name: "Avenir-Heavy", size: 15)

    static var filtersBtnFont = UIFont(name: "Avenir-Heavy", size: 13)
    
    
    static var categoryLblFont : UIFont {
        switch UIDevice().type {
        case .iPhone5, .iPhone5S, .iPhone5C, .iPhoneSE:
            return UIFont(name: "Avenir-Black", size: 17)!
        default:
            return UIFont(name: "Avenir-Black", size: 20)!
        }
    }

    static var tipsHeadingFont : UIFont {
        
        if StyleManager.isIpad() {
            return UIFont(name: "Avenir-Heavy", size: 30)!
        }
        
        switch UIDevice().type {
        case .iPhone5, .iPhone5S, .iPhone5C, .iPhoneSE:
            return UIFont(name: "Avenir-Heavy", size: 20)!
        default:
            return UIFont(name: "Avenir-Heavy", size: 24)!
        }
    }
    
    static var tipsDescFont : UIFont {
        
        if StyleManager.isIpad() {
                   return UIFont(name: "Avenir-Medium", size: 22)!
               }
           switch UIDevice().type {
           case .iPhone6Plus, .iPhone7Plus, .iPhone8Plus, .iPhone6SPlus, .iPhoneXSMax , .iPhoneXR, .iPhone11ProMax, .iPhone11, .iPhone12ProMax:
               return UIFont(name: "Avenir-Medium", size: 17)!
           case .iPhone5, .iPhone5S, .iPhone5C, .iPhoneSE:
            return UIFont(name: "Avenir-Medium", size: 14)!
           default:
               return UIFont(name: "Avenir-Medium", size: 16)!
           }
       }
    
    static var carbsParagraphFont : UIFont {
        if StyleManager.isIpad() {
            return UIFont(name: "Avenir-Medium", size: 19)!

        } else {
            return UIFont(name: "Avenir-Medium", size: 16)!
        }
    }
    
    static var carbsBoldFont : UIFont {
        if StyleManager.isIpad() {
            return UIFont(name: "Avenir-Heavy", size: 19)!
        } else {
            return UIFont(name: "Avenir-Heavy", size: 16)!
        }
    }
    
    static var recipeViewTitleFont : UIFont {
        switch UIDevice().type {
        case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE:
            return UIFont(name: "Avenir-Black", size: 30)!
        default:
            return UIFont(name: "Avenir-Black", size: 39)!
        }
    }
    
    static var topOffset : Int {
        switch UIDevice().type {
        case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE:
            return 45
        default:
            return 60
        }
    }
    
    static var recipeCellTitleFont : UIFont {
        
        switch UIDevice().type {
        case .iPhone8, .iPhone7, .iPhone6S, .iPhone6, .iPhoneSE:
            return UIFont(name: "Avenir-Black", size: 32)!
        case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE:
            return UIFont(name: "Avenir-Black", size: 24)!
        default:
            return UIFont(name: "Avenir-Black", size: 39)!
        }
    }
    
    static var searchRecipeCellTitleFont : UIFont {
        
        if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhoneSE {
            return UIFont(name: "Avenir-Black", size: 11)!
        } else if StyleManager.isIpad() {
            return UIFont(name: "Avenir-Black", size: 21)!
        } else {
            return UIFont(name: "Avenir-Black", size: 16)!
        }
    }
    
    static var signUpFont : UIFont {
        if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
            return UIFont(name: "Avenir-Book", size: 12)!
        } else {
            return UIFont(name: "Avenir-Book", size: 15)!
        }
    }

    
    static var filtersTitle : UIFont {
        if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
            return UIFont(name: "Avenir-Book", size: 16)!
        }
        
        return UIFont(name: "Avenir-Book", size: 19)!
    }
    
    static var filtersTitleBold : UIFont {
        if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
            return UIFont(name: "Avenir-Black", size: 16)!
        }
        
        return UIFont(name: "Avenir-Black", size: 19)!
    }
    
    static var searchResetFont = UIFont(name: "Avenir-Heavy", size: 15)
    static var filterSubtitleFont = UIFont(name: "Avenir-Light", size: 15)
    static var filterBtnFont = UIFont(name: "Avenir-Light", size: 12)

    static var carbsAmtLblFont : UIFont {
        if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
            return UIFont(name: "Avenir-Light", size: 19)!
        }
        return UIFont(name: "Avenir-Light", size: 28)!
    }

    static var recipeTitle = UIFont(name: "Avenir-Black", size: 40)
    static var cookingLblsFont = UIFont(name: "Avenir-Medium", size: 14)
    static var ingredLblFont = UIFont(name: "Avenir-Black", size: 32)
    
    static var ingredientsLblFont = UIFont(name: "Avenir-Medium", size: 12)

    static var nutrientLblFont = UIFont(name: "Avenir-Light", size: 18)
    
    static var favsTitleFont = UIFont(name: "Avenir-Black", size: 25)

    
    static var settingsBtnTitleFont = UIFont(name: "Avenir-Heavy", size: 14)
    static var settingsBtnDescFont = UIFont(name: "Avenir-Medium", size: 14)

    static var featuresTitleFont : UIFont {
     
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5S, .iPhone5C, .iPhone5, .iPhoneSE:
                return UIFont(name: "Avenir-Heavy", size: 18)!
            default: return UIFont(name: "Avenir-Heavy", size: 24)!
        }
        
    }
    static var featuresDescFont : UIFont {
        switch UIDevice().type {
        case .iPhoneSE, .iPhone5S, .iPhone5C, .iPhone5, .iPhoneSE:
            return UIFont(name: "Avenir-Book", size: 18)!
        default: return UIFont(name: "Avenir-Book", size: 24)!
            
        }        
    }

    static func popView(view: Springable) {
        view.force = 0.4
        view.duration = self.popTime
        view.animation = "pop"
        view.animate()
    }
    
    static func popViewSubtle(view: Springable) {
        view.force = 0.15
        view.duration = self.popTime
        view.animation = "pop"
        view.animate()
    }
    
    static func isPlusDevice() -> Bool {
        
        if UIDevice().type == .iPhone6Plus || UIDevice().type == .iPhone6SPlus || UIDevice().type == .iPhone7Plus || UIDevice().type == .iPhone8Plus || UIDevice().type == .iPhoneXSMax {
            return true
        } else {
            return false
        }
    }
    
    static func isIpad() -> Bool {
        if UIDevice().type == .iPad5 || UIDevice().type == .iPad6 || UIDevice().type == .iPadAir3 || UIDevice().type == .iPadAir2 || UIDevice().type == .iPadAir ||  UIDevice().type == .iPad4 || UIDevice().type == .iPad3 || UIDevice().type == .iPad2 || UIDevice().type == .iPadMini || UIDevice().type == .iPadMini2 || UIDevice().type == .iPadMini3 || UIDevice().type == .iPadMini4 || UIDevice().type == .iPadMini5 || UIDevice().type == .iPadPro9_7 || UIDevice().type == .iPadPro11 || UIDevice().type == .iPadPro10_5 || UIDevice().type == .iPadPro12_9 || UIDevice().type == .iPadPro2_12_9 || UIDevice().type == .iPadPro3_12_9 || UIDevice().type == .iPadPro4thGen ||  UIDevice().type == .iPadPro4thGen2  {
            return true
        } else {
            return false
        }
    }
    

}


extension SpringButton {
    func pop(completion: (() -> Void)?) {
        StyleManager.popView(view: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double((StyleManager.popTime - 0.2))) {
            completion?()
        }
        
    }
}

extension SpringView {
    func pop(completion: (() -> Void)?) {
        StyleManager.popViewSubtle(view: self)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double((StyleManager.popTime - 0.2))) {
            completion?()
        }
        
    }
}


extension UITextField {
    func setIcon(_ image: UIImage) {
        
        let ratio = image.size.width / image.size.height
        
        let imgHeight : CGFloat = 20
        let imgWidth = imgHeight * ratio
        
        
        let iconView = UIImageView(frame:
            CGRect(x: 20, y: 5, width: imgWidth, height: imgHeight))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 0, y: 0, width: 50, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}


// 1. Declare outside class definition (or in its own file).
// 2. UIKit must be included in file where this code is added.
// 3. Extends UIDevice class, thus is available anywhere in app.
//
// Usage example:
//
//    if UIDevice().type == .simulator {
//       print("You're running on the simulator... boring!")
//    } else {
//       print("Wow! Running on a \(UIDevice().type.rawValue)")
//    }
import UIKit

public enum Model : String {
    
    //Simulator
    case simulator     = "simulator/sandbox",
    
    //iPod
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    
    //iPad
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPadAir            = "iPad Air ",
    iPadAir2           = "iPad Air 2",
    iPadAir3           = "iPad Air 3",
    iPad5              = "iPad 5", //iPad 2017
    iPad6              = "iPad 6", //iPad 2018
    
    //iPad Mini
    iPadMini           = "iPad Mini",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadMini4          = "iPad Mini 4",
    iPadMini5          = "iPad Mini 5",
    
    //iPad Pro
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro10_5        = "iPad Pro 10.5\"",
    iPadPro11          = "iPad Pro 11\"",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    iPadPro3_12_9      = "iPad Pro 3 12.9\"",
    iPadPro4thGen         = "iPad Pro 4 12.9\"",
    iPadPro4thGen2        = "iPad Pro 4 12.92\"",
    
    
    //iPhone
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPhone6            = "iPhone 6",
    iPhone6Plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6SPlus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7Plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8Plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhoneXR           = "iPhone XR",
    iPhone11           = "iPhone12,1",
    iPhone11Pro        = "iPhone12,3",
    iPhone11ProMax     = "iPhone12,5",
    iPhone12mini       = "iPhone13,1",
    iPhone12           = "iPhone13,2",
    iPhone12Pro        = "iPhone13,3",
    iPhone12ProMax     = "iPhone13,4",

    //Apple TV
    AppleTV            = "Apple TV",
    AppleTV_4K         = "Apple TV 4K",
    unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#

public extension UIDevice {
    
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        
        
        var modelMap : [String: Model] = [
            
            //Simulator
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            
            //iPod
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            
            //iPad
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPad4,1"   : .iPadAir,
            "iPad4,2"   : .iPadAir,
            "iPad4,3"   : .iPadAir,
            "iPad5,3"   : .iPadAir2,
            "iPad5,4"   : .iPadAir2,
            "iPad6,11"  : .iPad5, //iPad 2017
            "iPad6,12"  : .iPad5,
            "iPad7,5"   : .iPad6, //iPad 2018
            "iPad7,6"   : .iPad6,
            
            //iPad Mini
            "iPad2,5"   : .iPadMini,
            "iPad2,6"   : .iPadMini,
            "iPad2,7"   : .iPadMini,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad5,1"   : .iPadMini4,
            "iPad5,2"   : .iPadMini4,
            "iPad11,1"  : .iPadMini5,
            "iPad11,2"  : .iPadMini5,
            
            //iPad Pro
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7,
            "iPad7,3"   : .iPadPro10_5,
            "iPad7,4"   : .iPadPro10_5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9,
            "iPad8,1"   : .iPadPro11,
            "iPad8,2"   : .iPadPro11,
            "iPad8,3"   : .iPadPro11,
            "iPad8,4"   : .iPadPro11,
            "iPad8,5"   : .iPadPro3_12_9,
            "iPad8,6"   : .iPadPro3_12_9,
            "iPad8,7"   : .iPadPro3_12_9,
            "iPad8,8"   : .iPadPro3_12_9,
            "iPad8,11"  : .iPadPro4thGen,
            "iPad8,12"  : .iPadPro4thGen2,
        
            
            //iPad Air
            "iPad11,3"  : .iPadAir3,
            "iPad11,4"  : .iPadAir3,
            
            //iPhone
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPhone7,1" : .iPhone6Plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6SPlus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,3" : .iPhone7,
            "iPhone9,2" : .iPhone7Plus,
            "iPhone9,4" : .iPhone7Plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,4" : .iPhone8,
            "iPhone10,2" : .iPhone8Plus,
            "iPhone10,5" : .iPhone8Plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,6" : .iPhoneX,
            "iPhone11,2" : .iPhoneXS,
            "iPhone11,4" : .iPhoneXSMax,
            "iPhone11,6" : .iPhoneXSMax,
            "iPhone11,8" : .iPhoneXR,
            "iPhone12,1" : .iPhone11,
            "iPhone12,3" : .iPhone11Pro,
            "iPhone12,5" : .iPhone11ProMax,
            "iPhone13,1":  .iPhone12mini,
            "iPhone13,2":  .iPhone12,
            "iPhone13,3":  .iPhone12Pro,
            "iPhone13,4":  .iPhone12ProMax,
            //Apple TV
            "AppleTV5,3" : .AppleTV,
            "AppleTV6,2" : .AppleTV_4K
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}

public protocol ChangableFont: AnyObject {
    var text: String? { get set }
    var attributedText: NSAttributedString? { get set }
    var rangedAttributes: [RangedAttributes] { get }
    func getFont() -> UIFont?
    func changeFont(ofText text: String, with font: UIFont)
    func changeFont(inRange range: NSRange, with font: UIFont)
    func changeTextColor(ofText text: String, with color: UIColor)
    func changeTextColor(inRange range: NSRange, with color: UIColor)
    func resetFontChanges()
}


public struct RangedAttributes {
    
    let attributes: [NSAttributedString.Key: Any]
    let range: NSRange
    
    public init(_ attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
        self.attributes = attributes
        self.range = range
    }
}

extension UILabel: ChangableFont {
    
    public func getFont() -> UIFont? {
        return font
    }
}

extension UITextField: ChangableFont {
    
    public func getFont() -> UIFont? {
        return font
    }
}

public extension ChangableFont {
    
    public var rangedAttributes: [RangedAttributes] {
        guard let attributedText = attributedText else {
            return []
        }
        var rangedAttributes: [RangedAttributes] = []
        let fullRange = NSRange(
            location: 0,
            length: attributedText.string.count
        )
        attributedText.enumerateAttributes(
            in: fullRange,
            options: []
        ) { (attributes, range, stop) in
            guard range != fullRange, !attributes.isEmpty else { return }
            rangedAttributes.append(RangedAttributes(attributes, inRange: range))
        }
        return rangedAttributes
    }
    
    public func changeFont(ofText text: String, with font: UIFont) {
        guard let range = (self.attributedText?.string ?? self.text)?.range(ofText: text) else { return }
        changeFont(inRange: range, with: font)
    }
    
    public func changeFont(inRange range: NSRange, with font: UIFont) {
        add(attributes: [.font: font], inRange: range)
    }
    
    func changeTextColor(ofText text: String, with color: UIColor) {
        guard let range = (self.attributedText?.string ?? self.text)?.range(ofText: text) else { return }
        changeTextColor(inRange: range, with: color)
    }
    
    func changeTextColor(inRange range: NSRange, with color: UIColor) {
        add(attributes: [.foregroundColor: color], inRange: range)
    }
    
    private func add(attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
        guard !attributes.isEmpty else { return }
        
        var rangedAttributes: [RangedAttributes] = self.rangedAttributes
        
        var attributedString: NSMutableAttributedString
        
        if let attributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        } else if let text = text {
            attributedString = NSMutableAttributedString(string: text)
        } else {
            return
        }
        
        rangedAttributes.append(RangedAttributes(attributes, inRange: range))
        
        rangedAttributes.forEach { (rangedAttributes) in
            attributedString.addAttributes(
                rangedAttributes.attributes,
                range: rangedAttributes.range
            )
        }
        
        attributedText = attributedString
    }
    
    func resetFontChanges() {
        guard let text = text else { return }
        attributedText = NSMutableAttributedString(string: text)
    }
}

public extension String {
    
    public func range(ofText text: String) -> NSRange {
        let fullText = self
        let range = (fullText as NSString).range(of: text)
        return range
    }
}

