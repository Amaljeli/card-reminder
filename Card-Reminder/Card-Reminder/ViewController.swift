//
//  ViewController.swift
//  Card-Reminder
//
//  Created by Amal Jeli on 19/05/1443 AH.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var signInLabel: UIButton!
    
    {
        didSet{
            signInLabel.setTitle("Sign in".localized, for: .normal)
        }
    }
    
  
    @IBOutlet weak var signUpLabel: UIButton!{
        didSet{
            signUpLabel.setTitle("SignUp".localized, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
