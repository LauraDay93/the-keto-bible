//
//  DataManager.swift
//  The Keto Bible
//
//  Created by Laura Day on 17/2/19.
//  Copy6ight © 2019 Laura Day. All rights reserved.
//

import Foundation
import UIKit
import DefaultsKit

import Firebase
import FirebaseAuth
import Fuse
import FirebaseFirestore


class DataManager: NSObject {

    static let ReachabilityChanged = NSNotification.Name(rawValue: "ReachabilityChanged")

    static let sharedInstance = DataManager()
    private let defaults = Defaults.shared
    
    private var recipes : [RecipeItem]?
    private var recipesUnder15 : [RecipeItem]?
    private var breakfastRecipes : [RecipeItem]?
    private var lunchRecipes : [RecipeItem]?
    private var dinnerRecipes : [RecipeItem]?
    private var snackRecipes : [RecipeItem]?
    private let db = Firestore.firestore()
    private var currentIngredients : [Ingredient]?

    private let cachedRecipes = Key<[RecipeItem]>("cached_recipes")

    private var recipesByIngredients : [String: [String]]?
    private let recipesByIngredientsKey = Key<[String:[String]]>("recipesByIngredients")

    static let recipesLoaded = NSNotification.Name(rawValue: "RecipesLoaded")
    static let recipesUpdating = NSNotification.Name(rawValue: "RecipesUpdating")
    static let recipesUpdated = NSNotification.Name(rawValue: "RecipesUpdated")

    static let ingredientsLoaded = NSNotification.Name(rawValue: "IngredientsLoaded")

    private let favRecipesKey = Key<[RecipeItem]>("recipes")
    private let listRecipesKey = Key<[String: [Ingredient]]>("listRecipes")
    private var favs : [RecipeItem]?
    static let favsUpdated = NSNotification.Name(rawValue: "FavsUpdated")
    static let listUpdated = NSNotification.Name(rawValue: "ListUpdated")
    static let browseAllPressed = NSNotification.Name(rawValue: "BrowseBtnPressed")

    private var groceryList : [String: [Ingredient]]?

    public var shownGroceryMessage : Bool = false
    
    static var privacyPolicyURL : URL {
        if StyleManager.isKeto {
            return URL(string: "https://www.ladapps.com/ketohack/privacy-policy.html")!
        } else {
            return URL(string: "https://www.ladapps.com/veganhack/privacy-policy.html")!
        }
    }
    

    /* REACHABILITY */
    /* Reachability removed; using NetworkMonitor */
    var internetConnection = NetworkMonitor.shared.isConnected

    private var searchBarText : String?

    
    private override init() {
        super.init()
        
        DispatchQueue.global(qos: .background).async {
            self.loadCachedRecipes()
            //self.loadFilters()
        }

        /*//storage = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig)
        storage = try? Storage(
            diskConfig: diskConfig,
            memoryConfig: memoryConfig,
            transformer: TransformerFactory.forCodable(ofType: Data.self) // Storage<User>
        ) */
    }
    
    
    private func updateFavourites() {
        if self.favs != nil && (self.favs!.count > 0){
            defaults.set(self.favs!, for: favRecipesKey)
        } else {
            defaults.clear(favRecipesKey)
        }
        
    }
    
    private func updateList() {
        if self.groceryList != nil && (self.groceryList!.count > 0){
            defaults.set(self.groceryList!, for: listRecipesKey)
        } else {
            defaults.clear(listRecipesKey)
        }
        
    }
    
    func addFavourite(fav: RecipeItem) {
        if self.favs != nil {
            self.favs?.append(fav)
        } else {
            self.favs = [RecipeItem]()
            self.favs?.append(fav)
        }
        self.updateFavourites()
        NotificationCenter.default.post(name: DataManager.favsUpdated, object: nil)
    }
    
    func addToGroceryList(title: String, ingredients: [Ingredient]) {
        if self.groceryList != nil {
            self.groceryList![title] = ingredients
        } else {
            self.groceryList = [String: [Ingredient]]()
            self.groceryList![title] = ingredients
        }
        self.updateList()
        NotificationCenter.default.post(name: DataManager.listUpdated, object: nil)
    }
    
    func markIngredientAdded(title: String, ingredList: [Ingredient], ingredient: Ingredient) {
        
        var indexNum = 0
        var list = ingredList
        for item in list {
            if item.name == ingredient.name {
                var ingred = item
                ingred.inGroceryList = false
                list[indexNum] = ingred
            }
            indexNum += 1
            
        }
        if groceryList != nil {
            groceryList![title] = list
        }
        self.updateList()
        NotificationCenter.default.post(name: DataManager.listUpdated, object: nil)
    }
    
