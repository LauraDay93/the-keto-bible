//
//  LandingFeedVC.swift
//  The Keto Bible
//
//  Created by Laura Day on 12/2/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring
import ViewAnimator
//import Persei
import SwiftMessages
import Hero
import SwiftRater
import iProgressHUD

class LandingFeedVC : UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, FiltersViewDelegate, UISearchBarDelegate {
    
    
    enum TopCategory : Int {
        case christmas = 10
        case carbSubstitutes = 11
        case foodsToAvoid = 0
        case eatingOut = 1
        case supplements = 2
    }
    
    let iprogress: iProgressHUD = iProgressHUD()

    var titleLbl = SpringLabel()
    var searchBtn = SpringButton()
    var menuBtn = SpringButton()
    var searchTextField = UISearchBar()
    
    

    
    var exploreCatLbl = SpringLabel()
    var whatsNewLbl = SpringLabel()
    let whatsNewText = "WHAT'S NEW"
    
    let filterView = FilterView()

    
    var catCollectionView : UICollectionView!
    var catLayout : UICollectionViewFlowLayout!

    var recipeCollectionView : UICollectionView!
    var recipeLayout : UICollectionViewFlowLayout!
    var searchResultsCollection : UICollectionView!

    var recipes : [RecipeItem]?
    var allRecipes : [RecipeItem]?
    var searchResults = [RecipeItem]()

    
    var filtersCollectionView : UICollectionView!
    var filtersLayout : UICollectionViewFlowLayout!

    
    var filtersBtn = SpringButton()
    var under15Btn = SpringButton()
    var breakFast = SpringButton()
    var lunch = SpringButton()
    var dinner = SpringButton()
    var snacks = SpringButton()
    
    var scrollView : UIScrollView!
    
    var noResultsSearchLbl = UILabel()
    var noResultsFilterLbl = UILabel()

    let selectedPath = IndexPath(row: 0, section: 0)

    var firstLaunch : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        SwiftRater.check()
                
        self.hero.isEnabled = true
        
        if self.panel != nil &&  self.panel!.center is UINavigationController {
            (self.panel!.center as! UINavigationController).isHeroEnabled = true
        }
        
        self.hero.modalAnimationType = .slide(direction: .up)
        
