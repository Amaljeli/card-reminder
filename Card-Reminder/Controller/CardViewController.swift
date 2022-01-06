//
//  CardViewController.swift
//  Card-Reminder
//
//  Created by Amal Jeli on 23/05/1443 AH.
//

import UIKit
import Firebase
class CardViewController: UIViewController {
    var selectedCard:Card?
    var selectedCradImage:UIImage?
//    var selecedUser:UIImage?
    @IBOutlet weak var actionButton: UIButton!
//    {
//        didSet{
//            actionButton.setTitle("Add Card".localized, for: .normal)
//        }
//    }
    
    @IBOutlet weak var cardImageView: UIImageView!{
        didSet {
            cardImageView.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
            cardImageView.addGestureRecognizer(tapGesture)
        }
    }
    
    @IBOutlet weak var deiStartDate: UILabel!
    {
    didSet {
        deiStartDate.text = "StartDate".localized
    }
}
    
    @IBOutlet weak var deiEndDate: UILabel!
    {
    didSet {
        deiEndDate.text = "ExpiryDate".localized
    }
}
    
//    @IBOutlet weak var addLabel: UIButton!
//
//    {
//        didSet{
//            addLabel.setTitle("Add Card".localized, for: .normal)
//        }
//    }
    
    
    
    //    var type = ""
    @IBOutlet weak var endPicker: UIDatePicker!
    
  
    
    @IBOutlet weak var startDateLabel: UILabel!
    
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var startPiecker: UIDatePicker!
  
    
    @IBOutlet weak var TypePickerView: UIPickerView!
    let activityIndicator = UIActivityIndicatorView()
    var arrayOfTaype = ["Card Bank".localized,"Passpot".localized,"Driving license".localized,"Id Card".localized,"Other Card".localized]
    var selectedType = "Card Bank"
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem()
         backButton.title = ""
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
//        print(type,"?????")
//        __________________________________________________
//        crateDatePicker()
//        func crateDatePicker () {
//            let toolbar = UIToolbar()
//            toolbar.sizeToFit()
//
////            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done , target: nil, action: #selector(donePressed))
//            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
//            toolbar.setItems([doneBtn], animated: true)
//            startDateTextField.inputAccessoryView = toolbar
//
//            startDateTextField.inputView = datePicker
//
//        }
//
//        @objc func donePressed () {
//
//                }

//        _____________________________________
    
        TypePickerView.delegate = self
        TypePickerView.dataSource = self
        
        if let selectedCard = selectedCard,
        let selectedImage = selectedCradImage {
//            startPiecker.date =  startPiecker
            startDateLabel.text = selectedCard.startDate
            endDateLabel.text = selectedCard.ExpiryDate
            cardImageView.image = selectedImage
            actionButton.setTitle("Update Card".localized, for: .normal)
//            let deleteBarButton = UIBarButtonItem(image: UIImage(systemName: "trash.fill"), style: .plain, target: self, action: #selector(handleDelete))
//            self.navigationItem.rightBarButtonItem = deleteBarButton
        }else {
            actionButton.setTitle("Add Card".localized, for: .normal)
//            self.navigationItem.rightBarButtonItem = nil
            startDateLabel.text = Date().convertDateToString()
            endDateLabel.text = Date().convertDateToString()
//            self.navigationItem.rightBarButtonItem = nil
            
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func satatDatePiecker(_ sender: UIDatePicker) {
        startDateLabel.text = sender.date.convertDateToString()
    }
        
//        let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//        startDateLabel.text = "\(dateFormatter.string(from: sender.date) )"
        
    
    
    @IBAction func endDatePiecker(_ sender: UIDatePicker) {
        endDateLabel.text = sender.date.convertDateToString()
    }
    
        //        let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
       
        
//        endDateLabel.text = "\(dateFormatter.string(from: sender.date) )"
      
    
    
    
    
    
    
//    @objc func handleDelete (_ sender: UIBarButtonItem) {
//        let ref = Firestore.firestore().collection("cards")
//        if let selectedCard = selectedCard {
//            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
//            ref.document(selectedCard.id).delete { error in
//                if let error = error {
//                    print("Error in db delete",error)
//                }else {
//                    let storageRef = Storage.storage().reference(withPath: "cards/\(selectedCard.userId)/\(selectedCard.id)")
//
//                    storageRef.delete { error in
//                        if let error = error {
//                            print("Error in storage delete",error)
//                        } else {
//                            self.activityIndicator.stopAnimating()
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                    }
//
//                }
//            }
//        }
//
//}
    @IBAction func handleActionTouch(_ sender: Any) {
//
        if let image = cardImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.5),
           let startDate = startDateLabel.text,
           let endDate = endDateLabel.text,
           //           let type = TypePickerView,
           let currentUser = Auth.auth().currentUser {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            var cardId = ""
            if let selectedCard = selectedCard {
                cardId = selectedCard.id
            }else {
                cardId = "\(Firebase.UUID())"
            }
            let storageRef = Storage.storage().reference(withPath: "posts/\(currentUser.uid)/\(cardId)")
            let updloadMeta = StorageMetadata.init()
            updloadMeta.contentType = "image/jpeg"
            storageRef.putData(imageData, metadata: updloadMeta) { storageMeta, error in
                if let error = error {
                    print("Upload error",error.localizedDescription)
                }
                storageRef.downloadURL { url, error in
                    var cardData = [String:Any]()
                    if let url = url {
                        let db = Firestore.firestore()
                        let ref = db.collection("card")
                        if let selectedCard = self.selectedCard {
                            cardData = [
                                "cardId": cardId,
                                "userId":selectedCard.userId,
                                "startDate":startDate,
                                "endDate":endDate,
                                "type": self.selectedType,
                                "imageUrl":url.absoluteString,
                                "createdAt":selectedCard.createdAt ?? FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                            ]
                            ref.document(currentUser.uid).collection("card").document(cardId).updateData(cardData) { error in
                                if let error = error {
                                    print("FireStore Error",error.localizedDescription)
                                }
                                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }else {
                            cardData = [
                                "cardId": cardId,
                                "userId":currentUser.uid,
                                "startDate":startDate,
                                "endDate":endDate,
                                "type": self.selectedType,
                                "imageUrl":url.absoluteString,
                                "createdAt":FieldValue.serverTimestamp(),
                                "updatedAt": FieldValue.serverTimestamp()
                            ]
                            ref.document(currentUser.uid).collection("card").document(cardId).setData(cardData) { error in
                                if let error = error {
                                    print("FireStore Error",error.localizedDescription)
                                }
                                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        // update
                        // add new
                        
                    }
                }
            }
        }
        
    }
}



extension CardViewController:UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayOfTaype.count

    }
    
    func numberOfComponents (in pickerView: UIPickerView) -> Int {
            return 1
         
               }
        
   
//
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = arrayOfTaype[row]
        

        
//        ابغى هنا اربط من ليبل اللي ف صفحه الديتيلز
//        pickerLabel.text = ("\(Taype)")
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//      type = arrayOfTaype[row]
        return arrayOfTaype[row]
    }
    }
    

extension CardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func chooseImage() {
        self.showAlert()
    }
    private func showAlert() {
        
        let alert = UIAlertController(title: "Choose Profile Picture", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        cardImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
extension Date {
    
    func convertDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }
    
}

