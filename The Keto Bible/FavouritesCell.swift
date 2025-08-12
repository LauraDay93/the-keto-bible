//
//  FavouritesCell.swift
//  The Keto Bible
//
//  Created by Laura Day on 13/5/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring

class FavouritesCell : UICollectionViewCell {

    var currentRecipe : RecipeItem!
    let bgImage = UIImageView()
    let titleLbl = UILabel()
    let favBtn = SpringButton()


    override init(frame: CGRect) {
        super.init(frame: frame)
        

        
        bgImage.contentMode = .scaleAspectFill
        bgImage.clipsToBounds = true
        self.backgroundColor = .clear
        bgImage.layer.cornerRadius = 20
        self.addSubview(bgImage)
        bgImage.snp.makeConstraints{ (make) in
            make.left.equalTo(self.snp.left).offset(20)
            make.right.equalTo(self.snp.right).offset(-20)
            make.top.equalTo(self.snp.top)
            make.bottom.equalTo(self.snp.bottom)
        }
        
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.35)
        overlay.layer.cornerRadius = 20
        bgImage.addSubview(overlay)
        
        self.backgroundColor = .white
        
        titleLbl.textColor = .white
        titleLbl.font = StyleManager.favsTitleFont
        titleLbl.adjustsFontSizeToFitWidth = true
        
        self.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { (make) in
            make.bottom.equalTo(bgImage.snp.bottom).offset(-10)
            make.left.equalTo(bgImage.snp.left).offset(10)
            make.right.equalTo(bgImage.snp.right).offset(-10)
        }
        
        favBtn.setImage(UIImage(named: "fav_select"), for: .normal)
        favBtn.addTarget(self, action: #selector(favPressed), for: .touchUpInside)
        
        self.addSubview(favBtn)
        favBtn.snp.makeConstraints{ (make) in
            make.centerY.equalTo(bgImage.snp.top).offset(10)
            make.centerX.equalTo(bgImage.snp.right).offset(-10)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        
        
        
        
        
    }
    
    @objc func favPressed() {
        
        if self.favBtn.isSelected {
            self.favBtn.isSelected = false
            self.favBtn.setImage(UIImage(named: "fav_select"), for: .normal)
            DataManager.sharedInstance.addFavourite(fav: self.currentRecipe)
        } else {
            self.favBtn.isSelected = true
            self.favBtn.setImage(UIImage(named: "fav_unselect"), for: .normal)
            DataManager.sharedInstance.removeFavourite(favRemove: self.currentRecipe)
        }
    }
    
    func updateCellForItem(recipe : RecipeItem) {
        
        self.currentRecipe = recipe
        
        if currentRecipe.imageUrl != nil {
            bgImage.kf.setImage(with: currentRecipe.imageUrl)
        }
        
        self.titleLbl.text = currentRecipe.title

        
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
