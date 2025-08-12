//
//  RecipeVC.swift
//  The Keto Bible
//
//  Created by Laura Day on 20/3/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring
import Hero



class RecipeVC : UIViewController, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var scrollView : UIScrollView!
    var recipe : RecipeItem!
    
    var titleLbl = UILabel()
    var backButton = SpringButton()
    
    let whiteOverlayView = UIView()

    
    var favBtn = SpringButton()
    
    var ingredients = [Ingredient]()
    
    var ingredAddBtn = SpringButton()

    var ingredCollectionView : IngredientCollectionView!
    var ingredLayout : UICollectionViewFlowLayout!
    
    
    var stepsCollectionView: IngredientCollectionView!
    var stepsLayout : UICollectionViewFlowLayout!
    var stepsPageControl = UIPageControl()

    let imageView = UIImageView()
    let calsLine = UIView()
    
    let ingredMsg = UILabel()

    
    var instaHandleLink = SpringButton()
    

    @objc func updateIngredients() {
       // self.ingredients = DataManager.sharedInstance.getCurrentIngredients()!
       // self.ingredCollectionView.reloadData()
    }
    

  
    fileprivate func setTitles(_ titleLbls: [UILabel], _ amtLbls: [UILabel]) {
        titleLbls[0].text = "Calories"
        titleLbls[1].text = "Net Carbs"
        titleLbls[2].text = "Protein"
        titleLbls[3].text = "Fat"
        titleLbls[4].text = "Saturated Fat"
        titleLbls[5].text = "Fibre"
        titleLbls[6].text = "Sodium"
        titleLbls[7].text = "Cholesterol"
        
        amtLbls[0].text = String(describing: Int(self.recipe.nutritional.calories.rounded()))
        amtLbls[1].text = String(describing: Int(self.recipe.nutritional.netCarbs.rounded())) + " g"
        amtLbls[2].text = String(describing: Int(self.recipe.nutritional.protein.rounded())) + " g"
        amtLbls[3].text = String(describing: Int(self.recipe.nutritional.fat.rounded())) + " g"
        amtLbls[4].text = String(describing: Int(self.recipe.nutritional.satFat.rounded())) + " g"
        amtLbls[5].text = String(describing: Int(self.recipe.nutritional.fibre.rounded())) + " g"
        amtLbls[6].text = String(describing: Int(self.recipe.nutritional.sodium.rounded())) + " mg"
        amtLbls[7].text = String(describing: Int(self.recipe.nutritional.cholesterol.rounded())) + " mg"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil


        
        self.hero.isEnabled = true
        self.navigationController?.hero.isEnabled = true
        
        self.view.backgroundColor = .white
        self.scrollView = UIScrollView()
        self.scrollView.isDirectionalLockEnabled = true
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)

        }
        


        
        if recipe.ingredID != nil {
            DataManager.sharedInstance.getIngredientsFromStrings(ingredID: recipe.ingredID!, completion: { (ingred) in
                self.ingredients = ingred
                self.ingredCollectionView.reloadData()
            })
        }
        
         NotificationCenter.default.addObserver(self, selector: #selector(updateIngredients), name: DataManager.ingredientsLoaded, object: nil)
        
        self.ingredLayout = UICollectionViewFlowLayout()
        self.ingredLayout.scrollDirection = .horizontal
        self.ingredCollectionView = IngredientCollectionView(frame: .zero, collectionViewLayout: self.ingredLayout)
        self.ingredCollectionView.dataSource = self
        self.ingredCollectionView.delegate = self
        //self.ingredCollectionView.isDirectionalLockEnabled = true
        self.ingredCollectionView.register(IngredientCell.self, forCellWithReuseIdentifier: "IngredCell")
        //self.ingredCollectionView.isPagingEnabled = false
        //self.ingredCollectionView.isScrollEnabled = false
        
       // let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleTap))
        //swipeRight.direction = .right
        
        //let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleTap))
        //swipeLeft.direction = .left
        
        //ingredCollectionView.addGestureRecognizer(swipeRight)
        //ingredCollectionView.addGestureRecognizer(swipeLeft)

        
        
        self.ingredCollectionView.backgroundColor = .clear
        self.ingredLayout.minimumInteritemSpacing = 0
        self.ingredLayout.minimumLineSpacing = 10
        self.ingredCollectionView.showsVerticalScrollIndicator = false
        self.ingredCollectionView .showsHorizontalScrollIndicator = false
        
        
        self.stepsLayout = UICollectionViewFlowLayout()
        self.stepsLayout.scrollDirection = .horizontal
        self.stepsCollectionView = IngredientCollectionView(frame: .zero, collectionViewLayout: self.stepsLayout)
        self.stepsCollectionView.dataSource = self
        self.stepsCollectionView.delegate = self
        
        self.stepsCollectionView.register(StepCell.self, forCellWithReuseIdentifier: "stepsCell")
        
        self.stepsCollectionView.backgroundColor = .white
        self.stepsCollectionView.showsVerticalScrollIndicator = false
        self.stepsCollectionView .showsHorizontalScrollIndicator = false
        self.stepsCollectionView.isDirectionalLockEnabled = true
        self.stepsCollectionView.isPagingEnabled = true
        

        
        
        
        var height : CGFloat = 1500
        if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S {
            height = 1000
        }
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: height)
        
        
        if recipe.imageUrl != nil {
            imageView.kf.setImage(with: recipe.imageUrl)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.hero.id = recipe.title
        whiteOverlayView.hero.id = recipe.title
        favBtn.hero.id = recipe.title

        //whiteOverlayView.hero.modifiers = [.useGlobalCoordinateSpace, .bringToFront, .zPosition(10)]
        //favBtn.hero.modifiers = [.useGlobalCoordinateSpace, .bringToFront, .zPosition(10)]
        scrollView.hero.id = "\(recipe.title)_scrollView"
        scrollView.hero.modifiers = [.zPosition(2)]

        
        self.scrollView.addSubview(imageView)
        imageView.snp.makeConstraints{ (make) in
            make.top.equalTo(self.scrollView.snp.top).offset(-45)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            switch UIDevice().type {
            case .iPhone8, .iPhone7, .iPhone6S, .iPhone6, .iPhoneSE:
                make.height.equalTo(550)
            case .iPhone5, .iPhone5S, .iPhone5C:
                make.height.equalTo(500)
            default:
                make.height.equalTo(660)
            }
        }
        
        
        let imgOverlay = UIView()
        imgOverlay.backgroundColor = .black
        imgOverlay.alpha = 0.15
        imageView.addSubview(imgOverlay)
        imgOverlay.snp.makeConstraints{ (make) in
            make.edges.equalTo(imageView)
        }
        
        
        
        let ketoBibleStr : String = StyleManager.titleString

        let ketoBibleText = NSMutableAttributedString(string: ketoBibleStr, attributes: [NSAttributedString.Key.font: StyleManager.topTitleFont!])
        if StyleManager.isKeto {
            ketoBibleText.addAttributes([ NSAttributedString.Key.font : StyleManager.topTitleFontBold! ], range: NSMakeRange(4, 4));
        } else {
            ketoBibleText.addAttributes([ NSAttributedString.Key.font : StyleManager.topTitleFontBold! ], range: NSMakeRange(4, 5));
        }
        if recipe.whiteText != nil && recipe.whiteText! {
            ketoBibleText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: NSMakeRange(0, ketoBibleStr.count))
        } else {
            ketoBibleText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: NSMakeRange(0, ketoBibleStr.count))
        }

        
        titleLbl.attributedText = ketoBibleText
        self.scrollView.addSubview(titleLbl)
        titleLbl.snp.makeConstraints{ (make) in
            make.top.equalTo(self.view.snp.top).offset(StyleManager.topOffset)
            make.centerX.equalTo(self.scrollView.snp.centerX)
        }
        
        
        var backIcon : UIImage!
        if recipe.whiteText != nil && recipe.whiteText! {
            backIcon = UIImage(named: "BackButtonW")
        } else {
            backIcon = UIImage(named: "BackButton")
        }
        
        backButton.setImage(backIcon, for: .normal)
        
        
        self.scrollView.addSubview(backButton)
        self.backButton.snp.makeConstraints{ (make) in
            make.centerY.equalTo(self.titleLbl.snp.centerY)
            make.left.equalTo(self.view.snp.left).offset(4)
        }
        backButton.addTarget(self, action: #selector(backBtnPressed), for: .touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)


        whiteOverlayView.layer.cornerRadius = 31
        whiteOverlayView.clipsToBounds = true
        whiteOverlayView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        whiteOverlayView.backgroundColor = .white
        self.scrollView.addSubview(whiteOverlayView)
        whiteOverlayView.snp.makeConstraints{ (make) in
            make.top.equalTo(imageView.snp.bottom).offset(-30)
            make.left.equalTo(self.imageView.snp.left)
            make.right.equalTo(self.imageView.snp.right)
            make.height.equalTo(2000)
        }
        
        var isFavourite : Bool = false
        
        let favourites = DataManager.sharedInstance.getFavs()
        if favourites != nil {
            for item in favourites! {
                if item.title == recipe.title {
                    isFavourite = true
                }
            }
        }
        
        
        if isFavourite {
            self.favBtn.setImage(UIImage(named: "fav_select"), for: .normal)
            self.favBtn.isSelected = true
        } else {
            self.favBtn.setImage(UIImage(named: "fav_unselect"), for: .normal)
            self.favBtn.isSelected = false

        }
        self.favBtn.addTarget(self, action: #selector(favPressed), for: .touchUpInside)

        self.scrollView.addSubview(favBtn)
        self.favBtn.snp.makeConstraints{ (make) in
            make.bottom.equalTo(whiteOverlayView.snp.top).offset(15)
            make.right.equalTo(whiteOverlayView.snp.right).offset(-40)
        }
        
        let recipeTitle = VerticalAlignedLabel()
        
        recipeTitle.textAlignment = .left
        recipeTitle.adjustsFontSizeToFitWidth = true
        recipeTitle.font = StyleManager.recipeViewTitleFont
        recipeTitle.contentMode = .bottom
        
        recipeTitle.text = recipe.title
        recipeTitle.textColor = .white
        recipeTitle.setLineHeight(lineHeight: 0.2)
        recipeTitle.numberOfLines = 2
        recipeTitle.lineBreakMode = .byTruncatingTail
        imageView.addSubview(recipeTitle)
        recipeTitle.snp.makeConstraints{ (make) in
            make.left.equalTo(view.snp.left).offset(15)
            if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5S {
                make.width.equalTo(200)
            } else {
                make.width.equalTo(250)
            }
            make.bottom.equalTo(whiteOverlayView.snp.top).offset(0)
            make.height.equalTo(90)
        }
        
        let cookImgView = UIImageView(image: UIImage(named: "cookIcon"))
        whiteOverlayView.addSubview(cookImgView)
        cookImgView.snp.makeConstraints { (make) in
            make.top.equalTo(whiteOverlayView.snp.top).offset(30)
            make.centerX.equalTo(whiteOverlayView.snp.centerX)
            
        }
        
        let leftRightOffset = UIScreen.main.bounds.width / 3
        let prepImgView = UIImageView(image: UIImage(named: "timerIcon"))
        whiteOverlayView.addSubview(prepImgView)
        prepImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(cookImgView.snp.centerY)
            make.left.equalTo(leftRightOffset/2)
        }
        
        let servesImgView = UIImageView(image: UIImage(named: "serves"))
        whiteOverlayView.addSubview(servesImgView)
        servesImgView.snp.makeConstraints { (make) in
            make.centerY.equalTo(cookImgView.snp.centerY)
            make.right.equalTo(whiteOverlayView.snp.right).offset(-leftRightOffset/2)
        }

        let timerLbl = UILabel()
        let cookLbl = UILabel()
        let servesLbl = UILabel()
        
        for label in [timerLbl, cookLbl, servesLbl] {
            label.textColor = .black
            label.font = StyleManager.cookingLblsFont
        }
        
        timerLbl.text = String(describing: recipe.prepTime) + " min"
        cookLbl.text = String(describing: recipe.cookingTime) + " min"
        servesLbl.text = String(describing: recipe.servings) + " serves"

        whiteOverlayView.addSubview(timerLbl)
        whiteOverlayView.addSubview(cookLbl)
        whiteOverlayView.addSubview(servesLbl)

        timerLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(prepImgView.snp.centerX)
            make.top.equalTo(prepImgView.snp.bottom).offset(5)
        }
        
        cookLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(cookImgView.snp.centerX)
            make.top.equalTo(cookImgView.snp.bottom).offset(5)
        }
        
        servesLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(servesImgView.snp.centerX)
            make.top.equalTo(servesImgView.snp.bottom).offset(5)
        }
        
        let horizontalLine = UIView()
        horizontalLine.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.00)
        whiteOverlayView.addSubview(horizontalLine)
        horizontalLine.snp.makeConstraints { (make) in
            make.centerX.equalTo(whiteOverlayView.snp.centerX)
            make.top.equalTo(servesLbl.snp.bottom).offset(30)
            make.height.equalTo(1)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
        }
        
        let ingredientsLbl = UILabel()
        ingredientsLbl.text = "Ingredients"
        ingredientsLbl.textColor = UIColor(red:0.23, green:0.23, blue:0.23, alpha:1.00)
        ingredientsLbl.font = StyleManager.ingredLblFont
        ingredientsLbl.adjustsFontSizeToFitWidth = true
        whiteOverlayView.addSubview(ingredientsLbl)
        ingredientsLbl.snp.makeConstraints { (make) in
            make.left.equalTo(horizontalLine.snp.left).offset(-10)
            make.top.equalTo(horizontalLine.snp.bottom).offset(30)
        }
        
        var isInList : Bool = false
        
        let groceryList = DataManager.sharedInstance.getGroceryList()
        if groceryList != nil {
            for item in groceryList! {
                
                if item.key == recipe.title {
                    isInList = true
                }
            }
        }
        
        if isInList {
            self.ingredAddBtn.setImage(UIImage(named: "checkIngred"), for: .normal)
        } else {
            self.ingredAddBtn.setImage(UIImage(named: "addIngred"), for: .normal)
        }
        
        ingredMsg.text = "Added to shopping list."
        ingredMsg.font = UIFont(name: "Avenir-Light", size: 11)
        ingredMsg.textColor = ingredientsLbl.textColor
        ingredMsg.numberOfLines = 2
        ingredMsg.adjustsFontSizeToFitWidth = true
        
                
        whiteOverlayView.addSubview(ingredAddBtn)
        ingredAddBtn.snp.makeConstraints { (make) in
            make.left.equalTo(ingredientsLbl.snp.right).offset(3)
            make.bottom.equalTo(ingredientsLbl.snp.top).offset(5)
        }
        self.ingredAddBtn.addTarget(self, action: #selector(addIngredients), for: .touchUpInside)
        ingredAddBtn.isHidden = false
        
        whiteOverlayView.addSubview(ingredMsg)
        ingredMsg.snp.makeConstraints { (make) in
            make.left.equalTo(ingredAddBtn.snp.right).offset(5)
            make.centerY.equalTo(ingredAddBtn.snp.centerY)
            
            if UIDevice.current.type == .iPhone5 || UIDevice.current.type == .iPhoneSE || UIDevice.current.type == .iPhone5C || UIDevice.current.type == .iPhone5S  {
                make.width.equalTo(70)
            }
            //make.right.equalTo(self.view.snp.right)
            //make.height.equalTo(30)
        }
        ingredMsg.isHidden = true
        
        //recipe.ingredients[0]
        
        scrollView.addSubview(ingredCollectionView)
        ingredCollectionView.snp.makeConstraints{ (make) in
            make.top.equalTo(ingredientsLbl.snp.bottom).offset(10)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.height.equalTo(170)
        }
        
        let howToMakeLbl = UILabel()
        howToMakeLbl.text = "How to make"
        howToMakeLbl.backgroundColor = .white
        howToMakeLbl.textColor = UIColor(red:0.23, green:0.23, blue:0.23, alpha:1.00)
        howToMakeLbl.font = StyleManager.ingredLblFont
        whiteOverlayView.addSubview(howToMakeLbl)
        howToMakeLbl.snp.makeConstraints { (make) in
            make.left.equalTo(ingredientsLbl.snp.left)
            make.top.equalTo(ingredCollectionView.snp.bottom)
        }
        
        
        stepsPageControl.currentPageIndicatorTintColor = .red
        stepsPageControl.backgroundColor = .white
        //stepsPageControl.isUserInteractionEnabled = false
        self.stepsPageControl.pageIndicatorTintColor = UIColor(red:0.23, green:0.23, blue:0.23, alpha:1.00)

        
        scrollView.addSubview(stepsCollectionView)
        stepsCollectionView.snp.makeConstraints{ (make) in
            make.top.equalTo(howToMakeLbl.snp.bottom).offset(10)
            if StyleManager.isIpad() {
                make.left.equalTo(self.view.snp.left).offset(100)
                make.right.equalTo(self.view.snp.right).offset(-100)
            } else {
                make.left.equalTo(self.view.snp.left)
                make.right.equalTo(self.view.snp.right)
            }
            make.height.equalTo(170)
        }
       
        
        scrollView.addSubview(stepsPageControl)
        stepsPageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(stepsCollectionView.snp.bottom)
        }
        
        let nutritionalLbl = UILabel()
        nutritionalLbl.text = "Nutritional info"
        nutritionalLbl.textColor = UIColor(red:0.23, green:0.23, blue:0.23, alpha:1.00)
        nutritionalLbl.font = StyleManager.ingredLblFont
        whiteOverlayView.addSubview(nutritionalLbl)
        nutritionalLbl.snp.makeConstraints { (make) in
            make.left.equalTo(ingredientsLbl.snp.left)
            make.top.equalTo(stepsPageControl.snp.bottom).offset(20)
        }
        
        let lines = [DashedLineView(), DashedLineView(), DashedLineView(), DashedLineView(), DashedLineView(), DashedLineView(), DashedLineView(), DashedLineView()]
        let titleLbls = [UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
        let amtLbls =   [UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel(), UILabel()]
        
        
        for label in  titleLbls {
            label.font = StyleManager.nutrientLblFont
            label.textColor = UIColor(red:0.23, green:0.23, blue:0.23, alpha:1.00)
            whiteOverlayView.addSubview(label)
        }
        
        for label in  amtLbls{
            label.font = StyleManager.nutrientLblFont
            label.textColor = .red
            whiteOverlayView.addSubview(label)
        }
        
        for line in lines  {
            whiteOverlayView.addSubview(line)
            line.backgroundColor = .clear
        }
        
        setTitles(titleLbls, amtLbls)
        let offset = 5

    
        for (index, label) in titleLbls.enumerated() {
            
            if index == 0 {
                label.snp.makeConstraints { (make) in
                    make.top.equalTo(nutritionalLbl.snp.bottom).offset(30)
                    make.left.equalTo(nutritionalLbl.snp.left)
                }
            } else {
                label.snp.makeConstraints { (make) in
                    make.top.equalTo(titleLbls[index-1].snp.bottom).offset(offset)
                    make.left.equalTo(nutritionalLbl.snp.left)
                }
                
            }
            
        }

        
        for (index, line) in lines.enumerated() {
            
            
            line.snp.makeConstraints { (make) in
                make.left.equalTo(titleLbls[index].snp.right).offset(3)
                make.right.equalTo(amtLbls[index].snp.left).offset(-5)
                make.height.equalTo(1)
                make.bottom.equalTo(titleLbls[index].snp.bottom).offset(-5)
            }
            
        }
        
        
        for (index, label) in amtLbls.enumerated() {
            label.snp.makeConstraints { (make) in
                make.top.equalTo(titleLbls[index].snp.top)
                if StyleManager.isIpad() {
                    make.right.equalTo(self.view.snp.right).offset(-100)
                } else {
                    make.right.equalTo(self.view.snp.right).offset(-30)
                }
            }
            

        }
        
        
        
        self.instaHandleLink.setTitle(recipe.instaHandle, for: .normal)
        self.instaHandleLink.setImage(UIImage(named: "instaIcon"), for: .normal)
        self.instaHandleLink.setTitleColor(UIColor(red:0.23, green:0.23, blue:0.23, alpha:1.0), for: .normal)
        self.instaHandleLink.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 20)
        self.instaHandleLink.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        self.instaHandleLink.addTarget(self, action: #selector(handlePressed), for: .touchUpInside)
        
        
        if self.recipe.instaHandle != nil {
            self.whiteOverlayView.addSubview(instaHandleLink)
            instaHandleLink.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.top.equalTo(titleLbls.last!.snp.bottom).offset(40)
                make.width.equalTo(300)
            }
        }
        

        
    }
    
    @objc func handlePressed() {
        self.instaHandleLink.pop {
            
            
            if self.recipe.useWebsite != nil && self.recipe.useWebsite! {
                if self.recipe.websiteLink != nil {
                    let url = URL(string: self.recipe.websiteLink!)
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url!, options: [:],
                        completionHandler: {
                            (success) in
                        })
                    } else {
                        let success = UIApplication.shared.openURL(url!)
                    }
                }
            } else if self.recipe.instaHandle != nil {
                let instagramHooks = "instagram://user?username=" + self.recipe.instaHandle!
                let url = URL(string: instagramHooks)!
                
                var result = false
                if #available(iOS 10, *) {
                  UIApplication.shared.open(url, options: [:],
                    completionHandler: {
                      (success) in
                        result = success
                   })
                } else {
                    result = UIApplication.shared.openURL(url)
                }
                
                //try jsut browser version if no app
                if !result {
                    let webStr = "https://instagram.com/" + self.recipe.instaHandle!
                    let urlWeb = URL(string: webStr)!
                    if #available(iOS 10, *) {
                      UIApplication.shared.open(urlWeb, options: [:],
                        completionHandler: {
                          (success) in
                       })
                    } else {
                        _ = UIApplication.shared.openURL(urlWeb)
                    }
                }
                
                
            }
            
        }
    }
    
    
    @objc func handleTap() {
        self.ingredCollectionView.isScrollEnabled = true
    }
    
    @objc func favPressed() {
        if self.favBtn.isSelected {
            self.favBtn.isSelected = false
            self.favBtn.setImage(UIImage(named: "fav_unselect"), for: .normal)
            DataManager.sharedInstance.removeFavourite(favRemove: self.recipe)
        } else {
            self.favBtn.isSelected = true
            self.favBtn.setImage(UIImage(named: "fav_select"), for: .normal)
            DataManager.sharedInstance.addFavourite(fav: self.recipe)
        }

    }
    

    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1700)

    }
    
    @objc func backBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == stepsCollectionView {
            return CGSize(width: UIScreen.main.bounds.width, height: 170)
        } else {
            return CGSize(width: 100, height: 170)
        }
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.stepsCollectionView {
            if recipe.steps != nil {
                stepsPageControl.numberOfPages = recipe.steps!.count
                return recipe.steps!.count
            } else {
                return 0
            }
        } else {
            return ingredients.count
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == stepsCollectionView {
            let stepCell = collectionView.dequeueReusableCell(withReuseIdentifier: "stepsCell", for: indexPath) as! StepCell

            stepCell.backgroundColor = .white
            stepCell.updateCellForItem(stepNumber: (indexPath.row+1), step: recipe.steps![indexPath.row])
            
            return stepCell
            
        } else {
            let ingredientsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredCell", for: indexPath) as! IngredientCell
            if self.ingredients.count > 0 {
                ingredientsCell.updateCellForItem(ingredient: self.ingredients[indexPath.row])
                ingredientsCell.resetBottomLine()
            }
            
            return ingredientsCell
        }
        
    }
    
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == ingredCollectionView {
            for item in collectionView.visibleCells  {
                let currentCell = item as! IngredientCell
                currentCell.resetBottomLine()
                
                
                let cell = collectionView.cellForItem(at: indexPath) as! IngredientCell
                cell.setBottomLime(color: .red)
                
            }
        }
        
    }

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        stepsPageControl.currentPage = Int(pageIndex)
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) ->  CGFloat {
        return 0
    }
    
    @objc func addIngredients() {
        
          if self.ingredAddBtn.isSelected {
            self.ingredAddBtn.isSelected = false
            self.ingredAddBtn.setImage(UIImage(named: "addIngred"), for: .normal)
            
            DataManager.sharedInstance.removeGroceryListItem(listRemove: self.recipe.title)
            
            if !DataManager.sharedInstance.shownGroceryMessage {
                ingredMsg.text = "Removed from shopping list."
                ingredMsg.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.ingredMsg.isHidden = true
                }
                DataManager.sharedInstance.shownGroceryMessage = true
            }
            
        } else {
            if !DataManager.sharedInstance.shownGroceryMessage {
                ingredMsg.text = "Added to shopping list."
                ingredMsg.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.ingredMsg.isHidden = true
                }
            }
            self.ingredAddBtn.isSelected = true
            self.ingredAddBtn.setImage(UIImage(named: "checkIngred"), for: .normal)
            
            if self.recipe != nil && recipe.ingredID != nil {
                DataManager.sharedInstance.getIngredientsFromStrings(ingredID: recipe.ingredID!) { (ingredientList) in
                                   DataManager.sharedInstance.addToGroceryList(title: self.recipe.title, ingredients: ingredientList)
                           }
            }
            
           

        
        }
        
    }
    
    

}


