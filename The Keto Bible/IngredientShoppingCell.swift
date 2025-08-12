//
//  IngredientShoppingCell.swift
//  The Keto Hack
//
//  Created by Laura Day on 17/6/20.
//  Copyright © 2020 Laura Day. All rights reserved.
//

import Foundation
import UIKit

class IngredientShoppingCell : UICollectionViewCell {

    
    
    let ingredientImage = UIImageView()
    var currentIngredient : Ingredient!
    let titleLbl = UILabel()

    let addBtn = UIButton()
    
    var recipe = String()
    var allIngred = [Ingredient]()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(shoppingUpdated), name: DataManager.listUpdated, object: nil)

        
        self.titleLbl.textAlignment = .center
        self.titleLbl.adjustsFontSizeToFitWidth = true
        self.titleLbl.font = StyleManager.ingredientsLblFont
        
        self.titleLbl.textColor = UIColor(red:0.23, green:0.23, blue:0.23, alpha:1.00)
        self.titleLbl.numberOfLines = 2
        //titleLbl.lineBreakMode = .byTruncatingTail
        self.addSubview(self.titleLbl)
        self.titleLbl.snp.makeConstraints{ (make) in
            make.width.equalTo(self.snp.width).offset(-15)
            make.centerX.equalTo(self.snp.centerX)
            make.top.equalTo(ingredientImage.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        self.addSubview(addBtn)
        addBtn.addTarget(self, action: #selector(ingredientAddPressed), for: .touchUpInside)
        

        
        
        addBtn.setImage(UIImage(named: "ingredientMinus"), for: .normal)
        addBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.ingredientImage.snp.top).offset(-3)
            make.left.equalTo(self.ingredientImage.snp.right)
        }

        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func ingredientAddPressed() {
        
        if addBtn.isSelected {
            DataManager.sharedInstance.markIngredientRemoved(title: self.recipe, ingredList: self.allIngred, ingredient: self.currentIngredient)
        } else {
            DataManager.sharedInstance.markIngredientAdded(title: self.recipe , ingredList: self.allIngred, ingredient: self.currentIngredient)
        }
        self.shoppingUpdated()
        
    }
    
    @objc func shoppingUpdated() {
       if self.currentIngredient == nil || self.currentIngredient.inGroceryList == nil || self.currentIngredient.inGroceryList! {
            addBtn.isSelected = false
            addBtn.setImage(UIImage(named: "ingredientMinus"), for: .normal)
        } else {
            addBtn.isSelected = true
            addBtn.setImage(UIImage(named: "ingredientAdded"), for: .normal)
        }
    }
    
    func updateCellForItem(ingredient : Ingredient, recipe: String, allIngredients: [Ingredient]) {
        
        self.recipe = recipe
        self.allIngred = allIngredients
        self.currentIngredient = ingredient
        
        if self.currentIngredient.imageUrl != nil {
            let url = URL(string: currentIngredient.imageUrl!)
            self.ingredientImage.kf.setImage(with: url)
        }
        
        self.titleLbl.text = currentIngredient.name
        self.shoppingUpdated()
     
        
    }


}
