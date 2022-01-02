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
    @IBOutlet weak var EmailTaxtField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var helloLabel: UILabel!
    
    {
    didSet {
        helloLabel.text = "Hello, welcome back to account!".localized
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
    signInLabel.setTitle("Sign in".localized, for: .normal)
}
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleSignIn(_ sender: Any) {
        if let email = EmailTaxtField.text,
           let password = PasswordTextField.text {

            Activity.showIndicator(parentView: self.view, childView:  activityIndicator)
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let _ = authResult {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController {
                        vc.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    
}

