//
//  SignInViewController.swift
//  Card-Reminder
//
//  Created by Amal Jeli on 23/05/1443 AH.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {
    var activityIndicator = UIActivityIndicatorView ()
    @IBOutlet weak var EmailTaxtField: UITextField!{
    didSet {
        EmailTaxtField.placeholder = "Please Enter your Email".localized
    }
    }
    @IBOutlet weak var PasswordTextField: UITextField!{
    didSet {
        PasswordTextField.placeholder = "Please Enter your password".localized
    }
    }
    @IBOutlet weak var helloLabel: UILabel!
    
    {
    didSet {
        helloLabel.text = "HelloWelcomeBackToAccount!".localized
    }
}
    
    @IBOutlet weak var EmailLabel: UILabel!
    
    {
    didSet {
        EmailLabel.text = "Email".localized
    }
}
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    {
    didSet {
        passwordLabel.text = "Password".localized
    }
}
    
    
    @IBOutlet weak var signInLabel: UIButton!
    
    {
    didSet {
    signInLabel.setTitle("SignIn".localized, for: .normal)
}
    }
    
    
   
    @IBOutlet weak var eyePassword: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PasswordTextField.rightView = eyePassword
        PasswordTextField.rightViewMode = .whileEditing
        
        let backButton = UIBarButtonItem()
         backButton.title = ""
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
                        tap.cancelsTouchesInView = false
                        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
    }
    
   
    @IBAction func eyePas(_ sender: UIButton) {
        PasswordTextField.isSecureTextEntry.toggle()
        if PasswordTextField.isSecureTextEntry {
            if let image = UIImage(systemName: "eye.fill") {
                sender.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(systemName: "eye.slash.fill"){
                sender.setImage(image, for: .normal)
            }
        }
    }
    
    @IBAction func handleSignIn(_ sender: Any) {
        if let email = EmailTaxtField.text,
           let password = PasswordTextField.text {

            Activity.showIndicator(parentView: self.view, childView:  activityIndicator)
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                                  Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                                  Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                  print("Registration Auth Error",error.localizedDescription)
                              }
                
                if let _ = authResult {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                        vc.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.setRootViewController(vc: vc)
                    }
                }
            }
        }
    }

    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func setRootViewController(vc: UIViewController) {
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
}

