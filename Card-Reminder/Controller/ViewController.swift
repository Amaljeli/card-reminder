//
//  ViewController.swift
//  Card-Reminder
//
//  Created by Amal Jeli on 19/05/1443 AH.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cardReminderLabel: UILabel!
    {
    didSet {
        cardReminderLabel.text = "Card Reminder".localized
    }
}
    @IBOutlet weak var signInLabel: UIButton! {
//
        didSet{
            signInLabel.setTitle(NSLocalizedString("SignIn", tableName: "LOCALIZED", comment: ""), for:.normal)


                                 }
                                 }
  
    @IBOutlet weak var signUpLabel: UIButton!{
        didSet{
            signUpLabel.setTitle(NSLocalizedString("SignUp", tableName: "LOCALIZED", comment: ""), for:.normal)
   
        }
    }
    @IBOutlet weak var languageSegmentControl: UISegmentedControl!{
        didSet {
            if let lang = UserDefaults.standard.string(forKey: "currentLanguage") {
                switch lang {
                case "ar":
                    languageSegmentControl.selectedSegmentIndex = 0
                case "en":
                    languageSegmentControl.selectedSegmentIndex = 1
                case "fr":
                    languageSegmentControl.selectedSegmentIndex = 2
                default:
                    let localLang =  Locale.current.languageCode
                     if localLang == "ar" {
                         languageSegmentControl.selectedSegmentIndex = 0
                     } else if localLang == "fr"{
                         languageSegmentControl.selectedSegmentIndex = 2
                     }else {
                         languageSegmentControl.selectedSegmentIndex = 1
                     }
                  
                }
            
            }else {
                let localLang =  Locale.current.languageCode
                 if localLang == "ar" {
                     languageSegmentControl.selectedSegmentIndex = 0
                 } else if localLang == "fr"{
                     languageSegmentControl.selectedSegmentIndex = 2
                 }else {
                     languageSegmentControl.selectedSegmentIndex = 1
                 }
            }
        }
    
    
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

  
    @IBAction func lnguageSegmentControlAction(_ sender: UISegmentedControl) {
  
                      
        if let lang = sender.titleForSegment(at:sender.selectedSegmentIndex)?.lowercased() {
            if lang == "ar" {
                         UIView.appearance().semanticContentAttribute = .forceRightToLeft
                     }else {
                         UIView.appearance().semanticContentAttribute = .forceLeftToRight
                     }
                 
                         UserDefaults.standard.set(lang, forKey: "currentLanguage")
                         Bundle.setLanguage(lang)
                         let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                         if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                            let sceneDelegate = windowScene.delegate as? SceneDelegate {
                             sceneDelegate.window?.rootViewController = storyboard.instantiateInitialViewController()
                         }
             }

         }
        
    
    @IBAction func back (segue:UIStoryboardSegue){
        
    }
     }


    



extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: "LOCALIZED", bundle: .main, value: self, comment: self)
    }
}
