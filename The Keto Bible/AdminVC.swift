//
//  AdminVC.swift
//  The Keto Hack
//
//  Created by Laura Day on 18/11/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import Spring
import Firebase
import FirebaseFirestore
import SnapKit


class AdminVC : UIViewController, UIScrollViewDelegate {
    
    var scrollView : UIScrollView!
    
    let titleTxtField = UITextField()
    let handleTxTField = UITextField()
    let servingsTxtField = UITextField()
    let prepTimesTxtField = UITextField()
    let cookTimeTxtField = UITextField()
    let nutritionalIDTxTfield = UITextField()
    let imageURLTxtField = UITextField()
    
    let categoryArray = UITextField()
    let avoidancesArray = UITextField()
    
    let stepsArray = UITextField()
    
    var addBtn = SpringButton()

    
    private let db = Firestore.firestore()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.backgroundColor = .white
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ (make) in
            make.left.equalTo(self.view.snp.left)
            make.right.equalTo(self.view.snp.right)
            make.top.equalTo(self.view.snp.top)
            make.bottom.equalTo(self.view.snp.bottom)

        }

        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 3000)
        
        let topTitleLbl = UILabel()
        topTitleLbl.text = "Add Recipe"
        topTitleLbl.font = StyleManager.topTitleFont
        topTitleLbl.textColor = .black
        
        self.scrollView.addSubview(topTitleLbl)
        topTitleLbl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.scrollView.snp.top).offset(50)
        }
        
        
        titleTxtField.placeholder = "Title"
        titleTxtField.font = StyleManager.tipsDescFont
        titleTxtField.textColor = .black
               
        self.scrollView.addSubview(titleTxtField)
        titleTxtField.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView.snp.left) .offset(20)
            make.top.equalTo(topTitleLbl.snp.bottom).offset(15)
        }
        
        handleTxTField.placeholder = "Handle"
        handleTxTField.font = StyleManager.tipsDescFont
        handleTxTField.textColor = .black
               
        self.scrollView.addSubview(handleTxTField)
        handleTxTField.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView.snp.left) .offset(20)
            make.top.equalTo(self.titleTxtField.snp.bottom).offset(15)
        }
        
        
        servingsTxtField.placeholder = "Servings"
               servingsTxtField.font = StyleManager.tipsDescFont
               servingsTxtField.textColor = .black
                      
               self.scrollView.addSubview(servingsTxtField)
               servingsTxtField.snp.makeConstraints { (make) in
                   make.left.equalTo(self.scrollView.snp.left) .offset(20)
                   make.top.equalTo(self.handleTxTField.snp.bottom).offset(15)
               }
        
        prepTimesTxtField.placeholder = "Prep Time"
        prepTimesTxtField.font = StyleManager.tipsDescFont
        prepTimesTxtField.textColor = .black
               
        self.scrollView.addSubview(prepTimesTxtField)
        prepTimesTxtField.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView.snp.left) .offset(20)
            make.top.equalTo(self.servingsTxtField.snp.bottom).offset(15)
        }
        
        cookTimeTxtField.placeholder = "Cook Time"
        cookTimeTxtField.font = StyleManager.tipsDescFont
        cookTimeTxtField.textColor = .black
               
        self.scrollView.addSubview(cookTimeTxtField)
        cookTimeTxtField.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView.snp.left) .offset(20)
            make.top.equalTo(self.prepTimesTxtField.snp.bottom).offset(15)
        }
        
        nutritionalIDTxTfield.placeholder = "NutritionID"
        nutritionalIDTxTfield.font = StyleManager.tipsDescFont
        nutritionalIDTxTfield.textColor = .black
               
        self.scrollView.addSubview(nutritionalIDTxTfield)
        nutritionalIDTxTfield.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView.snp.left) .offset(20)
            make.top.equalTo(self.cookTimeTxtField.snp.bottom).offset(15)
        }
        
        imageURLTxtField.placeholder = "Image URL"
        imageURLTxtField.font = StyleManager.tipsDescFont
        imageURLTxtField.textColor = .black
               
        self.scrollView.addSubview(imageURLTxtField)
        imageURLTxtField.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView.snp.left) .offset(20)
            make.top.equalTo(self.nutritionalIDTxTfield.snp.bottom).offset(15)
        }
        
        categoryArray.placeholder = "Categories"
        categoryArray.font = StyleManager.tipsDescFont
        categoryArray.textColor = .black
               
        self.scrollView.addSubview(categoryArray)
        categoryArray.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView.snp.left) .offset(20)
            make.top.equalTo(self.imageURLTxtField.snp.bottom).offset(15)
        }
        
        avoidancesArray.placeholder = "Avoidances"
        avoidancesArray.font = StyleManager.tipsDescFont
        avoidancesArray.textColor = .black
               
        self.scrollView.addSubview(avoidancesArray)
        avoidancesArray.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView.snp.left) .offset(20)
            make.top.equalTo(self.categoryArray.snp.bottom).offset(15)
        }
        
        stepsArray.placeholder = "Steps:"
        stepsArray.font = StyleManager.tipsDescFont
        stepsArray.textColor = .black

        self.scrollView.addSubview(stepsArray)
        stepsArray.snp.makeConstraints { (make) in
            make.left.equalTo(self.scrollView.snp.left) .offset(20)
            make.top.equalTo(self.avoidancesArray.snp.bottom).offset(15)
            make.width.equalTo(self.view.snp.width).offset(-100)
            make.height.equalTo(200)
        }
       
        self.addBtn.backgroundColor = .black
        self.addBtn.setTitle("Add Recipe", for: .normal)
        self.addBtn.setTitleColor(.white, for: .normal)
        self.addBtn.layer.cornerRadius = 5
        self.scrollView.addSubview(self.addBtn)
        self.addBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.stepsArray.snp.bottom).offset(15)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(170)
            make.height.equalTo(87)
        }
        self.addBtn.addTarget(self, action: #selector(addData), for: .touchUpInside)
        
    }
    
    
    @objc func addData() {
 
        let categories = ["dinner"]
        
        let steps = ["Using a grater, grate the zest, scraping each section only once.",
                     "Heat 1 tsp oil in a non-stick pan to medium.",
                     "Sprinkle the skin side of the fish with sea salt flakes, and sprinkle zest on top.",
                     "Cook skin side down for 4-5 minutes, until about 70% cooked.",
                     "Turn and cook for another 3-5 minutes, test with a fork if it flakes easy. Should be slightly pink in the middle.",
                     "Squeeze fresh lemon on top.",
                     "Place cauliflower, salt, olive oil in a blender and whip until it reaches a puree consistency.",
                     "Serve with salmon and enjoy!"
        ]
        
        let avoidances = ["dairy"]
       
        let ID = "salmoncaulipuree"
        
        let ingred = ["150g salmon fillet",
                      "1 lemon",
                      "1 tsp lemon rind",
                      "2 cups cauliflower, steamed",
                      "1 tbsp olive oil",
                      "sea salt",
                      "chopped chives, for topping"
        ]
        
        let ingredImg = ["https://firebasestorage.googleapis.com/v0/b/the-keto-bible.appspot.com/o/salmonfillets.jpg?alt=media&token=1ea188e8-f671-4032-a60f-e922fc8788d3",
                         "https://firebasestorage.googleapis.com/v0/b/the-keto-bible.appspot.com/o/lemon.jpg?alt=media&token=fab82538-f86a-4ba6-a6f6-749f93f44a67",
                         "https://firebasestorage.googleapis.com/v0/b/the-keto-bible.appspot.com/o/lemonzest.jpeg?alt=media&token=89b61e7b-e0ad-4198-82ca-4dba8d0790e7",
                         "https://firebasestorage.googleapis.com/v0/b/the-keto-bible.appspot.com/o/cauliflower.jpeg?alt=media&token=6a5de9a9-8a34-4cdc-a6e1-a077989b9ca0",
                         "https://firebasestorage.googleapis.com/v0/b/the-keto-bible.appspot.com/o/oliveOil.jpeg?alt=media&token=d8203f6b-4693-40a2-bd05-b79696562433",
                         "https://firebasestorage.googleapis.com/v0/b/the-keto-bible.appspot.com/o/salt.png?alt=media&token=a0f9e4b1-6728-41b8-81e9-2a2c91b8c510",
                         "https://firebasestorage.googleapis.com/v0/b/the-keto-bible.appspot.com/o/chives.jpeg?alt=media&token=be60b92f-9473-4014-8bed-c20000b6a27f"
        ]
        
        let docData: [String: Any] = [
            "title": "Salmon Fillet & Cauli Puree",
            "active": true,
            "usewebsite": false,
            "website": "",
            "prepTime": 5,
            "servings": 1,
            "cookingTime": 10,
            "nutritionalID": ID,
            "ingredID": ID,
            "isPro": false,
            "imageURL": "https://firebasestorage.googleapis.com/v0/b/the-keto-bible.appspot.com/o/Salmon%26CauliPuree%20(1).jpg?alt=media&token=21c6c40f-f4d2-476d-b053-ab5391495c4c",
            "handle": "theketohack",
            "order": Timestamp(date: Date()),
            "steps": steps,
            "category": categories,
            "avoidances": avoidances,
        ]
        db.collection("recipe").document(ID).setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        let docData2: [String: Any] = [
            "calories":386,
            "carbs":11,
            "cholesterol":66,
            "fat": 23,
            "fibre":5,
            "netcarbs":6,
            "protein":36,
            "satFat":4,
            "sodium":2491
        ]
        
        db.collection("nutritionals").document(ID).setData(docData2) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }

        
        let docData3: [String: Any] = [
            "imageURLS": ingredImg,
            "titles": ingred,
        ]
        
        db.collection("recIngredients").document(ID).setData(docData3) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }

    }
}
