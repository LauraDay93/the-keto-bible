//
//  ShoppingListVC.swift
//  
//
//  Created by Laura Day on 14/6/20.
//

import Foundation
import UIKit
import Spring

class ShoppingListVC : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var titleLbl = UILabel()

    var menuBtn = SpringButton()

    
    var shoppingListCollectionView : UICollectionView!
    var shoppingListLayout : UICollectionViewFlowLayout!


    var shoppingRecipes : [String: [Ingredient]]!
    
    var clearBtn = SpringButton()

    var step1View = UIView()
    var step1Lbl = UILabel()
    var step1Arrow : UIImageView!
    
    
    var step2View = UIView()
    var step2Lbl = UILabel()
    var step2Arrow : UIImageView!
    
    var step3View = UIView()
    var step3Lbl = UILabel()
    var step3Arrow : UIImageView!
    let greyOverlay = UIView()

    
    var tempBtn : UIImageView!
    var tempBtn2 : UIImageView!
    
    
    let emptyView = EmptyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

         self.view.backgroundColor = .white
         
         //for now..
         self.shoppingRecipes = DataManager.sharedInstance.getGroceryList()
         
         NotificationCenter.default.addObserver(self, selector: #selector(shoppingUpdated), name: DataManager.listUpdated, object: nil)

         
         
         self.shoppingListLayout = UICollectionViewFlowLayout()
         self.shoppingListLayout.scrollDirection = .vertical
         self.shoppingListLayout.minimumInteritemSpacing = 0
         self.shoppingListLayout.minimumLineSpacing = 0
        self.shoppingListLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
         self.shoppingListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.shoppingListLayout)

        
        shoppingListCollectionView.delegate = self
        shoppingListCollectionView.dataSource = self
        

        self.shoppingListCollectionView.register(ShoppingListRecipeCell.self, forCellWithReuseIdentifier: "shoppingCell")
         
         
        let ketoBibleStr : String = StyleManager.titleString

         let ketoBibleText = NSMutableAttributedString(string: ketoBibleStr, attributes: [NSAttributedString.Key.font: StyleManager.topTitleFont!])
         if StyleManager.isKeto {
             ketoBibleText.addAttributes([ NSAttributedString.Key.font : StyleManager.topTitleFontBold! ], range: NSMakeRange(4, 4));
         } else {
             ketoBibleText.addAttributes([ NSAttributedString.Key.font : StyleManager.topTitleFontBold! ], range: NSMakeRange(4, 5));
         }
         ketoBibleText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: NSMakeRange(0, ketoBibleStr.count))
         
         titleLbl.attributedText = ketoBibleText
         self.view.addSubview(titleLbl)
         titleLbl.snp.makeConstraints{ (make) in
             make.top.equalTo(self.view.snp.top).offset(StyleManager.topOffset)
             make.centerX.equalTo(self.view.snp.centerX)
         }
         
         let menuIcon = UIImage(named: "menuIcon.pdf")
         menuBtn.setImage(menuIcon, for: .normal)

         
         self.view.addSubview(menuBtn)
         self.menuBtn.snp.makeConstraints{ (make) in
             make.centerY.equalTo(self.titleLbl.snp.centerY)
             make.right.equalTo(self.view.snp.right).offset(-20)
         }
         
         self.menuBtn.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)

         
        
         
         let shoppingTitle = UILabel()
         shoppingTitle.text = "Shopping List"
         shoppingTitle.textColor = UIColor(red:0.23, green:0.23, blue:0.23, alpha:1.00)
         shoppingTitle.font = StyleManager.ingredLblFont
         self.view.addSubview(shoppingTitle)
         shoppingTitle.snp.makeConstraints { (make) in
             make.top.equalTo(self.titleLbl.snp.bottom).offset(20)
             make.left.equalTo(self.view.snp.left).offset(20)
         }
         
         self.shoppingListCollectionView.backgroundColor = .white
         self.view.addSubview(shoppingListCollectionView)
         shoppingListCollectionView.snp.makeConstraints { (make) in
             make.top.equalTo(shoppingTitle.snp.bottom)
            make.width.equalTo(self.view.snp.width)
             make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(self.view.snp.bottom)
         }
        
        self.clearBtn.setTitle("Clear All", for: .normal)
        self.clearBtn.setTitleColor(.black, for: .normal)
        self.clearBtn.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16)
        self.view.addSubview(clearBtn)
        clearBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(shoppingTitle.snp.centerY)
            make.right.equalTo(self.view.snp.right).offset(-20)
        }
        self.clearBtn.addTarget(self, action: #selector(clearBtnPressed), for: .touchUpInside)

        greyOverlay.backgroundColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 0.79)
        self.view.addSubview(greyOverlay)
        greyOverlay.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.snp.edges)
        }
        greyOverlay.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapPressed))
        greyOverlay.addGestureRecognizer(tap)

        if !UserManager.shared.getShownGrocery() && self.shoppingRecipes != nil && self.shoppingRecipes.count > 0 {
            greyOverlay.isHidden = false
        }
        
        for label in [step1Lbl, step2Lbl, step3Lbl] {
            label.font = UIFont(name: "Avenir-Heavy", size: 15)
            label.textColor = .black
            label.numberOfLines = 2
            label.textAlignment = .center
            //label.shadowColor = .gray
            label.adjustsFontSizeToFitWidth = true
            label.isHidden = true
        }
        
        for view in [step1View, step2View, step3View] {
            view.backgroundColor = .white
            view.layer.cornerRadius = 12
            view.isHidden = true
        }
        
        step1Lbl.text = "Tap to clear your grocery list"
        step2Lbl.text = "Tap to remove recipe from your grocery list"
        step3Lbl.text = "Tap to mark ingredient as purchased"

        step1Arrow = UIImageView(image: UIImage(named: "step1Arrow"))
        step1Arrow.isHidden = true
        step2Arrow = UIImageView(image: UIImage(named: "step2Arrow"))
        step2Arrow.isHidden = true
        step3Arrow = UIImageView(image: UIImage(named: "step3Arrow"))
        step3Arrow.isHidden = true
        
        greyOverlay.addSubview(step1View)
        greyOverlay.addSubview(step2View)
        greyOverlay.addSubview(step3View)
        
        self.step1View.addSubview(step1Lbl)
        self.step2View.addSubview(step2Lbl)
        self.step3View.addSubview(step3Lbl)
    
        greyOverlay.addSubview(step1Arrow)
        greyOverlay.addSubview(step2Arrow)
        greyOverlay.addSubview(step3Arrow)
        
        self.view.addSubview(emptyView)
        emptyView.setupView(image: UIImage(named: "shoppingEmpty")!, title: "Your List is Empty", description: "Add recipes to your shopping list and begin shopping!")
        emptyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(80)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        emptyView.isHidden = true

        if !UserManager.shared.getShownGrocery() && self.shoppingRecipes != nil && self.shoppingRecipes.count > 0 {
            step1View.isHidden = false
            step1Lbl.isHidden = false
            step1Arrow.isHidden = false
            
            self.clearBtn.setTitleColor(.white, for: .normal)
            self.view.bringSubviewToFront(clearBtn)
            clearBtn.isEnabled = false
        }
        
        if self.shoppingRecipes == nil || self.shoppingRecipes.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
         
        
        
        self.step1Arrow.snp.makeConstraints { (make) in
            make.right.equalTo(self.clearBtn.snp.left).offset(-3)
            make.top.equalTo(self.clearBtn.snp.top)
        }
        
        self.step1View.snp.makeConstraints { (make) in
            make.top.equalTo(step1Arrow.snp.bottom)
            make.right.equalTo(self.view.snp.right).offset(-50)
            make.height.equalTo(65)
            make.width.equalTo(165)
        }
        
        self.step1Lbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.step1View.snp.centerX)
            make.centerY.equalTo(self.step1View.snp.centerY)
            make.width.equalTo(self.step1View.snp.width).offset(-30)
            make.height.equalTo(self.step1View.snp.height).offset(-20)
        }

        self.tempBtn = UIImageView(image: UIImage(named: "recipeMinus"))
        self.view.addSubview(self.tempBtn)
        self.tempBtn.isHidden = true
        
        self.tempBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(27)
            make.top.equalTo(self.shoppingListCollectionView.snp.top).offset(26)
        }
        
        self.step2Arrow.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.shoppingListCollectionView.snp.top).offset(29)
        }
            
        self.step2View.snp.makeConstraints { (make) in
            make.bottom.equalTo(step2Arrow.snp.bottom).offset(5)
            make.left.equalTo(self.step2Arrow.snp.right).offset(3)
            make.height.equalTo(65)
            make.width.equalTo(165)
        }
            
        self.step2Lbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.step2View.snp.centerX)
            make.centerY.equalTo(self.step2View.snp.centerY)
            make.width.equalTo(self.step2View.snp.width).offset(-30)
            make.height.equalTo(self.step2View.snp.height).offset(-20)
        }
        
        
        
        self.tempBtn2 = UIImageView(image: UIImage(named: "ingredientMinus"))
        self.view.addSubview(self.tempBtn2)
        self.tempBtn2.isHidden = true
        
        self.tempBtn2.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(120)
            make.top.equalTo(self.shoppingListCollectionView.snp.top).offset(55)
        }
        
        self.step3Arrow.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(130)
            make.top.equalTo(self.shoppingListCollectionView.snp.top).offset(47)
        }
            
        self.step3View.snp.makeConstraints { (make) in
            make.top.equalTo(step3Arrow.snp.bottom).offset(-15)
            make.left.equalTo(self.step3Arrow.snp.right).offset(5)
            make.height.equalTo(65)
            make.width.equalTo(165)
        }
            
        self.step3Lbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.step3View.snp.centerX)
            make.centerY.equalTo(self.step3View.snp.centerY)
            make.width.equalTo(self.step3View.snp.width).offset(-30)
            make.height.equalTo(self.step3View.snp.height).offset(-20)
        }
        

        

    }
    
    @objc func tapPressed() {
        if !step1Arrow.isHidden {
            self.step1Arrow.isHidden = true
            self.step2Arrow.isHidden = false
            
            self.step1Lbl.isHidden = true
            self.step2Lbl.isHidden = false
            
            self.step1View.isHidden = true
            self.step2View.isHidden = false
            
            self.clearBtn.setTitleColor(.black, for: .normal)
            self.view.sendSubviewToBack(clearBtn)

            
            self.tempBtn.isHidden = false
            clearBtn.isEnabled = true
            self.view.bringSubviewToFront(self.tempBtn)
            
            
        } else if !step2Arrow.isHidden {
            self.tempBtn.isHidden = true
            self.tempBtn2.isHidden = false

            
            self.step2Arrow.isHidden = true
            self.step3Arrow.isHidden = false
            
            self.step2Lbl.isHidden = true
            self.step3Lbl.isHidden = false
            
            self.step2View.isHidden = true
            self.step3View.isHidden = false

            
        } else if !step3Arrow.isHidden {
            
            self.tempBtn2.isHidden = true
            self.step3Arrow.isHidden = true
            self.step3Lbl.isHidden = true
            self.step3View.isHidden = true
            self.greyOverlay.isHidden = true
        }
        
        UserManager.shared.setShownGrocery()
    }
    
    @objc func menuButtonSelected() {
        panel?.openLeft(animated: true)
    }
    

    @objc func backBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shoppingUpdated() {
        self.shoppingRecipes = DataManager.sharedInstance.getGroceryList()
        
        if self.shoppingRecipes == nil || self.shoppingRecipes.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
        
        self.shoppingListCollectionView.reloadData()
        
    }

    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: UIScreen.main.bounds.width-20, height: 180)
    }
     


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.shoppingRecipes != nil {
            return self.shoppingRecipes!.count
        }
        return 0
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let shoppingRecipe = Array(shoppingRecipes)[indexPath.row].key
        
        
        let recipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "shoppingCell", for: indexPath) as! ShoppingListRecipeCell

        recipeCell.updateForRecipe(recipeTitle: shoppingRecipe, ingredients: self.shoppingRecipes[shoppingRecipe]!)
        
        recipeCell.backgroundColor = .white
                
        return recipeCell
    }
    
    @objc func clearBtnPressed() {
        self.clearBtn.pop {
            
            if self.shoppingRecipes != nil && self.shoppingRecipes.count > 0 {
                DataManager.sharedInstance.removeAllGrocery()

                self.shoppingRecipes.removeAll()
                
                if self.shoppingRecipes == nil || self.shoppingRecipes.count == 0 {
                    self.emptyView.isHidden = false
                } else {
                    self.emptyView.isHidden = true
                }
                
                self.shoppingListCollectionView.reloadData()
            }
            
        }
    }


}