    func markIngredientRemoved(title: String, ingredList: [Ingredient], ingredient: Ingredient) {
          var indexNum = 0
          var list = ingredList
          for item in list {
              if item.name == ingredient.name {
                  var ingred = item
                  ingred.inGroceryList = true
                  list[indexNum] = ingred
              }
            indexNum += 1

          }
          if groceryList != nil {
              groceryList![title] = list
          }
          self.updateList()
          NotificationCenter.default.post(name: DataManager.listUpdated, object: nil)
      }
    
    func removeAllFavs() {
        self.favs = nil
        self.updateFavourites()
    }
    
    func clearList() {
        self.groceryList = nil
        self.updateList()
    }
    
    func removeFavourite(favRemove: RecipeItem) {
        if self.favs != nil {
            
            for (index, item) in self.favs!.enumerated() {
                if item.title == favRemove.title {
                    self.favs?.remove(at: index)
                    NotificationCenter.default.post(name: DataManager.favsUpdated, object: nil)
                    self.updateFavourites()
                    return
                }
            }
        } else {
            print("error: favs empty")
        }
        
    }
    
    func removeGroceryListItem(listRemove: String) {
        if self.groceryList != nil {
            
            self.groceryList?.removeValue(forKey: listRemove)
            NotificationCenter.default.post(name: DataManager.listUpdated, object: nil)
            self.updateList()
            
        } else {
            print("error: list empty")
        }
        
    }
    
    func removeAllGrocery() {
        self.groceryList?.removeAll()
        self.updateList()
    }
    
    func getFavs() -> [RecipeItem]? {
        if(self.favs == nil && defaults.has(favRecipesKey)) {
            self.favs = defaults.get(for: favRecipesKey)
        
        }
        
        
        return self.favs
    }
    
    func getGroceryList() -> [String: [Ingredient]]? {
        if(self.groceryList == nil && defaults.has(listRecipesKey)) {
            self.groceryList = defaults.get(for: listRecipesKey)
        
        }
        
        return self.groceryList
    }
    
    func registerUser() {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.url = URL(string: "the-keto-bible.firebaseapp.com")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        //let provider = FUIEmailAuth.initAuthAuthUI(FUIAuth.defaultAuthUI(), signInMethod: FIREmailLinkAuthSignInMethod, forceSameDevice: false, allowNewEmailAccounts: true, actionCodeSetting: actionCodeSettings)

    }
    
