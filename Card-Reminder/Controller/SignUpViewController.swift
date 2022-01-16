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
    
    @IBOutlet weak var eyeConPassword: UIButton!
    @IBOutlet weak var eyePassword: UIButton!
    @IBOutlet weak var letsGetStarted: UILabel!{
        didSet {
    letsGetStarted.text = "LetsGetStarted!".localized
        }
    }
        
    @IBOutlet weak var createAnAccount: UILabel!{
    didSet {
        createAnAccount.text = "CreateAnAccount!".localized
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
   
    
    @IBOutlet weak var signUpBtn: UIButton!{
        didSet{
            signUpBtn.setTitle(NSLocalizedString("Sign Up".localized, tableName: "LOCALIZED", comment: ""), for:.normal)
   
        }
    }
    
    
    
    
    @IBOutlet weak var userImageView: UIImageView!{
        didSet {
            userImageView.layer.borderColor = UIColor.systemGray.cgColor
            userImageView.layer.borderWidth = 1.0
            userImageView.layer.cornerRadius = userImageView.bounds.height / 2
            userImageView.layer.masksToBounds = true
            userImageView.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userImageView.addGestureRecognizer(tabGesture)
        }
    }
    
    
    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            nameTextField.placeholder = "Please Enter your name".localized
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.placeholder = "Please Enter your Email".localized
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!{
//        didSet{
//            passwordTextField.isSecureTextEntry = true
//        }
        didSet {
            passwordTextField.placeholder = "Please Enter your password".localized
        }
    }
    
    @IBOutlet weak var confirmTextField: UITextField!{
//        
        didSet {
            confirmTextField.placeholder = "Confirm password".localized
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initalSteup()
        let backButton = UIBarButtonItem()
         backButton.title = ""
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        imagePickerController.delegate = self
        // Do any additional setup after loading the view.
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
        passwordTextField.rightView = eyePassword
        passwordTextField.rightViewMode = .whileEditing
        
        confirmTextField.rightView = eyeConPassword
        confirmTextField.rightViewMode = .whileEditing
    }
    
    @IBAction func eyePas(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry {
            if let image = UIImage(systemName: "eye.fill") {
                sender.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(systemName: "eye.slash.fill"){
                sender.setImage(image, for: .normal)
            }
        }
    }
    
    @IBAction func changePasswordVisibility(_ sender: UIButton) {
        confirmTextField.isSecureTextEntry.toggle()
        if confirmTextField.isSecureTextEntry {
            if let image = UIImage(systemName: "eye.fill") {
                sender.setImage(image, for: .normal)
            }
        } else {
            if let image = UIImage(systemName: "eye.slash.fill"){
                sender.setImage(image, for: .normal)
            }
        }
    }
    
    @IBAction func handleSignUp(_ sender: Any) {
        if let image = userImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.75),
           let name = nameTextField.text,
           let email = emailTextField.text,
           let password = passwordTextField.text,
           let confirmPassword = confirmTextField.text,
           password == confirmPassword {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().createUser(withEmail: email,password: password) { authResult, error in
//
//
                if let error = error {
                                    Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                                                                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                    print("Registration Auth Error",error.localizedDescription)
                                }
                if let authResult = authResult {
                    let storageRef = Storage.storage().reference(withPath:"users/\(authResult.user.uid)")
                    let uploadMeta = StorageMetadata.init()
                    uploadMeta.contentType = "image/jpeg"
                    storageRef.putData(imageData, metadata: uploadMeta) { storageMeta, error in
//                        if let error = error {
//                            print("Registration Storage Error",error.localizedDescription)
//
//                        }
                        
                        if let error = error {
                            Alert.showAlert(strTitle: "Error", strMessage: error.localizedDescription, viewController: self)
                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                            print("Registration Auth Error",error.localizedDescription)
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
//
//                                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
//                                            vc.modalPresentationStyle = .fullScreen
//                                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
////
//                                            self.setRootViewController(vc: vc)
                                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                                            
                                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                            self.setRootViewController(vc: vc)
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
//     -------------------- Keyboard properties ----------------
        private func initalSteup(){

            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboarde)))

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        @objc private func hideKeyboarde(){
            self.view.endEditing(true)
        }

        @objc private func keyboardWillShow(notification:NSNotification){

            guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               // if keyboard size is not available for some reason, dont do anything
               return
            }

          // move the root view up by the distance of keyboard height
    self.view.frame.origin.y = 100 - keyboardSize.height
        }
        @objc private func keyboardWillHide(){
            self.view.frame.origin.y = 0
        }
        deinit{
            NotificationCenter.default.removeObserver(self , name: UIResponder.keyboardWillShowNotification,object: nil)
            NotificationCenter.default.removeObserver(self , name: UIResponder.keyboardWillHideNotification,object: nil)
        }
//

    @IBAction func back (segue:UIStoryboardSegue){

    }
    
    func setRootViewController(vc: UIViewController) {
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        UIApplication.shared.windows.first?.rootViewController = navigationController
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
