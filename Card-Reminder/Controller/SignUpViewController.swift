//
//  SignUpViewController.swift
//  Card-Reminder
//
//  Created by Amal Jeli on 23/05/1443 AH.
//

import UIKit
import Firebase
class SignUpViewController: UIViewController {
    let imagePickerController = UIImagePickerController ()
    var activityIndicator = UIActivityIndicatorView ()
    
    @IBOutlet weak var letsGetStarted: UILabel!{
        didSet {
    letsGetStarted.text = "Let's Get Started!".localized
        }
    }
        
    @IBOutlet weak var createAnAccount: UILabel!{
    didSet {
        createAnAccount.text = "Create an account!".localized
    }
}
    
    @IBOutlet weak var nameLabel: UILabel!
    {
    didSet {
        nameLabel.text = "Name".localized
    }
}
    @IBOutlet weak var EmailLabel: UILabel!
    {
    didSet {
        EmailLabel.text = "Email".localized
    }
}
    @IBOutlet weak var PasswordLabel: UILabel!
    {
    didSet {
        PasswordLabel.text = "Password".localized
    }
}
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    {
    didSet {
        confirmPasswordLabel.text = "confirm password".localized
    }
}
    @IBOutlet weak var SignUpLabel: UIButton!
    {
        didSet{
            SignUpLabel.setTitle("SignUp".localized, for: .normal)
        }
    }
    
    
    
    
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
    
    @IBAction func eyePassword(_ sender: AnyObject) {
        PasswordTextField.isSecureTextEntry.toggle()
                if  PasswordTextField.isSecureTextEntry {
                    if let image = UIImage(systemName: "eye.fill") {
                        sender.setImage(image, for: .normal)
                    }
                } else {
                    if let image = UIImage(systemName: "eye.slash.fill") {
                        sender.setImage(image, for: .normal)
                    }
                }
            }
        
    @IBAction func eyePasswordConferm(_ sender: AnyObject) {
        PasswordTextField.isSecureTextEntry.toggle()
                if  PasswordTextField.isSecureTextEntry {
                    if let image = UIImage(systemName: "eye.fill") {
                        sender.setImage(image, for: .normal)
                    }
                } else {
                    if let image = UIImage(systemName: "eye.slash.fill") {
                        sender.setImage(image, for: .normal)
                    }
                }
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
extension SignUpViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc func selectImage() {
        showAlart()
    }
    func showAlart() {
        let alert = UIAlertController(title: "choose profile picture", message: "where do you want to pick your image from?", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { Action in
            self.getImage(from: .camera)
        }
        let galaryAction = UIAlertAction(title: "photo Album", style: .default) { Action in
            self.getImage(from: .photoLibrary)
        }
        let dismissAction = UIAlertAction(title: "Cancle", style: .destructive) { Action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cameraAction)
        alert.addAction(galaryAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    func getImage( from sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return}
        userImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


