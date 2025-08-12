//
//  RegisterViewController.swift
//  The Keto Bible
//
//  Created by Laura Day on 5/3/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import UIKit
import SnapKit
import Spring
import Firebase
import SwiftMessages
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import IHKeyboardAvoiding
import CryptoKit
import AuthenticationServices
import iProgressHUD
import FirebaseCore

class RegisterViewController: UIViewController, UITextFieldDelegate, LoginButtonDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return self.view.window!
    }
    

    let iprogress: iProgressHUD = iProgressHUD()

    
    let logoImg = UIImage(named: "KTBLogo.pdf")
    var nameTextField : UITextField!
    var emailTextField : UITextField!
    var passwordTextField : UITextField!
    var registerBtn : SpringButton!
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?

    
    let signInButton = SpringButton()

    let facebookButton = SpringButton()
    let googleButton = SpringButton()
    
    var logoImgView : UIImageView!
    
    let firebaseFBButton = FBLoginButton()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate


    
    @objc func loggedInViaGoogle(){
        self.registerBtn.loadingIndicator(false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.firebaseFBButton.delegate = self
        let backgroundImage = UIImage(named: "LoginBackground.jpg")
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(loggedInViaGoogle), name: UserManager.googleSignIn, object: nil)

        
        let bgImgView = UIImageView(image: backgroundImage)
        self.view.addSubview(bgImgView)
        bgImgView.snp.makeConstraints{ (make) in
            make.edges.equalTo(self.view)
        }
        
        self.logoImgView = UIImageView(image: logoImg)
        self.view.addSubview(logoImgView)
        logoImgView.snp.makeConstraints{ (make) in
            
            switch UIDevice().type {
            case .iPhone8, .iPhone6, .iPhone6S, .iPhone7:
                make.top.equalTo(self.view.snp.top).offset(80)
            case .iPhoneXSMax, .iPhone8Plus, .iPhone7Plus, .iPhone6Plus, .iPhone6SPlus:
                make.top.equalTo(self.view.snp.top).offset(130)
            case .iPhone5, .iPhone5C, .iPhone5S, .iPhoneSE:
                make.top.equalTo(self.view.snp.top).offset(30)
            default:
                make.top.equalTo(self.view.snp.top).offset(130)
            }
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        let ketoBibleLbl = UILabel()
        
        let ketoBibleStr : String = StyleManager.titleString

        let ketoBibleText = NSMutableAttributedString(string: ketoBibleStr, attributes: [NSAttributedString.Key.font: StyleManager.mainTitleFont!])
        if StyleManager.isKeto {
            ketoBibleText.addAttributes([ NSAttributedString.Key.font : StyleManager.mainTitleFontBold! ], range: NSMakeRange(4, 4));
        } else {
            ketoBibleText.addAttributes([ NSAttributedString.Key.font : StyleManager.mainTitleFontBold! ], range: NSMakeRange(4, 5));
        }
        ketoBibleText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: NSMakeRange(0, ketoBibleStr.count))
        
        ketoBibleLbl.attributedText = ketoBibleText
        self.view.addSubview(ketoBibleLbl)
        ketoBibleLbl.snp.makeConstraints{ (make) in
            if StyleManager.isKeto {
                make.top.equalTo(logoImgView.snp.bottom).offset(15)
            } else {
                make.top.equalTo(logoImgView.snp.bottom)            }
            make.centerX.equalTo(self.view.snp.centerX)
        }
        
        self.nameTextField = UITextField()
        self.nameTextField.backgroundColor = .white
        let nameStr = "your name"
        let attributedString = NSMutableAttributedString(string: nameStr, attributes: [NSAttributedString.Key.font: StyleManager.textFieldFont])
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: NSMakeRange(0, nameStr.count))
        self.nameTextField.attributedPlaceholder = attributedString
        self.nameTextField.layer.cornerRadius = StyleManager.cornerRadius
        self.nameTextField.font = StyleManager.textFieldFont
        self.nameTextField.setIcon(UIImage(named: "personIcon")!)
        self.nameTextField.textColor = .black
        self.nameTextField.returnKeyType = .next
        self.nameTextField.delegate = self

        
        self.view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints{ (make) in
            make.top.equalTo(ketoBibleLbl.snp.bottom).offset(40)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(StyleManager.btnHeight)
        }
        
        
        
        self.emailTextField = UITextField()
        self.passwordTextField = UITextField()
        
        self.emailTextField.backgroundColor = .white
        let emailStr = "your email address"
        let attributedString2 = NSMutableAttributedString(string: emailStr, attributes: [NSAttributedString.Key.font: StyleManager.textFieldFont])
        attributedString2.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: NSMakeRange(0, emailStr.count))
        self.emailTextField.attributedPlaceholder = attributedString2
        self.emailTextField.layer.cornerRadius = StyleManager.cornerRadius
        self.emailTextField.font = StyleManager.textFieldFont
        self.emailTextField.setIcon(UIImage(named: "personIcon")!)
        self.emailTextField.textColor = .black
        self.emailTextField.returnKeyType = .next
        self.emailTextField.delegate = self

        
        let offset = 35

        
        self.view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints{ (make) in
            make.top.equalTo(nameTextField.snp.bottom).offset(offset)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(StyleManager.btnHeight)
        }
        
        
        self.passwordTextField.backgroundColor = .white
        let passwordStr = "password"
        let attributedStringPW = NSMutableAttributedString(string: passwordStr, attributes: [NSAttributedString.Key.font: StyleManager.textFieldFont])
        attributedStringPW.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: NSMakeRange(0, passwordStr.count))
        self.passwordTextField.attributedPlaceholder = attributedStringPW
        self.passwordTextField.layer.cornerRadius = 20
        self.passwordTextField.isSecureTextEntry = true
        self.passwordTextField.font = StyleManager.textFieldFont
        self.passwordTextField.setIcon(UIImage(named: "pwIcon")!)
        self.passwordTextField.textColor = .black

        
        self.view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints{ (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(offset)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(StyleManager.btnHeight)
        }
        self.passwordTextField.delegate = self
        self.passwordTextField.returnKeyType = .continue
        
        self.registerBtn = SpringButton()
        self.registerBtn.setTitle("Register".uppercased(), for: .normal)
        self.registerBtn.setTitleColor(.white, for: .normal)
        self.registerBtn.backgroundColor = StyleManager.mainColor
        self.registerBtn.titleLabel?.font = StyleManager.btnFont!
        self.registerBtn.layer.cornerRadius = StyleManager.cornerRadius
        
        self.view.addSubview(self.registerBtn)
        self.registerBtn.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(passwordTextField.snp.bottom).offset(offset)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(StyleManager.btnHeight)
            
        }
        
        KeyboardAvoiding.avoidingView = logoImgView
        KeyboardAvoiding.keyboardAvoidingMode = .minimum
        
        self.registerBtn.addTarget(self, action: #selector(registerPressed), for: .touchUpInside)
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            make.top.equalTo(self.registerBtn.snp.bottom).offset(10)
            make.width.equalTo(UIScreen.main.bounds.width * 0.7)
        }
        
        
        let signInAttr : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : StyleManager.textFieldFont,
            NSAttributedString.Key.foregroundColor :  StyleManager.signUpColor]
        
        let attributeString = NSMutableAttributedString(string:"Already have an account? Sign in here.", attributes: signInAttr)
        attributeString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: NSMakeRange(24, 13))
        attributeString.addAttributes([NSAttributedString.Key.font : StyleManager.signUpFont], range: NSMakeRange(24, 13))
        
        signInButton.setAttributedTitle(attributeString, for: .normal)
        signInButton.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        signInButton.titleLabel?.numberOfLines = 1
        signInButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        self.facebookButton.backgroundColor = .white
        self.googleButton.backgroundColor = .white
        
        self.facebookButton.setImage(UIImage(named: "fbIcon"), for: .normal)
        self.googleButton.setImage(UIImage(named: "googleIcon"), for: .normal)
        
        self.facebookButton.layer.cornerRadius = StyleManager.cornerRadius
        self.googleButton.layer.cornerRadius = StyleManager.cornerRadius
        
        self.facebookButton.setTitle("Facebook", for: .normal)
        self.facebookButton.setTitleColor(.black, for: .normal)
        self.googleButton.setTitle("Google", for: .normal)
        self.googleButton.setTitleColor(.black, for: .normal)
        
        self.facebookButton.titleLabel?.font = StyleManager.textFieldFont
        self.googleButton.titleLabel?.font = StyleManager.textFieldFont
        
        self.facebookButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        self.googleButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        
        self.view.addSubview(facebookButton)
        self.view.addSubview(googleButton)
        
        self.facebookButton.addTarget(self, action: #selector(fbBtnPressed), for: .touchUpInside)
        self.googleButton.addTarget(self, action: #selector(googleBtnPressed), for: .touchUpInside)
        
        
        
        let smallButtonWidth = ((UIScreen.main.bounds.width * 0.8) / 2) - 15
        
        self.facebookButton.snp.makeConstraints{ (make) in
            make.left.equalTo(self.emailTextField.snp.left)
            make.height.equalTo(StyleManager.smallBtnHeight)
            make.top.equalTo(signInButton.snp.bottom).offset(10)
            make.width.equalTo(smallButtonWidth)
        }
        
        self.googleButton.snp.makeConstraints{ (make) in
            make.right.equalTo(self.emailTextField.snp.right)
            make.height.equalTo(StyleManager.smallBtnHeight)
            make.top.equalTo(signInButton.snp.bottom).offset(10)
            make.width.equalTo(smallButtonWidth)
        }
        
        self.facebookButton.isHidden = true
        self.googleButton.isHidden = true
        

        if #available(iOS 13.0, *) {
            let appleSignIn = ASAuthorizationAppleIDButton()
            appleSignIn.cornerRadius = registerBtn.layer.cornerRadius
            self.view.addSubview(appleSignIn)
            appleSignIn.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.top.equalTo(signInButton.snp.bottom).offset(20)
                make.width.equalTo(registerBtn.snp.width)
                make.height.equalTo(registerBtn.snp.height)
            }
            appleSignIn.addTarget(self, action: #selector(appleSignInPressed), for: .touchUpInside)
        }
        iprogress.captionSize = 14
        iprogress.indicatorSize = 40
        iprogress.indicatorStyle = .pacman
        iprogress.boxSize = 40
        iprogress.attachProgress(toView: self.view)
    }
    
    @objc func appleSignInPressed() {
        if #available(iOS 13.0, *) {
            self.startSignInWithAppleFlow()
        }
    }
    

    
    
    @objc func registerPressed() {
        self.registerBtn.pop(completion: {
            self.registerUser()
        })
    }
    
    
    

    @objc func fbBtnPressed() {
        self.facebookButton.pop(completion: {
            self.firebaseFBButton.permissions = ["public_profile", "email"]
            self.firebaseFBButton.sendActions(for: .touchUpInside)
        })
    }

    
    @objc func googleBtnPressed() {
        self.googleButton.pop(completion: {
            self.showIndicator(show: false)
           
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }

            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)


            
            GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

              if let error = error {
                // ...
                return
              }

              guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
              else {
                return
              }

              let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                             accessToken: authentication.accessToken)

              // ...
            }
            
            
            
            //GIDSignIn.sharedInstance.signIn()
        })
    }
    
    func registerUser() {
        
        //show loading
        self.showIndicator(show: true)
        
        let errorView = MessageView.viewFromNib(layout: .cardView)
        errorView.configureTheme(.warning)
        errorView.configureDropShadow()
        errorView.button?.isHidden = true
        errorView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (errorView.backgroundView as? CornerRoundingView)?.cornerRadius = 10


        if self.nameTextField.text == "" {
            errorView.configureContent(title: "Warning", body: "name can't be empty")
            SwiftMessages.show(view: errorView)
            self.showIndicator(show: false)
            return
        } else {
            UserManager.shared.setName(name: self.nameTextField.text!)
        }
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            errorView.configureContent(title: "Warning", body: "email/password can't be empty")
            SwiftMessages.show(view: errorView)
            self.showIndicator(show: false)
            return
        } else {
            UserManager.shared.setEmail(email: self.emailTextField.text!)
        }
        
        
        Auth.auth().createUser(withEmail: self.emailTextField!.text!, password: self.passwordTextField.text!) { authResult, error in
            
            guard let authResult = authResult, error == nil else {
                errorView.configureContent(title: "Error", body: error!.localizedDescription)
                SwiftMessages.show(view: errorView)
                self.showIndicator(show: false)
                return
            }

            
            self.signInUser()
        }
    }
    
    func signInUser() {
        view.updateCaption(text: "Preparing Recipes..")
         view.showProgress()

         DataManager.sharedInstance.loadAllRecipesFromFirebase { (recipes) in
            self.appDelegate.launchMainApp()
         }
         
     }
     
    
    @objc func signInPressed() {
        self.signInButton.pop(completion: {
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        })
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameTextField {
          //  self.emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
           // passwordTextField.becomeFirstResponder()
        } else {
            self.registerPressed()
        }

        return false
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    func showIndicator(show: Bool) {
        self.registerBtn.loadingIndicator(show)
        if show {
             self.registerBtn.setTitle("", for: .normal)
        } else {
            self.registerBtn.setTitle("REGISTER", for: .normal)
        }


    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        self.showIndicator(show: true)
        if let error = error {
            self.showIndicator(show: false)
            print(error.localizedDescription)
            return
        }
        
        
        if AccessToken.current == nil {
            self.showIndicator(show: false)
            return
        } else {
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            
             Auth.auth().signIn(with: credential) { (authResult, error) in
               if let error = error {
                 self.showIndicator(show: false)
                 print(error.localizedDescription)
                 return
               }
                
                DispatchQueue.main.async {
                    self.showIndicator(show: false)
                    self.signInUser()
                }
             }
        }
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("loggedout")
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
}


private func randomNonceString(length: Int = 32) -> String {
  precondition(length > 0)
  let charset: Array<Character> =
      Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
  var result = ""
  var remainingLength = length

  while remainingLength > 0 {
    let randoms: [UInt8] = (0 ..< 16).map { _ in
      var random: UInt8 = 0
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
      if errorCode != errSecSuccess {
        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
      }
      return random
    }

    randoms.forEach { random in
      if remainingLength == 0 {
        return
      }

      if random < charset.count {
        result.append(charset[Int(random)])
        remainingLength -= 1
      }
    }
  }

  return result
}



@available(iOS 13.0, *)
extension RegisterViewController: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                  idToken: idTokenString,
                                                  rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if error != nil {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
          print(error!.localizedDescription)
          return
        }
        self.signInUser()
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}

