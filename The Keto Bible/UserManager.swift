//
//  UserManager.swift
//  The Keto Bible
//
//  Created by Laura Day on 6/3/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import Foundation
import DefaultsKit
import Firebase
import FacebookLogin
import FacebookCore
import FirebaseAuth

class UserManager {

    private let defaults = Defaults.shared
    private let hasSignedIn = Key<Bool>("is_signed_in")
    private let userName = Key<String>("user_name")
    private let emailKey = Key<String>("email")

    static let shared = UserManager()

    private let syncOnlyWifiKey = Key<Bool>("sync_only_wifi")

    private let hasValidSubKey = Key<Bool>("has_valid_sub")
    
    static let googleSignIn = NSNotification.Name(rawValue: "SignedInViaGoogle")

    private let hasProVersion = Key<Bool>("has_pro")

    private let hasShowedFeatures = Key<Bool>("showed_features")
    
    private let hasShownGroceryIntro = Key<Bool>("showed_grocery_intro")


    
    func logout(){
        self.setSignedOut()
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        //logout facebook if needed
        let loginManager = LoginManager()
        loginManager.logOut() // this is an instance function

        
    }
    
    func hasPro(proVersion: Bool) {
        defaults.set(proVersion, for: hasProVersion)
    }
    
    func getHasPro() -> Bool {
        let result  = defaults.get(for: hasProVersion)
        if result == nil {
            return false
        } else {
            return result!
        }
    }

    
    func setShowedFeatures() {
        defaults.set(true, for: hasShowedFeatures)
    }
    
    func getShowedFeatures() -> Bool {
        let result  = defaults.get(for: hasShowedFeatures)
        if result == nil {
            return false
        } else {
            return result!
        }
    }
    
    
    func setShownGrocery() {
        defaults.set(true, for: hasShownGroceryIntro)
    }
    
    func getShownGrocery() -> Bool {
        let result  = defaults.get(for: hasShownGroceryIntro)
        if result == nil {
            return false
        } else {
            return result!
        }
    }
    
    func setWifiSync(sync: Bool) {
        defaults.set(sync, for: syncOnlyWifiKey)
    }
    
    func getWifiSync() -> Bool {

        
        let result  = defaults.get(for: syncOnlyWifiKey)
        if result == nil {
            return false
        } else {
            return result!
        }
    }
    
    
    
    func setSignedIn() {
        defaults.set(true, for: hasSignedIn)
    }
    
    func isAdmin() -> Bool {
           let firebaseAuth = Auth.auth()
        if firebaseAuth.currentUser?.email == "contact@theketohack.com.au" {
            return true
        } else {
            return false
        }
       }
    
    func setSignedOut() {
        defaults.set(false, for: hasSignedIn)
    }

    func hasUserSignedIn() -> Bool {
        //temp
        //return false
        
        let result  = defaults.get(for: hasSignedIn)
        if result != nil {
        
            return result!
        }
        
        return false
    }

    func setName(name: String) {
        defaults.set(name, for: userName)
    }
    
    func getUserName() -> String {
        let result  = defaults.get(for: userName)
        if result != nil {
            
            return result!
        }
        
        return ""
    }
    
    func setEmail(email: String) {
           defaults.set(email, for: emailKey)
       }
       
    func getEmail() -> String {
        let result  = defaults.get(for: emailKey)
        if result != nil {
            return result!
        }
        return ""
    }

    func returnUserData() {
        
        let handle = Auth.auth().addStateDidChangeListener { auth, user in
            
            if user != nil {
                
                if user!.displayName != nil {
                    UserManager.shared.setName(name: user!.displayName!)
                }
                
                if user!.displayName == nil && user!.email != nil {
                    UserManager.shared.setName(name: user!.email!)
                }
                if user!.email != nil {
                    UserManager.shared.setEmail(email: user!.email!)
                }
                return
            }
            
            
        }
    }
    
}
