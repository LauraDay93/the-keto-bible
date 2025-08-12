//
//  ShoppingListRecipeView.swift
//  The Keto Hack
//
//  Created by Laura Day on 17/6/20.
//  Copyright © 2020 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import SnapKit


class ShoppingListRecipeCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {


    var ingredCollectionView : IngredientCollectionView!
    var ingredLayout : UICollectionViewFlowLayout!
    

    var recipeTitle : String!
    var ingredients : [Ingredient]!
    
    let title = UILabel()

    let recipeBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title.textColor = .black
        title.font = UIFont(name: "Avenir-Medium", size: 19)
        
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left).offset(25)
            make.top.equalTo(self.snp.top).offset(20)
        }
        
        
        
        self.recipeBtn.addTarget(self, action: #selector(recipeBtnPressed), for: .touchUpInside)
        self.recipeBtn.setImage(UIImage(named: "recipeMinus"), for: .normal)
        
        self.addSubview(recipeBtn)
        recipeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.title.snp.left).offset(-5)
            make.centerY.equalTo(self.title.snp.centerY)
        }
                
        self.ingredLayout = UICollectionViewFlowLayout()
        self.ingredLayout.scrollDirection = .horizontal
        self.ingredCollectionView = IngredientCollectionView(frame: .zero, collectionViewLayout: self.ingredLayout)
        self.ingredCollectionView.dataSource = self
        self.ingredCollectionView.delegate = self
        self.ingredCollectionView.register(IngredientShoppingCell.self, forCellWithReuseIdentifier: "IngredCell")

                      
        //self.ingredCollectionView.backgroundColor = .white
        self.ingredLayout.minimumInteritemSpacing = 0
        self.ingredLayout.minimumLineSpacing = 0
        self.ingredCollectionView.showsVerticalScrollIndicator = false
        self.ingredCollectionView.showsHorizontalScrollIndicator = false
                        
        ingredCollectionView.backgroundColor = .white
        self.addSubview(ingredCollectionView)
        ingredCollectionView.snp.makeConstraints{ (make) in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.left.equalTo(contentView.snp.left)
            make.width.equalTo(contentView.snp.width)
            make.height.equalTo(120)
        }
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 120, height: 115)
    }
    
    @objc func recipeBtnPressed() {
        DataManager.sharedInstance.removeGroceryListItem(listRemove: recipeTitle)
        ingredCollectionView.reloadData()
    }
     
    
    func updateForRecipe(recipeTitle: String, ingredients: [Ingredient]) {
        self.recipeTitle = recipeTitle
        self.ingredients = ingredients
        title.text = recipeTitle
        self.ingredCollectionView.reloadData()

        
    }
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.ingredients != nil {
            return self.ingredients.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let ingredientsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredCell", for: indexPath) as! IngredientShoppingCell
                if self.ingredients.count > 0 {
                    ingredientsCell.updateCellForItem(ingredient:  self.ingredients[indexPath.row], recipe: recipeTitle, allIngredients: self.ingredients)
                }
        return ingredientsCell
    }
    
    
    

}