    func parseRecipeData(snapshot: [QueryDocumentSnapshot], completion: (([RecipeItem] ) -> Void)?) {
        
        var queriedRecipes = [RecipeItem]()
        var index = 0
        for recipe in snapshot {

          let recipeData  = recipe.data()
            var nutritional : Nutritional?
            let imgURL = URL(string:  recipeData["imageURL"] as! String)
            let nutritionID = recipeData["nutritionalID"] as! String
            let nutritionalInfo = db.collection("nutritionals").document(nutritionID)
            
            
            nutritionalInfo.getDocument { (nutritionInfo, error) in
                if let nutritionInfo = nutritionInfo, nutritionInfo.exists {
                    let carbs = Double(nutritionInfo["carbs"] as! Double)
                    let netCarbs = Double(nutritionInfo["netcarbs"] as! Double)
                    let calories = Double(nutritionInfo["calories"] as! Double)
                    let protein = Double(nutritionInfo["protein"] as! Double)
                    let fat = Double(nutritionInfo["fat"] as! Double)
                    let satFat = Double(nutritionInfo["satFat"] as! Double)
                    let fibre = Double(nutritionInfo["fibre"] as! Double)
                    let sodium = Double(nutritionInfo["sodium"] as! Double)
                    let cholesterol = Double(nutritionInfo["cholesterol"] as! Double)
                    
                    
                    
                    nutritional = Nutritional(carbs : carbs, netCarbs: netCarbs, calories : calories, protein: protein, fat: fat, satFat: satFat, fibre: fibre, sodium: sodium, cholesterol: cholesterol)
                    
                    
                    let title = recipeData["title"] as! String
                    let cookingTime = recipeData["cookingTime"] as! Int
                    let prepTime = recipeData["prepTime"] as! Int
                    let servings = recipeData["servings"] as! Int
                    
                    
                    let allCategories = recipe["category"] as! [String]
                    let avoidances = recipe["avoidances"] as! [String]
                    let steps = recipe["steps"] as! [String]

                    
                    let ingredID = recipeData["ingredID"] as! String
                    
                    let instaHandle = recipeData["handle"] as? String
                    
                    let timestamp = recipeData["order"] as! Timestamp
                    let dayTimePeriodFormatter = DateFormatter()
                    dayTimePeriodFormatter.dateFormat = "MMMM dd, yyyy"
                    
                    
                    let dateString = dayTimePeriodFormatter.string(from: timestamp.dateValue() as Date)

 
                    let useWebsite = recipeData["usewebsite"] as? Bool

                    var websiteURL : String?
                    if useWebsite != nil && useWebsite == true {
                        websiteURL = recipeData["website"] as? String
                    }
                    
                    var whiteText = recipeData["whiteText"] as? Bool
                    if whiteText != nil {
                        whiteText = recipeData["whiteText"] as? Bool
                    } else {
                        whiteText = false
                    }
                    
                    var  isPro = recipeData["isPro"] as? Bool
                    if isPro != nil && isPro == true {
                        isPro = true
                    } else {
                        isPro = false
                    }
 
                    let newRecipe = RecipeItem(title : title, categories : allCategories, avoidances: avoidances, imageUrl: imgURL!, nutritional: nutritional!, cookingTime: cookingTime, prepTime: prepTime, servings: servings, ingredID: ingredID, steps: steps, instaHandle: instaHandle, date: dateString, useWebsite: useWebsite, websiteLink: websiteURL, whiteText: whiteText, isPro: isPro)

                            
                    if newRecipe != nil {
                        queriedRecipes.append(newRecipe!)
                    }
                            

                    if (index + 1) ==  snapshot.count {
                        NotificationCenter.default.post(name: DataManager.recipesLoaded, object: nil)
                        completion?(queriedRecipes)
                    }
                        
                } else {
                    print("Document does not exist")
                }
                index += 1

            }
        }
        
    }
    
    private func updateRecipes(recipesByIngredients :[String:[String]]) {
        if(recipesByIngredients.count > 0) {
            defaults.set(recipesByIngredients, for: recipesByIngredientsKey)
            self.recipesByIngredients = recipesByIngredients;
        }
    }
    
    func searchRecipes(searchTerm : String, searchBar : UISearchBar!, completion: (([RecipeItem]?) -> Void)?) {
        
        var results = [RecipeItem]()
        if recipes  != nil {
            for recipe in recipes! {
                if recipe.title.contains(searchTerm) {
                    results.append(recipe)
                }
            }
            completion?(results)
        } else {
            completion?(nil)

        }
        
    }
        
    
    func getIngredientsFromStrings(ingredID: String, completion: (([Ingredient] ) -> Void)?) {
        
        self.currentIngredients = [Ingredient]()
        var recipeIngredients = [Ingredient]()
        var count = 0
        var indexCount = 0

        
        let ingredInfo = self.db.collection("recIngredients").document(ingredID)
        ingredInfo.getDocument { (ingredInfo, error) in
            if let ingredInfo = ingredInfo, ingredInfo.exists {
                let titles = ingredInfo["titles"] as! [String]
                let imageURLS = ingredInfo["imageURLS"] as! [String]
                
                count = titles.count
                
                for (index,item) in  titles.enumerated() {
                    let ingredient = Ingredient(name: item, imageUrl: imageURLS[index], inGroceryList: true)
                    recipeIngredients.append(ingredient)
                    
                    if (indexCount + 1) == count {
                        completion?(recipeIngredients)
                        self.currentIngredients = nil
                    }
                    indexCount += 1
                }
                
                
            }
            
        }
        
        

    }
    
