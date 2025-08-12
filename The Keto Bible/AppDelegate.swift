//
//  AppDelegate.swift
//  The Keto Bible
//
//  Created by Laura Day on 4/2/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import UIKit
import Firebase
import SwiftyStoreKit
import GoogleSignIn
import FacebookLogin
import FBSDKLoginKit
import SwiftRater
import FAPanels
import UserNotifications
import FirebaseAuth
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rightMenuVC  = SideMenu()
    fileprivate var currentNonce: String?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // [START default_firestore]
        FirebaseApp.configure()
        // [END default_firestore]
        
        ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
        )
        
        
        completeIAPTransactions()
        
        
        SubscriptionManager.sharedInstance.loadProducts(completion: { })

 
        
        DataManager.sharedInstance.initalizeReachabilityListener()
                
        SwiftRater.daysUntilPrompt = 3
        SwiftRater.usesUntilPrompt = 3
        SwiftRater.significantUsesUntilPrompt = 3
        SwiftRater.daysBeforeReminding = 1
        SwiftRater.showLaterButton = true
        SwiftRater.debugMode = false
        SwiftRater.appLaunched()
        
        
        //check for subscription
        SubscriptionManager.sharedInstance.verifyAllSubscriptions(completion: { (result, error) in
             if result {
                UserManager.shared.hasPro(proVersion: true)
             } else {
                UserManager.shared.hasPro(proVersion: false)
            }
         }) 

        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navVC = UINavigationController()
        navVC.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(loggedOut), name: SettingsVC.loggedOutNotif, object: nil)

        
       
        

        NotificationCenter.default.addObserver(self, selector: #selector(purchaseSuccessful), name: SubscriptionManager.purchaseComplete, object: nil)
        
        registerForPushNotifications()

        //first lets check if they've logged in before
        if UserManager.shared.hasUserSignedIn() {

            
            if UserManager.shared.isAdmin() {
                self.window!.rootViewController = navVC
                navVC.pushViewController(AdminVC(), animated: true)
                self.window!.makeKeyAndVisible()
                return true
            }

            self.window!.rootViewController = navVC
            
            
            DispatchQueue.global(qos: .background).async {
                DataManager.sharedInstance.loadAllRecipesFromFirebase { (recipes) in
                }
            }
            self.launchMainApp()

            self.window!.makeKeyAndVisible()
           
            
        } else {
            //okay lets get them to login/register
            let landingViewController = RegisterViewController()
            window!.rootViewController = navVC
            navVC.pushViewController(landingViewController, animated: true)
            window!.makeKeyAndVisible()
            
        }
        
        return true
    }



    func completeIAPTransactions() {
        SubscriptionManager.sharedInstance.appLaunchedCompleteTransactions()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        AppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    @objc func loggedOut() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navVC = UINavigationController()
        navVC.navigationBar.isHidden = true
        
        
        self.window!.rootViewController = navVC
        navVC.pushViewController(LoginViewController(), animated: true)

        self.window!.makeKeyAndVisible()
        return
    }
    
    @available(iOS 9.0, *)
    func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        return GIDSignIn.sharedInstance.handle(url)

        
    }
    

    func sign(_ signIn: GIDSignIn?, didSignInFor user: GIDGoogleUser?, withError error: Error?) {
      if let error = error {
        print(error.localizedDescription)
        NotificationCenter.default.post(name: UserManager.googleSignIn, object: nil)
        return
      }

        guard let authentication = user?.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!,
                                                        accessToken: authentication.accessToken)
        
        
        UserManager.shared.setEmail(email: user!.profile!.email)
        Auth.auth().signIn(with: credential) { (authResult, error) in

            if let error = error {
               print(error.localizedDescription)
                NotificationCenter.default.post(name: UserManager.googleSignIn, object: nil)
               return
             }
             
             let navVC = UINavigationController()
             navVC.navigationBar.isHidden = true

            DataManager.sharedInstance.loadAllRecipesFromFirebase { (recipes) in
               self.launchMainApp()
            }


      }
    }
    
    @objc func purchaseSuccessful() {
        UserManager.shared.hasPro(proVersion: true)
        self.launchMainApp()
    }

    
    @objc func launchMainApp() {

        UserManager.shared.returnUserData()
        UserManager.shared.setSignedIn()
        
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LandingFeedVC())
            nav.navigationBar.isHidden = true
            
            let rootController = FAPanelController()
            rootController.center(nav).left(self.rightMenuVC)
            rootController.configs.leftPanelWidth = 240
            rootController.leftPanelPosition = .front

            self.window!.rootViewController = rootController

            
            self.window!.makeKeyAndVisible()
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func registerForPushNotifications() {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) {
          [weak self] granted, error in
            
          print("Permission granted: \(granted)")
          guard granted else { return }
          self?.getNotificationSettings()
      }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
        
      }
    }
    
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    }

    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print("Failed to register: \(error)")
    }
    
    func scheduleReEngagementNotifications() {
        
        
        var abr = TimeZone.current.abbreviation()
        if abr == nil {
            abr = "UTC"
        }
        
        
        var dinner1Title = "Running short on time? ⏰"
        var dinner1Msg = "Try this 15 minute Chicken Pad Thai Recipe! 🍜"
        
        var dinner2Title = "Running short on time? ⏰"
        var dinner2Msg = "Check out this quick 2 minute snack!"
        
        var dinner3Title = "Running short on time? ⏰"
        var dinner3Msg = ""
        
        var dinner4Title = "Dinner Time! 🍽️"
        var dinner4Msg = "Check out our Keto Carbonara!🍝"
        
        var dinner5Title = "Dinner Time! 🍽️"
        var dinner5Msg = "Check out these Shrimp Tacos! 🌮"
        
        var dinner6Title = "Dinner Time! 🍽️"
        var dinner6Msg = "Check out this Keto Pepperoni Pizza! 🍕"
        
        var dinner7Title = "Dinner Time! 🍽️"
        var dinner7Msg = "Check out our all new Shepherds Pie! 🥧"
        
        var dinner8Title = "Dinner Time! 🍽️"
        var dinner8Msg = ""
        
        var dinner9Title = "Dinner Time! 🍽️"
        var dinner9Msg = ""
        
        var dinner10Title = "Dinner Time! 🍽️"
        var dinner10Msg = ""
        
        
        var snack1Title = "Feeling Peckish? 😋"
        var snack1Msg = "Here’s some quick snack ideas to satisfy those cravings! 🤤"
        
        var snack2Title = "Need a cool down? ☀️"
        var snack2Msg = "Try this Keto Coconut Ice Cream 🍨"
        
        var snack3Title = "Prepare to be addicted! 😍"
        var snack3Msg = "Try our Coconut Crack Bars 🥥"
        
        var snack4Title = "Oh My Drool! 🤤"
        var snack4Msg = "Our Choc Fudge PB Caramel Bars are to die for! 🍫🥜"
        
        var snack5Title = "Feeling Peckish? 😋"
        var snack5Msg = "How does some homemade nutella sound?!🍫"
        
        var snack6Title = "Feeling Cheesy? 🧀"
        var snack6Msg = "Try our cheese crackers..ready in just 3 minutes!🙀"
        
        var snack7Title = "Did someone say cookies? 🍪"
        var snack7Msg = "Get a taste of these classic Peanut Butter Cookies!🥜"
        
        var snack8Title = "Our number one recipe!"
        var snack8Msg = "Can’t beat our #1 Keto Skillet Cookie 🍪"
        
        var snack9Title = "Oh My Drool! 🤤"
        var snack9Msg = "Check out our Keto Cinnamon Donuts 🍩"
        
        var snack10Title = "Feeling Peckish? 😋"
        var snack10Msg = ""
        
        
    }
    
    func unscheduleReEngagementNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    


}