        NotificationCenter.default.addObserver(self, selector: #selector(recipesLoaded), name: DataManager.recipesLoaded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recipesUpdated), name: DataManager.recipesUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recipesUpdating), name: DataManager.recipesUpdating, object: nil)


        if UserManager.shared.getWifiSync() && !DataManager.sharedInstance.reachability.isReachableViaWiFi() {
            self.cantSyncWifi()
        }
        self.view.backgroundColor = .white
        self.recipes = DataManager.sharedInstance.getRecipes()
        self.allRecipes = self.recipes
        self.sortRecipes()
        
     
        let ketoBibleStr : String = StyleManager.titleString

        let ketoBibleText = NSMutableAttributedString(string: ketoBibleStr, attributes: [NSAttributedString.Key.font: StyleManager.topTitleFont!])
        if StyleManager.isKeto {
            ketoBibleText.addAttributes([ NSAttributedString.Key.font : StyleManager.topTitleFontBold! ], range: NSMakeRange(4, 4));
        } else {
            ketoBibleText.addAttributes([ NSAttributedString.Key.font : StyleManager.topTitleFontBold! ], range: NSMakeRange(4, 5));
        }
        ketoBibleText.addAttributes([NSAttributedString.Key.foregroundColor : StyleManager.mainColor], range: NSMakeRange(0, ketoBibleStr.count))
        
        titleLbl.attributedText = ketoBibleText
        self.view.addSubview(titleLbl)
        titleLbl.snp.makeConstraints{ (make) in make.top.equalTo(self.view.snp.top).offset(StyleManager.topOffset)
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        
        let searchIcon = UIImage(named: "searchIcon.pdf")
        let menuIcon = UIImage(named: "menuIcon.pdf")
        
        searchBtn.setImage(searchIcon, for: .normal)
        menuBtn.setImage(menuIcon, for: .normal)
    
        
        self.view.addSubview(searchBtn)
        self.searchBtn.snp.makeConstraints{ (make) in
            make.centerY.equalTo(self.titleLbl.snp.centerY)
            make.left.equalTo(self.view.snp.left).offset(20)
        }
        searchBtn.addTarget(self, action: #selector(searchIconTapped), for: .touchUpInside)
        
        self.view.addSubview(menuBtn)
        self.menuBtn.snp.makeConstraints{ (make) in
            make.centerY.equalTo(self.titleLbl.snp.centerY)
            make.right.equalTo(self.view.snp.right).offset(-20)
        }
        
        self.menuBtn.addTarget(self, action: #selector(menuButtonSelected), for: .touchUpInside)
        self.searchTextField.barTintColor = .white
        self.searchTextField.searchBarStyle = .minimal
        self.searchTextField.setImage(UIImage(named: "closeIcon"), for: .clear, state: .normal)
        self.searchTextField.setImage(UIImage(named: "searchIcon"), for: .search, state: .normal)
        self.searchTextField.endEditing(true)

        self.view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints{ (make) in
            make.width.equalTo(self.view.snp.width).offset(-20)
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.titleLbl.snp.centerY)
            make.height.equalTo(80)
        }
        self.searchTextField.isHidden = true
        self.searchTextField.delegate = self
        self.searchTextField.showsCancelButton = true
        
                
        self.scrollView = UIScrollView()
        self.scrollView.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ (make) in
            make.top.equalTo(self.titleLbl.snp.bottom)
            make.width.equalTo(self.view.snp.width)
            make.left.equalTo(self.view.snp.left)
            make.bottom.equalTo(self.view.snp.bottom)

        }
        
        if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 500)
        } else {
            scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 800)
        }
                
        self.exploreCatLbl.font = StyleManager.categoryFont
        self.exploreCatLbl.textColor = StyleManager.mainColor
        self.exploreCatLbl.text = "Explore Categories".uppercased()
        self.whatsNewLbl.font = StyleManager.categoryFont
        self.whatsNewLbl.textColor = StyleManager.mainColor
        self.whatsNewLbl.text = self.whatsNewText


        let leftRightOffset = 20
        self.scrollView.addSubview(exploreCatLbl)
        self.exploreCatLbl.snp.makeConstraints{ (make) in
            switch UIDevice().type {
            case .iPhone8, .iPhone7, .iPhone6S, .iPhone6, .iPhone8Plus, .iPhone7Plus, .iPhone6Plus, .iPhone6SPlus:
                make.top.equalTo(self.scrollView.snp.top).offset(20)
            case .iPhone5, .iPhone5S, .iPhone5C, .iPhoneSE:
                make.top.equalTo(self.scrollView.snp.top).offset(20)
            default:
                make.top.equalTo(self.scrollView.snp.top).offset(40)
            }
            make.left.equalTo(self.scrollView.snp.left).offset(leftRightOffset)
        }
        
        
        self.catLayout = UICollectionViewFlowLayout()
        self.catLayout.scrollDirection = .horizontal
        
        self.catCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.catLayout)
        self.catCollectionView.dataSource = self
        self.catCollectionView.delegate = self
        
        
        self.searchResultsCollection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.searchResultsCollection.dataSource = self
        self.searchResultsCollection.delegate = self
        self.searchResultsCollection.backgroundColor = .white
        self.searchResultsCollection.showsVerticalScrollIndicator = false
        self.searchResultsCollection .showsHorizontalScrollIndicator = false
        self.searchResultsCollection.keyboardDismissMode = .onDrag
        searchResultsCollection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        //self.hideKeyboardWhenTappedAround()
        
        self.catCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CatCell")
        self.searchResultsCollection.register(SearchRecipeCell.self, forCellWithReuseIdentifier: "SearchCell")

        
        
        self.catCollectionView.backgroundColor = .clear
        self.catLayout.minimumInteritemSpacing = 0
        self.catLayout.minimumLineSpacing = 20
        self.catCollectionView.showsVerticalScrollIndicator = false
        self.catCollectionView .showsHorizontalScrollIndicator = false

        
        self.scrollView.addSubview(searchResultsCollection)
        searchResultsCollection.snp.makeConstraints{ (make) in
            make.top.equalTo(self.searchTextField.snp.bottom).offset(40)
            make.left.equalTo(self.scrollView.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        self.searchResultsCollection.isHidden = true
        
        
        for label in [noResultsSearchLbl, noResultsFilterLbl] {
            label.textColor = StyleManager.mainColor
            label.font = StyleManager.noResultsFont
            label.text = "No results! \n Try another search."
            label.textAlignment = .center
            label.numberOfLines = 2
            label.changeFont(ofText: "No results!", with: StyleManager.noResultsFontBold!)
        }
        
        self.scrollView.addSubview(noResultsSearchLbl)
        noResultsSearchLbl.snp.makeConstraints{ (make) in
            make.top.equalTo(self.searchTextField.snp.bottom).offset(70)
            make.centerX.equalTo(self.scrollView.snp.centerX)
        }
        self.noResultsSearchLbl.isHidden = true

        
        
        
        self.scrollView.addSubview(catCollectionView)
        catCollectionView.snp.makeConstraints{ (make) in
            switch UIDevice().type {
            case .iPhone8, .iPhone7, .iPhone6S, .iPhone6:
                make.top.equalTo(self.exploreCatLbl.snp.bottom).offset(-35)
            case .iPhone8Plus, .iPhone7Plus, .iPhone6Plus, .iPhone6SPlus:
                make.top.equalTo(self.exploreCatLbl.snp.bottom).offset(-28)
            default:
                make.top.equalTo(self.exploreCatLbl.snp.bottom).offset(-10)
            }
            make.left.equalTo(self.exploreCatLbl.snp.left)
            make.right.equalTo(self.view.snp.right)
            if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
                make.height.equalTo(140)
            } else {
                make.height.equalTo(200)
            }
        }
        
        self.scrollView.addSubview(whatsNewLbl)
        self.whatsNewLbl.snp.makeConstraints{ (make) in
            switch UIDevice().type {
            case .iPhone8, .iPhone7, .iPhone6S, .iPhone6:
                make.top.equalTo(self.catCollectionView.snp.bottom).offset(-30)
            case .iPhone8Plus, .iPhone7Plus, .iPhone6Plus, .iPhone6SPlus:
                make.top.equalTo(self.catCollectionView.snp.bottom).offset(-25)
            default:
                make.top.equalTo(self.catCollectionView.snp.bottom).offset(-5)
            }
            make.left.equalTo(self.scrollView.snp.left).offset(leftRightOffset)
        }
        
        self.scrollView.addSubview(noResultsFilterLbl)
        noResultsFilterLbl.snp.makeConstraints{ (make) in
            make.top.equalTo(self.whatsNewLbl.snp.bottom).offset(40)
            make.centerX.equalTo(self.scrollView.snp.centerX)
        }
        self.noResultsFilterLbl.isHidden = true

        
        
        self.recipeLayout = UICollectionViewFlowLayout()
        self.recipeLayout.scrollDirection = .horizontal
        self.recipeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.recipeLayout)
        self.recipeCollectionView.dataSource = self
        self.recipeCollectionView.delegate = self
        
        self.recipeCollectionView.register(RecipeCell.self, forCellWithReuseIdentifier: "RecipeCell")

        
        self.recipeCollectionView.backgroundColor = .clear
        self.recipeLayout.minimumInteritemSpacing = 0
        self.recipeLayout.minimumLineSpacing = 20
        self.recipeCollectionView.showsVerticalScrollIndicator = false
        self.recipeCollectionView .showsHorizontalScrollIndicator = false
        self.recipeCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        
        self.scrollView.addSubview(recipeCollectionView)
        recipeCollectionView.snp.makeConstraints{ (make) in
            switch UIDevice().type {
            case .iPhone8, .iPhone7, .iPhone6S, .iPhone6:
                make.top.equalTo(self.whatsNewLbl.snp.bottom).offset(-20)
            case .iPhoneSE:
                make.top.equalTo(self.whatsNewLbl.snp.bottom).offset(-17)
            case .iPhone5S, .iPhone5C, .iPhone5:
                make.top.equalTo(self.whatsNewLbl.snp.bottom).offset(-10)
            default:
                make.top.equalTo(self.whatsNewLbl.snp.bottom).offset(10)
            }
            make.left.equalTo(self.whatsNewLbl.snp.left)
            make.right.equalTo(self.view.snp.right)
            if UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhone5 || UIDevice().type == .iPhoneSE {
                make.height.equalTo(277)
            } else if UIDevice().type == .iPhone11 || UIDevice().type == .iPhone12 || UIDevice().type == .iPhoneXSMax || UIDevice().type == .iPhoneXR ||  UIDevice().type == .iPhone11ProMax  || UIDevice().type == .iPhone12ProMax {
                make.height.equalTo(420)
            } else if StyleManager.isIpad() {
                make.height.equalTo(530)
            } else {
                make.height.equalTo(360)
            }
        }
        
        
        self.filtersLayout = UICollectionViewFlowLayout()
        self.filtersLayout.scrollDirection = .horizontal
        self.filtersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.filtersLayout)
        self.filtersCollectionView.dataSource = self
        self.filtersCollectionView.delegate = self
        
        self.filtersCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "FiltersCell")
        
        self.filtersCollectionView.backgroundColor = .clear
        self.filtersLayout.minimumInteritemSpacing = 8
        self.filtersLayout.minimumLineSpacing = 10
        self.filtersCollectionView.showsVerticalScrollIndicator = false
        self.filtersCollectionView .showsHorizontalScrollIndicator = false
        
        self.scrollView.addSubview(filtersCollectionView)
        filtersCollectionView.snp.makeConstraints{ (make) in
            switch UIDevice().type {
            case .iPhone8, .iPhone7, .iPhone6S, .iPhone6:
                make.top.equalTo(self.recipeCollectionView.snp.bottom).offset(-20)
            case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE:
                make.top.equalTo(self.recipeCollectionView.snp.bottom).offset(-20)
            case .iPhone8Plus, .iPhone7Plus, .iPhone6Plus, .iPhone6SPlus:
                make.top.equalTo(self.recipeCollectionView.snp.bottom).offset(5)
            default:
                make.top.equalTo(self.recipeCollectionView.snp.bottom).offset(20)
            }
            make.left.equalTo(self.scrollView.snp.left)
            make.right.equalTo(self.view.snp.right)
            if StyleManager.isIpad() {
                make.height.equalTo(85)
            } else {
                make.height.equalTo(55)
            }
        }
        filtersCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        
        for button in [filtersBtn, under15Btn, breakFast, lunch, dinner, snacks] {
            button.layer.cornerRadius = 9
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = StyleManager.filtersBtnFont
            button.backgroundColor = StyleManager.mainColor
            button.addShadowToButton()
        }
        
        under15Btn.setTitle("Under 15 Min", for: .normal)
        breakFast.setTitle("Breakfast", for: .normal)
        lunch.setTitle("Lunch", for: .normal)
        dinner.setTitle("Dinner", for: .normal)
        snacks.setTitle("Snacks", for: .normal)

        filtersBtn.addTarget(self, action: #selector(filtersPressed), for: .touchUpInside)
        under15Btn.addTarget(self, action: #selector(under15Pressed), for: .touchUpInside)
        breakFast.addTarget(self, action: #selector(breakfastPressed), for: .touchUpInside)
        lunch.addTarget(self, action: #selector(lunchPressed), for: .touchUpInside)
        dinner.addTarget(self, action: #selector(dinnerPressed), for: .touchUpInside)
        snacks.addTarget(self, action: #selector(snacksPressed), for: .touchUpInside)

        
        self.scrollView.addSubview(filterView)
        filterView.snp.makeConstraints{ (make) in
            make.edges.equalTo(self.view.snp.edges)
            //make.edges.equalTo(self.scrollView.snp.edges)
        }
        
        self.filterView.alpha = 0
        self.filterView.delegate = self
        
        iprogress.captionSize = 14
        iprogress.indicatorSize = 40
        iprogress.indicatorStyle = .pacman
        iprogress.boxSize = 40
        iprogress.isTouchDismiss = true
        iprogress.attachProgress(toView: self.view)
        
        if self.firstLaunch {
            self.checkForUpdates(first: self.firstLaunch)
            self.firstLaunch = false

        }
    }
    
    @objc func recipesLoaded() {
        self.recipes = DataManager.sharedInstance.getRecipes()
        self.allRecipes = self.recipes
        self.sortRecipes()
        
        DispatchQueue.main.async {
            self.recipeCollectionView.reloadData()
        }
    }
    
    @objc func checkForUpdates(first: Bool) {
        DataManager.sharedInstance.listenForRecipes(firstCall: first)
    }
    
    @objc func recipesUpdating() {
            view.updateCaption(text: "Updating Recipes..")
            view.showProgress()
    }
    
    
   @objc func recipesUpdated() {
       self.recipes = DataManager.sharedInstance.getRecipes()
       self.allRecipes = self.recipes
       self.sortRecipes()
        DispatchQueue.main.async {
            self.recipeCollectionView.reloadData()
        }
        self.view.dismissProgress()
   }
    
    func sortRecipes() {
        let df = DateFormatter()
        df.dateFormat = "MMMM dd, yyyy"
        df.locale = Locale(identifier: "en_US_POSIX")
        df.timeZone = TimeZone(identifier: "UTC")!
        
        if self.recipes != nil {
            self.recipes = self.recipes!.sorted {df.date(from: $0.date)! > df.date(from: $1.date)!}
        }
        
        if self.allRecipes != nil {
            self.allRecipes = self.allRecipes!.sorted {df.date(from: $0.date)! > df.date(from: $1.date)!}
        }
        
        
    }
    
    @objc func cantSyncWifi() {
        let errorView = MessageView.viewFromNib(layout: .cardView)
        errorView.configureTheme(.warning)
        errorView.configureDropShadow()
        errorView.button?.isHidden = true
        errorView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (errorView.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        errorView.configureContent(title: "Warning - Can't Sync", body: "Not connected via wifi - please change settings.")
        SwiftMessages.show(view: errorView)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == catCollectionView {
            
            if StyleManager.isIpad() {
                return CGSize(width: 300, height: 161)
            }
            
            switch UIDevice().type {
            case .iPhone8, .iPhone7, .iPhone6, .iPhone6S:
                return CGSize(width: 200, height: 107)
            case .iPhone8Plus, .iPhone7Plus, .iPhone6Plus, .iPhone6SPlus:
                return CGSize(width: 238, height: 128)
            case .iPhone5S, .iPhone5C, .iPhone5, .iPhoneSE:
                return CGSize(width: 180, height: 96)
            default:
                return CGSize(width: 266, height: 143)
            }
        } else if collectionView == filtersCollectionView {
          
            
            
            var height = 39
            var width = 70
            switch indexPath.row {
            case 0:
                width =  46
            case 1: width = 109
            case 2: width = 100
            default:
                width = 70
            }
            
            
            if StyleManager.isIpad() {
                width =  width + 50
                height = height + 25
            }
            
            return CGSize(width: width, height: height)
        } else if collectionView == searchResultsCollection {
            let width = (UIScreen.main.bounds.width / 2.0) - 30
            return CGSize(width: width, height: width)
        } else {
            
            if StyleManager.isIpad() {
                return CGSize(width: 400, height: 529)
            } else if UIDevice.current.type == .iPadPro4thGen2 || UIDevice.current.type == .iPadPro4thGen {
                return CGSize(width: 529, height: 700)
            }
            
            switch UIDevice().type {
            case .iPhone8, .iPhone7, .iPhone6S, .iPhone6:
                return CGSize(width: 227, height: 300)
            case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE:
                return CGSize(width: 170, height: 224)
            case .iPhone11, .iPhoneXSMax, .iPhoneXR, .iPhone11ProMax, .iPhone12ProMax, .iPhone12:
                return CGSize(width: 317, height: 420)
            default:
                return CGSize(width: 266, height: 352)
            }
            
        }
    }
    
    @objc func menuButtonSelected() {
        panel?.openLeft(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == catCollectionView {
            return 3
        } else if collectionView == filtersCollectionView {
            return 6
        } else if collectionView == searchResultsCollection{
            return searchResults.count
        }else {
            if self.recipes != nil {
                return self.recipes!.count
            }
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == filtersCollectionView {
            let filtersCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiltersCell", for: indexPath)
            
            if indexPath.row == 0 {
                filtersCell.addSubview(filtersBtn)
                filtersBtn.snp.makeConstraints{ (make) in
                    make.centerX.equalTo(filtersCell.snp.centerX)
                    make.centerY.equalTo(filtersCell.snp.centerY)
                    if StyleManager.isIpad() {
                        make.height.equalTo(58)
                        make.width.equalTo(86)
                    } else {
                        make.height.equalTo(38)
                        make.width.equalTo(46)
                    }

                }
                let imageView = UIImageView(image: UIImage(named: "FiltersIcon")?.withRenderingMode(.alwaysTemplate))
                filtersBtn.addSubview(imageView)
                filtersBtn.tintColor = .white
                imageView.snp.makeConstraints{ (make) in
                    make.centerX.equalTo(filtersCell.snp.centerX)
                    make.centerY.equalTo(filtersCell.snp.centerY)
                }
            } else if indexPath.row == 1 {
                filtersCell.addSubview(under15Btn)
                under15Btn.snp.makeConstraints{ (make) in
                    make.centerX.equalTo(filtersCell.snp.centerX)
                    make.centerY.equalTo(filtersCell.snp.centerY)
                    if StyleManager.isIpad() {
                        make.height.equalTo(58)
                        make.width.equalTo(149)
                    } else {
                        make.height.equalTo(38)
                        make.width.equalTo(109)
                    }

                }

            } else if indexPath.row == 2 {
                filtersCell.addSubview(breakFast)
                breakFast.snp.makeConstraints{ (make) in
                    make.centerX.equalTo(filtersCell.snp.centerX)
                    make.centerY.equalTo(filtersCell.snp.centerY)
                    if StyleManager.isIpad() {
                        make.height.equalTo(58)
                        make.width.equalTo(140)
                    } else {
                        make.height.equalTo(38)
                        make.width.equalTo(100)
                    }

                }

            } else if indexPath.row == 3 {
                filtersCell.addSubview(lunch)
                lunch.snp.makeConstraints{ (make) in
                    make.centerX.equalTo(filtersCell.snp.centerX)
                    make.centerY.equalTo(filtersCell.snp.centerY)
                    if StyleManager.isIpad() {
                        make.height.equalTo(58)
                        make.width.equalTo(110)
                    } else {
                        make.height.equalTo(38)
                        make.width.equalTo(70)
                    }

                }

            } else if indexPath.row == 4 {
                filtersCell.addSubview(dinner)
                dinner.snp.makeConstraints{ (make) in
                    make.centerX.equalTo(filtersCell.snp.centerX)
                    make.centerY.equalTo(filtersCell.snp.centerY)
                    if StyleManager.isIpad() {
                        make.height.equalTo(58)
                        make.width.equalTo(110)
                    } else {
                        make.height.equalTo(38)
                        make.width.equalTo(70)
                    }

                }
            }else if indexPath.row == 5 {
                filtersCell.addSubview(snacks)
                snacks.snp.makeConstraints{ (make) in
                    make.centerX.equalTo(filtersCell.snp.centerX)
                    make.centerY.equalTo(filtersCell.snp.centerY)
                    if StyleManager.isIpad() {
                        make.height.equalTo(58)
                        make.width.equalTo(110)
                    } else {
                        make.height.equalTo(38)
                        make.width.equalTo(70)
                    }
                }
            }
            
            return filtersCell

        } else if collectionView == searchResultsCollection {
            
            let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as! SearchRecipeCell
            if self.searchResults.count > 0 {
                let recipe = searchResults[indexPath.row]

                searchCell.updateForRecipe(recipe: recipe)
                //searchCell.hero.id = recipe.title
                
            }
            
            return searchCell
            
            
        }
         
        
        else if collectionView == catCollectionView {
            let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCell", for: indexPath)
            
            var catImageView : UIImageView!
            let catTitleLbl = UILabel()
            catTitleLbl.font = StyleManager.categoryLblFont
            catTitleLbl.textColor = .white
            catTitleLbl.numberOfLines = 1
            catTitleLbl.adjustsFontSizeToFitWidth = true
            

            switch indexPath.row {
            case TopCategory.christmas.rawValue:
                catImageView = UIImageView(image: UIImage(named: "christmas.jpeg"))
                catTitleLbl.text = "Keto During The Holidays"
            case TopCategory.carbSubstitutes.rawValue:
                catImageView = UIImageView(image: UIImage(named: "carbs.jpg"))
                catTitleLbl.text = "Carb Substitutes"
            case TopCategory.foodsToAvoid.rawValue:
                catImageView = UIImageView(image: UIImage(named: "avoid.jpg"))
                catTitleLbl.text = "Foods to Avoid"
            case TopCategory.eatingOut.rawValue:
                catImageView = UIImageView(image: UIImage(named: "eatingout.jpg"))
                catTitleLbl.text = "Eating out on Keto"
            case TopCategory.supplements.rawValue:
                catImageView = UIImageView(image: UIImage(named: "supplements.jpg"))
                catTitleLbl.text = "Supplements"
            default: print("default")
            }
            
            myCell.addSubview(catImageView)
            catImageView.clipsToBounds = true
            catImageView.layer.cornerRadius = 20
            catImageView.contentMode = .scaleAspectFill
            catImageView.snp.makeConstraints{ (make) in
                make.edges.equalTo(myCell.snp.edges)
            }
            
            let overlay: UIView = UIView(frame: CGRect(x: 0, y: 0, width: catImageView.frame.size.width, height: catImageView.frame.size.height))
            overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
            overlay.layer.cornerRadius = 20
            catImageView.addSubview(overlay)
            
            myCell.addSubview(catTitleLbl)
            catTitleLbl.snp.makeConstraints{ (make) in
                make.left.equalTo(catImageView.snp.left).offset(10)
                make.right.equalTo(catImageView.snp.right).offset(-10)
                make.bottom.equalTo(catImageView.snp.bottom).offset(-10)
            }
            
            
            
            
            return myCell

        } else {
            let recipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell
            if self.recipes != nil {
                let recipe = self.recipes![indexPath.item]
            
                recipeCell.updateForRecipe(recipe: recipe)
                recipeCell.hero.id = recipe.title

            }
            
            return recipeCell
            
        }
        
        
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filtersCollectionView {

        } else if collectionView == catCollectionView {
            switch indexPath.row {
            case TopCategory.christmas.rawValue:
                let vc = HolidayScreenVC()
                
                if self.panel!.center is UINavigationController {
                    (self.panel!.center as! UINavigationController).pushViewController(vc, animated: true)
                }
                //self.navigationController?.pushViewController(vc, animated: true)
            case TopCategory.carbSubstitutes.rawValue:
                let vc = CarbsSubsVC()
                if self.panel!.center is UINavigationController {
                    (self.panel!.center as! UINavigationController).pushViewController(vc, animated: true)
                }
                //self.navigationController?.pushViewController(vc, animated: true)
            case TopCategory.foodsToAvoid.rawValue:
                let vc = FoodsToAvoidVC()
                vc.showBackBtn = true
                if self.panel!.center is UINavigationController {
                    (self.panel!.center as! UINavigationController).pushViewController(vc, animated: true)
                }
                //self.navigationController?.pushViewController(vc, animated: true)
            case TopCategory.eatingOut.rawValue:
                let vc = EatingOutVC()
                if self.panel!.center is UINavigationController {
                    (self.panel!.center as! UINavigationController).pushViewController(vc, animated: true)
                }
                //self.navigationController?.pushViewController(vc, animated: true)
            case TopCategory.supplements.rawValue:
                let vc = SuppsVC()
                vc.showBackBtn = true
                if self.panel!.center is UINavigationController {
                    (self.panel!.center as! UINavigationController).pushViewController(vc, animated: true)
                }
                //self.navigationController?.pushViewController(vc, animated: true)

            default:
                print("default")
            }
        } else if collectionView == searchResultsCollection {
            var selectedRecipe : RecipeItem
            selectedRecipe = self.searchResults[indexPath.row]
            self.searchTextField.endEditing(true)
            let vc = RecipeVC()
            vc.recipe = selectedRecipe
            
            if selectedRecipe.isPro != nil && selectedRecipe.isPro! && !UserManager.shared.getHasPro() {
            
            PopupController.showPopup(ProPopup())
                
            } else {

                if self.panel != nil && self.panel!.center is UINavigationController {
                    (self.panel!.center as! UINavigationController).pushViewController(vc, animated: true)
                } else {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }

        }
        else {
            var selectedRecipe : RecipeItem
            if self.recipes != nil {
                selectedRecipe = self.recipes![indexPath.row]
                
                //check if Pro
                if selectedRecipe.isPro != nil && selectedRecipe.isPro! && !UserManager.shared.getHasPro() {
                    
                    PopupController.showPopup(ProPopup())
                } else {
                                        
                    let vc = RecipeVC()
                    vc.recipe = selectedRecipe

                    if self.panel != nil && self.panel!.center is UINavigationController {
                        (self.panel!.center as! UINavigationController).pushViewController(vc, animated: true)
                    } else {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            }
        }
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func filtersPressed() {
        
        self.resetPressed()
        
        if self.whatsNewLbl.text! == self.whatsNewText {
            self.whatsNewLbl.text = "Custom Search"

        } else {
            self.whatsNewLbl.text = self.whatsNewText
        }
        
        
        self.changeBtnState(button: filtersBtn, keepColor: true)
        let animation = AnimationType.from(direction: .bottom, offset: 30.0)
        filterView.animate(animations: [animation])
        
    }

    
    @objc func under15Pressed() {
        
        self.resetPressed()

        
        self.changeBtnState(button: under15Btn, keepColor: nil)
        if self.whatsNewLbl.text! == self.whatsNewText && under15Btn.isSelected {
            self.whatsNewLbl.text = "Under 15 Minutes"
            self.recipes = DataManager.sharedInstance.getRecipesUnder15()
            self.recipeCollectionView.reloadData()
        } else {
            self.whatsNewLbl.text = self.whatsNewText
            self.resetToAllRecipes()
        }
    }

    
    /*func loadBreakfastRecipes() {
        DataManager.sharedInstance.recipesUnder15Min(completion: { (under15Recipes) in
            self.recipesUnder15 = under15Recipes
        })
    } */
    
    func resetToAllRecipes() {
        self.recipes = self.allRecipes
        self.recipeCollectionView.scrollToItem(at: selectedPath, at: .init(), animated: true)
        self.recipeCollectionView.reloadData()
    }
    
    func changeBtnState(button: SpringButton, keepColor: Bool?) {
        if button.backgroundColor == .white && keepColor != nil && keepColor! {
            
        }else if !button.isSelected {
            button.isSelected = true
            
            //reset so only 1 is selected
            for button in [filtersBtn, under15Btn, breakFast, lunch, dinner,snacks] {
                if button.backgroundColor! == UIColor.white {
                    button.backgroundColor = StyleManager.mainColor
                    button.tintColor = .white
                    button.setTitleColor(.white, for: .normal)
                }
            }
            button.backgroundColor = .white
            button.tintColor = StyleManager.mainColor
            button.setTitleColor(StyleManager.mainColor, for: .normal)
        } else {
            button.isSelected = false
            button.backgroundColor = StyleManager.mainColor
            button.tintColor = .white
            button.setTitleColor(.white, for: .normal)
        }
    }
    
    
    @objc func breakfastPressed() {
        
        self.resetPressed()

        
        self.changeBtnState(button: breakFast, keepColor: nil)
        if self.whatsNewLbl.text! == self.whatsNewText && breakFast.isSelected {
            self.whatsNewLbl.text = "Breakfast Recipes"
            self.recipes = DataManager.sharedInstance.getBreakfastRecipes()
            self.recipeCollectionView.reloadData()
        } else {
            self.whatsNewLbl.text = self.whatsNewText
            self.resetToAllRecipes()
        }
    }

    
    @objc func lunchPressed() {
        
        self.resetPressed()

        
        self.changeBtnState(button: lunch, keepColor: nil)
        if self.whatsNewLbl.text! == self.whatsNewText && lunch.isSelected {
            self.whatsNewLbl.text = "Lunch Recipes"
            self.recipes = DataManager.sharedInstance.getLunchRecipes()
            self.recipeCollectionView.reloadData()
        } else {
            self.whatsNewLbl.text = self.whatsNewText
            self.resetToAllRecipes()
        }
    }
    
    @objc func dinnerPressed() {
        
        self.resetPressed()

        
        self.changeBtnState(button: dinner, keepColor: nil)
        if self.whatsNewLbl.text! == self.whatsNewText && dinner.isSelected {
            self.whatsNewLbl.text = "Dinner Recipes"
            self.recipes = DataManager.sharedInstance.getDinnerRecipes()
            self.recipeCollectionView.reloadData()
        } else {
            self.whatsNewLbl.text = self.whatsNewText
            self.resetToAllRecipes()
        }
    }
    
    @objc func snacksPressed() {
        self.resetPressed()

        
        self.changeBtnState(button: snacks, keepColor: nil)
        if self.whatsNewLbl.text! == self.whatsNewText && snacks.isSelected {
            self.whatsNewLbl.text = "Snack Recipes"
            self.recipes = DataManager.sharedInstance.getSnackRecipes()
            self.recipeCollectionView.reloadData()
        } else {
            self.whatsNewLbl.text = self.whatsNewText
            self.resetToAllRecipes()
        }
    }
    
    
    
    func resetPressed() {
        self.noResultsFilterLbl.isHidden = true
        self.changeBtnState(button: self.filtersBtn, keepColor: nil)
        self.filterView.fadeOut()
        self.recipes = self.allRecipes
        self.whatsNewLbl.text = self.whatsNewText
        self.recipeCollectionView.scrollToItem(at: selectedPath, at: .init(), animated: true)
        self.recipeCollectionView.reloadData()
        
    }
    
    
    func searchPressed(filteredRecipes: [RecipeItem]?) {
        //self.changeBtnState(button: self.filtersBtn)
        self.filterView.fadeOut()
        
        
        if filteredRecipes != nil {
            if filteredRecipes!.count <= 0 {
                self.noResultsFilterLbl.isHidden = false
                self.recipes?.removeAll()
            } else {
                self.noResultsFilterLbl.isHidden = true
                self.recipes = filteredRecipes
            }
        } else {
            self.noResultsFilterLbl.isHidden = false
            self.recipes?.removeAll()
        }
        
        self.recipeCollectionView.scrollToItem(at: selectedPath, at: .init(), animated: true)
        self.recipeCollectionView.reloadData()
     
    }

    @objc func searchIconTapped() {
        self.scrollView.isScrollEnabled = false
        self.exploreCatLbl.text = "SEARCHING FOR: "
        self.hideFilterBtns(hide: true)
    }
    
    func hideFilterBtns(hide: Bool) {
        self.filtersBtn.isHidden = hide
        self.breakFast.isHidden = hide
        self.lunch.isHidden = hide
        self.dinner.isHidden = hide
        self.snacks.isHidden = hide
        self.under15Btn.isHidden = hide
        self.whatsNewLbl.isHidden = hide
        self.searchResultsCollection.isHidden = !hide
        self.catCollectionView.isHidden = hide
        self.recipeCollectionView.isHidden = hide
        self.searchTextField.isHidden = !hide
        self.menuBtn.isHidden = hide
        self.whatsNewLbl.isHidden = hide
        self.searchBtn.isHidden = hide
        self.titleLbl.isHidden = hide
    }
    

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.hideFilterBtns(hide: false)
        self.searchTextField.text = ""
        self.searchResults.removeAll()
        self.searchResultsCollection.reloadData()
        self.noResultsSearchLbl.isHidden = true
        self.scrollView.isScrollEnabled = true
        self.searchTextField.resignFirstResponder()
        self.exploreCatLbl.text = "EXPLORE CATEGORIES"
    }
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.noResultsSearchLbl.isHidden = true
        self.scrollView.isScrollEnabled = false
        
        if searchText == "" {
            self.exploreCatLbl.text = "SEARCHING FOR: "
            self.searchResultsCollection.isHidden = true

        } else {
            self.exploreCatLbl.text = "SEARCHING FOR: " + searchBar.text!.uppercased()
            self.hideFilterBtns(hide: true)
            DataManager.sharedInstance.searchRecipes(searchTerm: searchText, searchBar: searchBar) { (results) in
                print("finished")
                if results != nil && results!.count > 0 {
                    self.noResultsSearchLbl.isHidden = true
                    self.searchResults = results!
                } else {
                    self.searchResults.removeAll()
                    self.noResultsSearchLbl.isHidden = false
                    self.scrollView.bringSubviewToFront(self.noResultsSearchLbl)
                }
                self.searchResultsCollection.reloadData()
            }
        }
    
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //self.searchResults.removeAll()
        //self.searchResultsCollection.reloadData()
        self.searchTextField.endEditing(true)
    }
    
    
    @objc func purchasedPro() {
        self.recipeCollectionView.reloadData()
    }
    
    
  

}




extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineHeightMultiple = 0.65
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range:  NSRange(location: 0, length: text.count))
            self.attributedText = attributeString
        }
    }
}

class VerticalAlignedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        var newRect = rect
        switch contentMode {
        case .top:
            newRect.size.height = sizeThatFits(rect.size).height
        case .bottom:
            let height = sizeThatFits(rect.size).height
            newRect.origin.y += rect.size.height - height
            newRect.size.height = height
        default:
            ()
        }
        
        super.drawText(in: newRect)
    }
}


extension UIView {
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}

extension UIButton {
    func addShadowToButton() {
    self.layer.applySketchShadow(
    color: .black,
    alpha: 0.5,
    x: 0,
    y: 3,
    blur: 6,
    spread: 0)
    
    }
}
