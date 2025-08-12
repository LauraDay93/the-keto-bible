import UIKit
import FAPanels
import FacebookCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private let rightMenuVC = SideMenu()

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let nav = UINavigationController()
        nav.navigationBar.isHidden = true

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loggedOut),
                                               name: SettingsVC.loggedOutNotif,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(purchaseSuccessful),
                                               name: SubscriptionManager.purchaseComplete,
                                               object: nil)

        if UserManager.shared.hasUserSignedIn() {
            if UserManager.shared.isAdmin() {
                window.rootViewController = nav
                nav.pushViewController(AdminVC(), animated: false)
            } else {
                DispatchQueue.global(qos: .background).async {
                    DataManager.sharedInstance.loadAllRecipesFromFirebase { _ in }
                }
                launchMainApp(on: window)
            }
        } else {
            window.rootViewController = nav
            nav.pushViewController(RegisterViewController(), animated: false)
        }

        self.window = window
        window.makeKeyAndVisible()
    }

    // Facebook URL handling for scenes
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }

    @objc private func purchaseSuccessful() {
        UserManager.shared.hasPro(proVersion: true)
        if let window = window {
            launchMainApp(on: window)
        }
    }

    @objc private func loggedOut() {
        guard let window = window else { return }
        let nav = UINavigationController()
        nav.navigationBar.isHidden = true
        window.rootViewController = nav
        nav.pushViewController(LoginViewController(), animated: false)
        window.makeKeyAndVisible()
    }

    private func launchMainApp(on window: UIWindow) {
        UserManager.shared.returnUserData()
        UserManager.shared.setSignedIn()

        let nav = UINavigationController(rootViewController: LandingFeedVC())
        nav.navigationBar.isHidden = true

        let rootController = FAPanelController()
        rootController.center(nav).left(rightMenuVC)
        rootController.configs.leftPanelWidth = 240
        rootController.leftPanelPosition = .front

        window.rootViewController = rootController
        window.makeKeyAndVisible()
    }
}
