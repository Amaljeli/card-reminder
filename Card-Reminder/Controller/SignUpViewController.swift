//
//  SignUpViewController.swift
//  Card-Reminder
//
//  Created by Amal Jeli on 23/05/1443 AH.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
let imagePickerController = UIImagePickerController ()
    var activityIndicator = UIActivityIndicatorView ()
    
    @IBOutlet weak var userImageView: UIImageView!{
        didSet {
            userImageView.layer.borderColor = UIColor.systemGreen.cgColor
            userImageView.layer.borderWidth = 3.0
            userImageView.layer.cornerRadius = userImageView.bounds.height / 2
            userImageView.layer.masksToBounds = true
            userImageView.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userImageView.addGestureRecognizer(tabGesture)
        }
    }
    
    
    
    @IBOutlet weak var NameTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var ConfirTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleSignUp(_ sender: Any) {
        if let image = userImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.75),
            let name = NameTextField.text,
            let email = EmailTextField.text,
           let password = PasswordTextField.text,
           let confirPassword = ConfirTextField.text,
           password == confirPassword {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().createUser(withEmail: email,password: password) { authResult, error in
                if let error = error {
                    print ("Registration Auth Error",error.localizedDescription)

                }
                if let authResult = authResult {
                    let storageRef = Storage.storage().reference(withPath:"users/\(authResult.user.uid)")
                    let uploadMeta = StorageMetadata.init()
                    uploadMeta.contentType = "image/jpeg"
                    storageRef.putData(imageData, metadata: uploadMeta) { storageMeta, error in
                        if let error = error {
                            print("Registration Storage Error",error.localizedDescription)
                        
                }
                storageRef.downloadURL { url, error in
                    if let error = error {
                        print("Registration Storage Download Url Error",error.localizedDescription)
//
                    }
                    if let url = url {
                    print ("URL",url.absoluteString)
                    let db = Firestore.firestore()
                    let userData: [String:String] = [
                        "id":authResult.user.uid,
                        "name":name,
                        "email":email,
                        "imageUrl":url.absoluteString
                        ]
                        db.collection("users").document(authResult.user.uid).setData(userData) { error in
                            if let error = error {
                                print("Registration Database error",error.localizedDescription)
                            }else {
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
                }
            }
        }
    }
}
extension SignUpViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
   
    @objc func selectImage() {
        showAlart()
    }
    func showAlart() {
        let alert = UIAlertController(title: "choose profile picture", message: "where do you want to pick your image from?", preferredStyle: .actionSheet)
        
    }
}
        