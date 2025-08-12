//
//  SearchRecipeCell.swift
//  The Keto Bible
//
//  Created by Laura Day on 25/10/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring
import SnapKit
import Kingfisher

class SearchRecipeCell : UICollectionViewCell {

    let recipeImageView = UIImageView()
    var selectedRecipe : RecipeItem!

    
    let titleLbl = VerticalAlignedLabel()
    let carbsCircleView = UIView()
    let carbsLbl = SpringLabel()

    let lockIcon = UIImageView(image: UIImage(named: "lockIcon"))


    override init(frame: CGRect) {
        super.init(frame: frame)

        
            self.addSubview(recipeImageView)
            recipeImageView.clipsToBounds = true
            recipeImageView.layer.cornerRadius = 20
            recipeImageView.contentMode = .scaleAspectFill
            recipeImageView.snp.makeConstraints{ (make) in
                make.edges.equalTo(self.snp.edges)
            }
            
            
            let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.35)
            overlay.layer.cornerRadius = 20
            recipeImageView.addSubview(overlay)
            
        
            titleLbl.textAlignment = .left
            titleLbl.adjustsFontSizeToFitWidth = true
            titleLbl.font = StyleManager.searchRecipeCellTitleFont
            titleLbl.contentMode = .bottom
            
            titleLbl.textColor = .white
            titleLbl.setLineHeight(lineHeight: 0.2)
            titleLbl.numberOfLines = 2
            titleLbl.lineBreakMode = .byTruncatingTail
            self.addSubview(titleLbl)
            titleLbl.snp.makeConstraints{ (make) in
                make.left.equalTo(self.snp.left).offset(15)
                make.right.equalTo(self.snp.right).offset(-25)
                make.bottom.equalTo(self.snp.bottom).offset(-5)
                make.height.equalTo(90)
            }
        
                self.addSubview(lockIcon)
               lockIcon.snp.makeConstraints{ (make) in
                   make.left.equalTo(self.snp.left).offset(15)
                   make.top.equalTo(self.snp.top).offset(15)
               }
            
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            
           
    func updateForRecipe(recipe: RecipeItem) {
        
        self.selectedRecipe = recipe
        
        if recipe.imageUrl != nil {
            recipeImageView.kf.setImage(with: recipe.imageUrl)
        }
        
        titleLbl.text = recipe.title

        if recipe.isPro != nil && recipe.isPro! && !UserManager.shared.getHasPro()  {
                   self.lockIcon.isHidden = false
               } else {
                   self.lockIcon.isHidden = true
               }
    }

   

}
