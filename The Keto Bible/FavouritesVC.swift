//
//  FavouritesVC.swift
//  The Keto Bible
//
//  Created by Laura Day on 8/5/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring

class FavouritesVC : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var titleLbl = UILabel()

    var menuBtn = SpringButton()

    
    var favsCollectionView : UICollectionView!
    var favsLayout : UICollectionViewFlowLayout!

    var favourites : [RecipeItem]!
    
    let emptyView = EmptyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        self.view.backgroundColor = .white
        
        //for now..
        self.favourites = DataManager.sharedInstance.getFavs()
        
        NotificationCenter.default.addObserver(self, selector: #selector(favsUpdated), name: DataManager.favsUpdated, object: nil)

        
        
        self.favsLayout = UICollectionViewFlowLayout()
        self.favsLayout.scrollDirection = .vertical
        self.favsLayout.minimumInteritemSpacing = 0
        self.favsLayout.minimumLineSpacing = 30
        self.favsLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.favsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.favsLayout)
        self.favsCollectionView.dataSource = self
        self.favsCollectionView.delegate = self
        
        self.favsCollectionView.register(FavouritesCell.self, forCellWithReuseIdentifier: "favsCell")
        
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

        
       
        
        let favsTitle = UILabel()
        favsTitle.text = "Your Favourites"
        favsTitle.textColor = UIColor(red:0.23, green:0.23, blue:0.23, alpha:1.00)
        favsTitle.font = StyleManager.ingredLblFont
        self.view.addSubview(favsTitle)
        favsTitle.snp.makeConstraints { (make) in
            switch UIDevice().type {
            case .iPhone8, .iPhone7, .iPhone6S, .iPhone6, .iPhoneSE, .iPhone5, .iPhone5C, .iPhone5S:
                make.top.equalTo(self.titleLbl.snp.bottom).offset(20)
            default:
                make.top.equalTo(self.titleLbl.snp.bottom).offset(40)
            }
            make.left.equalTo(self.view.snp.left).offset(20)
        }
        
        self.favsCollectionView.backgroundColor = .white
        self.view.addSubview(favsCollectionView)
        favsCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(favsTitle.snp.bottom)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }

        
        self.view.addSubview(emptyView)
        emptyView.setupView(image: UIImage(named: "favsEmpty")!, title: "Your List is Empty", description: "Add recipes to your favourites and never lose track!")
        emptyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLbl.snp.bottom).offset(80)
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.bottom.equalTo(self.view.snp.bottom)
        }
        emptyView.isHidden = true

        if self.favourites == nil || self.favourites.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
         
        
    }
    
    @objc func menuButtonSelected() {
        panel?.openLeft(animated: true)
    }
    
    
    @objc func favsUpdated() {
        self.favourites = DataManager.sharedInstance.getFavs()
        
        
        if self.favourites == nil || self.favourites.count == 0 {
            emptyView.isHidden = false
        } else {
            emptyView.isHidden = true
        }
        
        self.favsCollectionView.reloadData()
        
    }
    @objc func backBtnPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C {
            return CGSize(width: UIScreen.main.bounds.width, height: 130)
        } else {
            return CGSize(width: UIScreen.main.bounds.width, height: 170)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.favourites != nil {
            return self.favourites!.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favsRecipe = self.favourites[indexPath.row]
        
        let favsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "favsCell", for: indexPath) as! FavouritesCell
        favsCell.updateCellForItem(recipe: favsRecipe)
        
        return favsCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var selectedRecipe : RecipeItem
        if self.favourites != nil {
            selectedRecipe = self.favourites![indexPath.row]
            let vc = RecipeVC()
            vc.recipe = selectedRecipe
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
