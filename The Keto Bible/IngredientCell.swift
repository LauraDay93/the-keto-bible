//
//  IngredientCell.swift
//  The Keto Bible
//
//  Created by Laura Day on 5/4/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit

class IngredientCell : UICollectionViewCell {

    
    
    let ingredientImage = UIImageView()
    var currentIngredient : Ingredient!
    let titleLbl = UILabel()
    let lineUnder = UIView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        
        ingredientImage.contentMode = .scaleAspectFit
        ingredientImage.clipsToBounds = true
        self.backgroundColor = .white
        //ingredientImage.layer.cornerRadius = 20
        
        self.addSubview(ingredientImage)
        
        ingredientImage.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(self.snp.top)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        
        self.titleLbl.textAlignment = .center
        self.titleLbl.adjustsFontSizeToFitWidth = true
        self.titleLbl.font = StyleManager.ingredientsLblFont
        
        self.titleLbl.textColor = UIColor(red:0.23, green:0.23, blue:0.23, alpha:1.00)
        self.titleLbl.numberOfLines = 0
        self.titleLbl.allowsDefaultTighteningForTruncation = true
        titleLbl.lineBreakMode = .byWordWrapping
        self.addSubview(self.titleLbl)
        self.titleLbl.snp.makeConstraints{ (make) in
            make.width.equalTo(self.frame.size.width)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(ingredientImage.snp.bottom).offset(10)
            make.height.equalTo(35)
        }
        
        lineUnder.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
        self.addSubview(lineUnder)
        lineUnder.snp.makeConstraints { (make) in
            make.width.equalTo(self.snp.width)
            make.top.equalTo(titleLbl.snp.bottom).offset(20)
            make.height.equalTo(2)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateCellForItem(ingredient : Ingredient) {
        
        self.currentIngredient = ingredient
        
        if self.currentIngredient.imageUrl != nil {
            let url = URL(string: currentIngredient.imageUrl!)
            self.ingredientImage.kf.setImage(with: url)
        }
        
        self.titleLbl.text = currentIngredient.name

        
        
    }

    
    func setBottomLime(color: UIColor) {
        self.lineUnder.backgroundColor = color
    }
    
    func resetBottomLine() {
        lineUnder.backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.00)
    }

}
