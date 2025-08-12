//
//  RecipeCell.swift
//  The Keto Bible
//
//  Created by Laura Day on 16/10/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring

class RecipeCell : UICollectionViewCell {

    let bgImage = UIImageView()
    var selectedRecipe : RecipeItem!

    
    let titleLbl = VerticalAlignedLabel()
    let carbsCircleView = UIView()
    let carbsLbl = SpringLabel()

    let lockIcon = UIImageView(image: UIImage(named: "lockIcon"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        

            
            
            bgImage.contentMode = .scaleAspectFill
            bgImage.clipsToBounds = true
            self.backgroundColor = .clear
            bgImage.layer.cornerRadius = 20
            self.addSubview(bgImage)
            bgImage.snp.makeConstraints{ (make) in
                make.edges.equalTo(self.snp.edges)
            }
            
            let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.15)
            overlay.layer.cornerRadius = 20
            bgImage.addSubview(overlay)
            
        
            carbsCircleView.backgroundColor = .white
            let width : CGFloat = 25.0
            carbsCircleView.layer.cornerRadius = width / 2
            
            self.addSubview(carbsCircleView)
            carbsCircleView.snp.makeConstraints{ (make) in
                make.right.equalTo(self.snp.right).offset(-15)
                make.top.equalTo(self.snp.top).offset(15)
                make.width.equalTo(width)
                make.height.equalTo(width)
            }
            
            carbsLbl.textColor = .black
            carbsLbl.font = StyleManager.carbsCellLbl
            carbsCircleView.addSubview(carbsLbl)
            carbsLbl.snp.makeConstraints{ (make) in
                make.centerY.equalTo(carbsCircleView.snp.centerY)
                make.centerX.equalTo(carbsCircleView.snp.centerX)
            }
            
            
            titleLbl.textAlignment = .left
            titleLbl.adjustsFontSizeToFitWidth = true
            titleLbl.font = StyleManager.recipeCellTitleFont
            titleLbl.contentMode = .bottom

            titleLbl.textColor = .white
            titleLbl.numberOfLines = 2
            titleLbl.lineBreakMode = .byTruncatingTail
            self.addSubview(titleLbl)
            titleLbl.snp.makeConstraints{ (make) in
                make.left.equalTo(self.snp.left).offset(15)
                make.width.equalTo(self.contentView.snp.width).offset(-30)
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
        
        if selectedRecipe.imageUrl != nil {
            bgImage.kf.setImage(with: selectedRecipe.imageUrl)
        }
        carbsLbl.text = String(describing: Int(selectedRecipe.nutritional.netCarbs))
        titleLbl.text = selectedRecipe.title
        titleLbl.setLineHeight(lineHeight: 0.2)
        titleLbl.adjustsFontSizeToFitWidth = true
        titleLbl.numberOfLines = 2
        titleLbl.lineBreakMode = .byTruncatingTail
        
        if recipe.isPro != nil && recipe.isPro! && !UserManager.shared.getHasPro()  {
            self.lockIcon.isHidden = false
        } else {
            self.lockIcon.isHidden = true
        }
    }


}
