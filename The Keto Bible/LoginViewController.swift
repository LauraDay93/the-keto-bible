//
//  ViewController.swift
//  The Keto Bible
//
//  Created by Laura Day on 4/2/19.
//  Copyright © 2019 Laura Day. All rights reserved.
//

import UIKit
import SnapKit
import Spring
import SwiftMessages
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAnalytics
import FAPanels
import AuthenticationServices
import CryptoKit
import iProgressHUD

class LoginViewController: UIViewController, UITextFieldDelegate, LoginButtonDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return self.view.window!
    }
    
    let iprogress: iProgressHUD = iProgressHUD()

    let logoImg = UIImage(named: "KTBLogo.pdf")
    var emailTextField : UITextField!
    var passwordTextField : UITextField!
    var signInBtn : SpringButton!
    let signUpButton = SpringButton()
    
    let forgotPassBtn = SpringButton()
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?

    
    var facebookButton = SpringButton()
    let googleButton = SpringButton()
    let firebaseFBButton = FBLoginButton()
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    @objc func loggedInViaGoogle(){
        self.signInBtn.loadingIndicator(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firebaseFBButton.delegate = self
        //GIDSignIn.sharedInstance()?.presentingViewController = self
        
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(endEditing)))
        
        NotificationCenter.default.addObserver(self, selector: #selector(loggedInViaGoogle), name: UserManager.googleSignIn, object: nil)

        
        let backgroundImage = UIImage(named: "LoginBackground.jpg")
        
        let bgImgView = UIImageView(image: backgroundImage)
        self.view.addSubview(bgImgView)
        bgImgView.snp.makeConstraints{ (make) in
            make.edges.equalTo(self.view)
        }
        
        let logoImgView = UIImageView(image: logoImg)
        self.view.addSubview(logoImgView)
        print("Running on: \(UIDevice().type)")
        logoImgView.snp.makeConstraints{ (make) in
             switch UIDevice().type {
                case .iPhone8, .iPhone6, .iPhone6S, .iPhone7:
                    make.top.equalTo(self.view.snp.top).offset(100)
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
                make.top.equalTo(logoImgView.snp.bottom)
            }
            make.centerX.equalTo(logoImgView.snp.centerX)
        }
        
        self.emailTextField = UITextField()
        self.passwordTextField = UITextField()
        self.passwordTextField.textColor = .black

        self.passwordTextField.isSecureTextEntry = true
        
        self.emailTextField.backgroundColor = .white
        let emailStr = "your email address"
        let attributedString = NSMutableAttributedString(string: emailStr, attributes: [NSAttributedString.Key.font: StyleManager.textFieldFont])
        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: NSMakeRange(0, emailStr.count))
        self.emailTextField.attributedPlaceholder = attributedString
        self.emailTextField.layer.cornerRadius = StyleManager.cornerRadius
        self.emailTextField.font = StyleManager.textFieldFont
        self.emailTextField.textColor = .black
        self.emailTextField.setIcon(UIImage(named: "personIcon")!)

        self.view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints{ (make) in
            if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhoneSE {
                make.top.equalTo(ketoBibleLbl.snp.bottom).offset(20)
            } else {
                make.top.equalTo(ketoBibleLbl.snp.bottom).offset(40)
            }
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(StyleManager.btnHeight)
        }
        
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        
        let offset = 35
        
        self.passwordTextField.backgroundColor = .white
        let passwordStr = "password"
        let attributedStringPW = NSMutableAttributedString(string: passwordStr, attributes: [NSAttributedString.Key.font: StyleManager.textFieldFont])
        attributedStringPW.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black], range: NSMakeRange(0, passwordStr.count))
        self.passwordTextField.attributedPlaceholder = attributedStringPW
        self.passwordTextField.layer.cornerRadius = 20
        self.passwordTextField.font = StyleManager.textFieldFont
        self.passwordTextField.setIcon(UIImage(named: "pwIcon")!)
        
        self.view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints{ (make) in
            make.top.equalTo(emailTextField.snp.bottom).offset(offset)
            make.centerX.equalTo(self.view.snp.centerX)
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(StyleManager.btnHeight)
        }
        
        self.forgotPassBtn.setTitle("forgot password?", for: .normal)
        self.forgotPassBtn.setTitle("forgot password?", for: .highlighted)
        self.forgotPassBtn.setTitle("forgot password?", for: .selected)
        self.forgotPassBtn.setTitleColor(.white, for: .normal)
        self.forgotPassBtn.titleLabel?.textAlignment = .left
        self.forgotPassBtn.titleLabel?.font = StyleManager.signUpFont
        
        self.view.addSubview(forgotPassBtn)
        forgotPassBtn.snp.makeConstraints { (make) in
            make.left.equalTo(self.passwordTextField.snp.left).offset(10)
            make.top.equalTo(self.passwordTextField.snp.bottom).offset(5)
            make.height.equalTo(20)
        }
        self.forgotPassBtn.addTarget(self, action: #selector(forgotPassPressed), for: .touchUpInside)
        
        self.signInBtn = SpringButton()
        self.signInBtn.setTitle("Sign In".uppercased(), for: .normal)
        self.signInBtn.setTitleColor(.white, for: .normal)
            self.signInBtn.backgroundColor = StyleManager.mainColor
        self.signInBtn.titleLabel?.font = StyleManager.btnFont!
        self.signInBtn.layer.cornerRadius = StyleManager.cornerRadius
        
        self.view.addSubview(self.signInBtn)
        self.signInBtn.snp.makeConstraints{ (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhoneSE {
                make.top.equalTo(forgotPassBtn.snp.bottom).offset(offset-15)
            } else {
                make.top.equalTo(forgotPassBtn.snp.bottom).offset(offset)

            }
            make.width.equalTo(UIScreen.main.bounds.width * 0.8)
            make.height.equalTo(StyleManager.btnHeight)

        }
        
        self.signInBtn.addTarget(self, action: #selector(signInPressed), for: .touchUpInside)
        

        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view.snp.centerX)
            if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhoneSE {
                make.top.equalTo(self.signInBtn.snp.bottom).offset(5)
            } else {
                make.top.equalTo(self.signInBtn.snp.bottom).offset(20)
            }
            make.width.equalTo(UIScreen.main.bounds.width * 0.7)
        }
        
        let signInAttr : [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font : StyleManager.textFieldFont,
            NSAttributedString.Key.foregroundColor :  StyleManager.signUpColor]
        
        let attributeString = NSMutableAttributedString(string:"Don’t have an account? Sign up here.", attributes: signInAttr)
        attributeString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.white], range: NSMakeRange(23, 13))
        attributeString.addAttributes([NSAttributedString.Key.font : StyleManager.signUpFont], range: NSMakeRange(23, 13))

        signUpButton.setAttributedTitle(attributeString, for: .normal)
        signUpButton.titleLabel?.adjustsFontSizeToFitWidth = true
        signUpButton.addTarget(self, action: #selector(signUpPressed), for: .touchUpInside)

        
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

        self.facebookButton.isHidden = true
        self.googleButton.isHidden = true

        let smallButtonWidth = ((UIScreen.main.bounds.width * 0.8) / 2) - 15
        
        self.facebookButton.snp.makeConstraints{ (make) in
            make.left.equalTo(self.emailTextField.snp.left)
            make.height.equalTo(StyleManager.smallBtnHeight)
            if UIDevice().type == .iPhone5 || UIDevice().type == .iPhone5S || UIDevice().type == .iPhone5C || UIDevice().type == .iPhoneSE {
                make.top.equalTo(signUpButton.snp.bottom).offset(10)
            } else {
                make.top.equalTo(signUpButton.snp.bottom).offset(20)
            }
            make.width.equalTo(smallButtonWidth)
        }
        
        self.googleButton.snp.makeConstraints{ (make) in
            make.right.equalTo(self.emailTextField.snp.right)
            make.height.equalTo(StyleManager.smallBtnHeight)
            make.top.equalTo(self.facebookButton.snp.top)
            make.width.equalTo(smallButtonWidth)
        }

        
        if #available(iOS 13.0, *) {
            let appleSignIn = ASAuthorizationAppleIDButton()
            appleSignIn.cornerRadius = signInBtn.layer.cornerRadius
            self.view.addSubview(appleSignIn)
            appleSignIn.snp.makeConstraints { (make) in
                make.centerX.equalTo(self.view.snp.centerX)
                make.top.equalTo(signUpButton.snp.bottom).offset(20)
                make.width.equalTo(signInBtn.snp.width)
                make.height.equalTo(signInBtn.snp.height)
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
    

    
    
    @objc func forgotPassPressed() {
        
        let errorView = MessageView.viewFromNib(layout: .cardView)
        errorView.configureTheme(.warning)
        errorView.configureDropShadow()
        errorView.button?.isHidden = true
        errorView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (errorView.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        let messageViewCorrect = MessageView.viewFromNib(layout: .cardView)
        messageViewCorrect.configureTheme(.success)
        messageViewCorrect.configureDropShadow()
        messageViewCorrect.button?.isHidden = true
        messageViewCorrect.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (messageViewCorrect.backgroundView as? CornerRoundingView)?.cornerRadius = 10

        
        
        self.forgotPassBtn.pop(completion: {
            if self.emailTextField.text == "" {
                errorView.configureContent(title: "Warning", body: "please enter your email address")
                SwiftMessages.show(view: errorView)
                return
            }
            
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!) { error in
                if error == nil {
                    messageViewCorrect.configureContent(title: "Email Sent", body: "password reset email sent. ")
                    SwiftMessages.show(view: messageViewCorrect)
                } else {
                    print("error: " + error!.localizedDescription)
                }
            }
            
        })
    }
    
    @objc func signInPressed() {
        self.signInBtn.pop(completion: {
            self.loginUser()
        })
    }
    
    @objc func signUpPressed() {
        self.signUpButton.pop(completion: {
            self.navigationController?.pushViewController(RegisterViewController(), animated: true)
            
        })
    }
    
    @objc func fbBtnPressed() {
        firebaseFBButton.sendActions(for: .touchUpInside)
    }
    
    @objc func googleBtnPressed() {
        self.googleButton.pop(completion: {
            self.signInBtn.loadingIndicator(true)
            //GIDSignIn.sharedInstance().signIn()
        })
    }
    
    func showIndicator(show: Bool) {
        self.signInBtn.loadingIndicator(show)
        if show {
             self.signInBtn.setTitle("", for: .normal)
        } else {
            self.signInBtn.setTitle("SIGN IN", for: .normal)
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
                    self.signInUser()
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("loggedout")
    }
    
    func signInUser() {
        view.updateCaption(text: "Preparing Recipes..")
         view.showProgress()

         DataManager.sharedInstance.loadAllRecipesFromFirebase { (recipes) in
            self.appDelegate.launchMainApp()
         }
         
     }
    
    func loginUser() {
                
        //show loading
        self.signInBtn.loadingIndicator(true)
        self.signInBtn.titleLabel?.isHidden = true
        
        let errorView = MessageView.viewFromNib(layout: .cardView)
        errorView.configureTheme(.warning)
        errorView.configureDropShadow()
        errorView.button?.isHidden = true
        errorView.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (errorView.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            errorView.configureContent(title: "Warning", body: "email/password can't be empty")
            SwiftMessages.show(view: errorView)
            self.signInBtn.titleLabel?.isHidden = false
            self.signInBtn.loadingIndicator(false)
            return
        }
        
        
        Auth.auth().signIn(withEmail: self.emailTextField!.text!, password: self.passwordTextField.text!) { authResult, error in
            self.signInBtn.titleLabel?.isHidden = false
            
            guard let _ = authResult, error == nil else {
                errorView.configureContent(title: "Error", body: error!.localizedDescription)
                SwiftMessages.show(view: errorView)
                self.signInBtn.loadingIndicator(false)
                return
            }

            if UserManager.shared.isAdmin() {
                self.navigationController?.pushViewController(AdminVC(), animated: true)
                return
            }
            
            DispatchQueue.main.async {
                self.signInBtn.loadingIndicator(false)
                self.signInUser()
            }
        
        }
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()

        //or
        //self.view.endEditing(true)
        return true
    }

    
    @objc func endEditing() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()

    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
extension LoginViewController: ASAuthorizationControllerDelegate {

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