    func listenForRecipes(firstCall: Bool) {
 
        DispatchQueue.global(qos: .background).async {
    
            self.db.collection("recipe")
                .addSnapshotListener(includeMetadataChanges: false) { (querySnapshot, error) in
                    guard let snapshot = querySnapshot else {
                        print("Error retreiving snapshots \(error!)")
                        return
                    }
        
                    if snapshot.documentChanges(includeMetadataChanges: false).count > 0 {
                        //there's an update
                        NotificationCenter.default.post(name: DataManager.recipesUpdating, object: nil)

                               self.loadAllRecipesFromFirebase { (recipes) in
                                   NotificationCenter.default.post(name: DataManager.recipesUpdated, object: nil)
                              }
        }
        
        //there's an update
        NotificationCenter.default.post(name: DataManager.recipesUpdating, object: nil)

        self.loadAllRecipesFromFirebase { (recipes) in
            NotificationCenter.default.post(name: DataManager.recipesUpdated, object: nil)
        }
        
    }
        }
            
 

    }
    
    
    func loadAllRecipesFromFirebase(completion: (([RecipeItem] ) -> Void)?) {
        
        if UserManager.shared.getWifiSync() && !NetworkMonitor.shared.isOnWifi {
            return
        }
        
        
        if self.recipes == nil {
            self.recipes = [RecipeItem]()
        }
        
        let db = Firestore.firestore()

        
        db.collection("recipe")
        .whereField("active", isEqualTo: true)
            .getDocuments()
            { (querySnapshot, err) in
            if let err = err {
                print("Error getting documerants: \(err)")
            } else {
                if querySnapshot != nil {
                    self.parseRecipeData(snapshot: querySnapshot!.documents, completion: { (queriedRecipes) in
                        self.recipes = queriedRecipes
                        NotificationCenter.default.post(name: DataManager.recipesLoaded, object: nil)
                        self.saveFeedToCache()
                        self.loadFilters()
                        completion?(self.recipes!)
                    })
                }
                
            }
        }
    }
    

    
    func saveFeedToCache() {
        defaults.set(recipes as! [RecipeItem], for: cachedRecipes)
    }
    
    func loadCachedRecipes() {
        self.recipes = self.defaults.get(for: self.cachedRecipes)
        NotificationCenter.default.post(name: DataManager.recipesLoaded, object: nil)
    }
    
    func initalizeReachabilityListener() {
    // Switched to NWPathMonitor
    NetworkMonitor.shared.onStatusChange = { [weak self] connected in
        guard let self = self else { return }
        self.internetConnection = connected
        NotificationCenter.default.post(name: DataManager.ReachabilityChanged, object: nil)
    }
    NetworkMonitor.shared.start()
}

    
    
