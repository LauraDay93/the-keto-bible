//
//  DataStructs.swift
//  The Keto Bible
//
//  Created by Laura Day on 12/2/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import DefaultsKit
import SwiftyJSON
import Kingfisher




struct RecipeItem: Codable {
    //IMPORTANT NOTE: IF ADDING A NEW FIELD..MAKE OPTIONAL OR IT WILL LOG THE USER OUT & CLEAR DATA
    
    let title: String
    var categories: [String]?
    var avoidances: [String]?
    var imageUrl : URL?
    let nutritional : Nutritional
    let cookingTime: Int
    let prepTime: Int
    let servings: Int
    let ingredID : String?
    let steps : [String]?
    let instaHandle : String?
    let date : String
    let useWebsite: Bool?
    let websiteLink : String?
    var ingredientsList : Bool?
    var whiteText : Bool?
    var isPro : Bool?




    init(title : String, categories : [String]?, avoidances: [String]?, imageUrl: URL?, nutritional: Nutritional, cookingTime: Int, prepTime: Int, servings: Int, ingredID:  String?, steps: [String]?, instaHandle: String?, date: String, useWebsite: Bool?, websiteLink: String?, whiteText: Bool?, isPro: Bool?) {
        self.title = title
        self.imageUrl = imageUrl
        self.categories = categories
        self.avoidances = avoidances
        self.nutritional = nutritional
        self.cookingTime = cookingTime
        self.prepTime = prepTime
        self.servings = servings
        self.ingredID = ingredID
        self.steps = steps
        self.instaHandle = instaHandle
        self.date = date
        self.useWebsite = useWebsite
        self.websiteLink = websiteLink
        self.ingredientsList = false
        if whiteText != nil {
            self.whiteText = whiteText
        } else {
            self.whiteText = false
        }
        self.isPro = isPro
    }
    
}

struct Nutritional: Codable {
    let carbs: Double
    let netCarbs: Double
    let calories: Double
    let protein: Double
    let fat: Double
    let satFat: Double
    let fibre: Double
    let sodium: Double
    let cholesterol: Double
    
    
    init(carbs : Double, netCarbs: Double, calories : Double, protein: Double, fat: Double, satFat: Double, fibre: Double, sodium: Double, cholesterol: Double) {
        self.carbs = carbs
        self.netCarbs = netCarbs
        self.calories = calories
        self.protein = protein
        self.fat = fat
        self.satFat = satFat
        self.fibre = fibre
        self.sodium = sodium
        self.cholesterol = cholesterol
    }
    
}




struct Ingredient: Codable {
    let name: String
    var imageUrl : String?
    var inGroceryList : Bool?
}


struct Step: Codable {
    let name: String
    let nameKey: String
    let stepNumber : String
    let description : String
    
}