    @objc func reachabilityChanged(note: NSNotification) {
    // Deprecated; NWPathMonitor handles status updates.
    internetConnection = NetworkMonitor.shared.isConnected
}
 else {
                print("Reachable via Cellular")
            }
        } else {
            internetConnection = false
            print("Network not reachable")
        }
    }
    
    func setupReachability() {
    // Deprecated; kept for backward compatibility. Use initalizeReachabilityListener().
    initalizeReachabilityListener()
}
 else {
                self.internetConnection = false
            }
        }
        
        reachability.unreachableBlock = { (reachability) in
            if reachability!.isReachable() {
                self.internetConnection = true
            } else {
                self.internetConnection = false
            }
            
        }
        
        reachability.startNotifier()
    }


    func getRecipes() -> [RecipeItem]? {
        return self.recipes
    }
    
    func getCurrentIngredients() -> [Ingredient]? {
        return self.currentIngredients
    }

    
    private func loadFilters() {
        
        if recipes != nil {
            for item in self.recipes! {
                if item.cookingTime < 15 {
                    if self.recipesUnder15 == nil {
                        self.recipesUnder15 = [RecipeItem]()
                    }
                    self.recipesUnder15?.append(item)
                }
                
                if item.categories!.contains("breakfast") {
                    if self.breakfastRecipes == nil {
                        self.breakfastRecipes = [RecipeItem]()
                    }
                    self.breakfastRecipes?.append(item)
                }
                
                if item.categories!.contains("lunch") {
                    if self.lunchRecipes == nil {
                        self.lunchRecipes = [RecipeItem]()
                    }
                    self.lunchRecipes?.append(item)
                }
                
                if item.categories!.contains("dinner") {
                    if self.dinnerRecipes == nil {
                        self.dinnerRecipes = [RecipeItem]()
                    }
                    self.dinnerRecipes?.append(item)
                }
                
                if item.categories!.contains("snack") {
                    if self.snackRecipes == nil {
                        self.snackRecipes = [RecipeItem]()
                    }
                    self.snackRecipes?.append(item)
                }
                
                
                
                
            }

        }
        
    }


    
    public func getRecipesUnder15() -> [RecipeItem]? {
        if self.recipesUnder15 != nil {
            return self.recipesUnder15!
        }
        return nil
    }
    
    public func getBreakfastRecipes() -> [RecipeItem]? {
        if self.breakfastRecipes != nil {
            return self.breakfastRecipes!
        }
        return nil
    }
    
    public func getSnackRecipes() -> [RecipeItem]? {
        if self.snackRecipes != nil {
            return self.snackRecipes!
        }
        return nil

    }
    
    
    public func getLunchRecipes() -> [RecipeItem]? {
        if self.lunchRecipes != nil {
            return self.lunchRecipes!
        }
        return nil
    }
    
    public func getDinnerRecipes() -> [RecipeItem]? {
        if self.dinnerRecipes != nil {
            return self.dinnerRecipes!
        }
        return nil
    }
    
    
    func loadCustomFilter(category1: String, category2: String, category3: String, category4: String, category5: String, cookingTime: Int, meat: Bool, dairy: Bool, fish: Bool, carbs: Int, completion: (([RecipeItem] ) -> Void)?) {
               
        var filteredRecipes = [RecipeItem]()
    
        var category6 = ""
        if category5 != "" {
            category6 = "dessert"
        }
        
        let receipesAll = self.getRecipes()
        for recipe in receipesAll! {
            
            if category1 == "" &&  category2 == "" && category3 == "" && category4 == "" && category5 == "" {
                //we don't need to check categories
                if recipe.nutritional.netCarbs < Double(carbs) && recipe.cookingTime < cookingTime {
                    
                    //check avoidances
                    if recipe.avoidances != nil {
                        if meat == true && recipe.avoidances!.contains("meat")  {} else if dairy == true && recipe.avoidances!.contains("dairy") {
                        } else if fish == true &&  recipe.avoidances!.contains("fish" ) {} else {
                            filteredRecipes.append(recipe)
                        }
                    }
                }
                
            } else {
                
                //check if it has any of the categories
                if (recipe.categories != nil) && (recipe.categories!.contains(category1) ||  recipe.categories!.contains(category2) || recipe.categories!.contains(category3 )
                    || recipe.categories!.contains(category4) || recipe.categories!.contains(category5) || recipe.categories!.contains(category6) ) {
                    
                    if recipe.nutritional.carbs < Double(carbs) && recipe.cookingTime < cookingTime {
                        //check avoidances
                        if recipe.avoidances != nil {
                            if meat == true && recipe.avoidances!.contains("meat")  {} else if dairy == true && recipe.avoidances!.contains("dairy") {
                            } else if fish == true &&  recipe.avoidances!.contains("fish" ) {} else {
                                filteredRecipes.append(recipe)
                            }
                        }
                    }
                }

            }
            
            
            
            
        }
        completion?(filteredRecipes)

        
        
        
    }
    
    
    /*
 
 if category1 == nil &&  category2 == nil && category3 == nil && category4 == nil && category5 == nil {
 
 
 var recipesQuery = recipesRef.whereField("cookingTime", isLessThan: cookingTime)
 recipesQuery = recipesRef.whereField("meat", isEqualTo: meat)
 //.whereField("dairy", isEqualTo: dairy)
 //.whereField("fish", isEqualTo: fish)
 //.whereField("carbs", isLessThan: carbs)
 
 
 recipesQuery.getDocuments() { (querySnapshot, err) in
 if let err = err {
 print("Error getting documents: \(err)")
 } else {
 if querySnapshot != nil {
 self.parseRecipeData(snapshot: querySnapshot!.documents, completion: { (queriedRecipes) in
 filteredRecipes = queriedRecipes
 completion?(filteredRecipes)
 return
 })
 }
 }
 }
 } else {
 
 for category in [category1, category2, category3, category4, category5] {
 if category != nil {
 
 recipesRef
 .whereField("category", arrayContains: category!)
 .whereField("cookingTime", isLessThan: cookingTime)
 .whereField("meat", isEqualTo: meat)
 .whereField("dairy", isEqualTo: dairy)
 .whereField("fish", isEqualTo: fish)
 .whereField("carbs", isLessThan: carbs)
 
 
 recipesRef.getDocuments() { (querySnapshot, err) in
 if let err = err {
 print("Error getting documents: \(err)")
 } else {
 if querySnapshot != nil {
 self.parseRecipeData(snapshot: querySnapshot!.documents, completion: { (queriedRecipes) in
 filteredRecipes.append(contentsOf: queriedRecipes)
 if category == category5 {
 completion?(filteredRecipes)
 return
 }
 })
 }
 }
 }
 }
 }
 }
 
 */
                    
                    
                   
           


}
