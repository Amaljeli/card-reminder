//
//  HomeViewController.swift
//  Card-Reminder
//
//  Created by Amal Jeli on 23/05/1443 AH.
//

import UIKit
import Firebase
class HomeViewController: UIViewController {
    var selectedCard:UIImage?

    var cards = [Card](){

        didSet {
            self.cardTableView.reloadData()
        }
    }
    
   
    
    
    @IBOutlet weak var imageUser: UIImageView!{
    didSet{
imageUser.layer.borderColor = UIColor.systemGray.cgColor
        imageUser.layer.borderWidth = 3.0
        imageUser.layer.cornerRadius = imageUser.bounds.height / 2
        imageUser.layer.masksToBounds = true
        imageUser.isUserInteractionEnabled = true
    }
}
    @IBOutlet weak var cardTableView: UITableView!{
        
    didSet {
        cardTableView.delegate = self
        cardTableView.dataSource = self
        cardTableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
    }
    }
   
    @IBOutlet weak var welcomeLabel: UILabel!
    {
    didSet {
        welcomeLabel.text = "Welcome!".localized
    }
}
    
    @IBOutlet weak var addNewCardLabel: UIButton! {
        
        didSet {
            addNewCardLabel.setTitle("AddNewCard".localized, for: .normal)
    }
        }
    
    @IBOutlet weak var userNameLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
getCards()
        // Do any additional setup after loading the view.
        let ref = Firestore.firestore()
                        ref.collection("users").document(Auth.auth().currentUser!.uid).getDocument { userSnapshot, error in
                                 if let error = error {
                                     print("ERROR user Data",error.localizedDescription)
                                     print ("sss")
                                 }
                                 if let userSnapshot = userSnapshot,
                                    let userData = userSnapshot.data(){
                                     let user = User(dict:userData)
                                     print("+++\(user.name)+++")
                                     self.userNameLable.text = user.name
                                     self.imageUser.loadImageUsingCache(with: user.imageUrl)
                                     
                                 }
                        }
    }
    
    
    func getCards() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let ref = Firestore.firestore()
        ref.collection("card").document(userId).collection("card").addSnapshotListener {
            snapshot, error in
            self.cards.removeAll()
            if let error = error {
                print ("DB ERROR Cards",error.localizedDescription)
            }
            if let snapshot = snapshot {
                print("CARD GANGES:",snapshot.documents.count)
                
                snapshot.documents.forEach { docement in
                    let  userId = docement.get("userId") as? String ?? ""
                    let imageUrl = docement.get("imageUrl") as? String ?? ""
                    let cardId = docement.get("cardId") as? String ?? ""
                    let startDate = docement.get("startDate") as? String ?? ""
                    let expiryDate = docement.get("endDate") as? String ?? ""
                    let type = docement.get("type") as?
                    String ?? ""
                    let card =  Card(id: cardId, imageUrl: imageUrl, startDate: startDate, ExpiryDate: expiryDate, type: type
                                     , userId: userId)
                    self.cards.append(card)
                    
                    
                    
//                    self.cardTableView.reloadData()
                    
                    
                }
                

            }
            }
        
    }
    
    
    
    @IBAction func handleLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "landingNavigationController") as? UINavigationController {
                vc.modalPresentationStyle = .fullScreen
                UIApplication.shared.windows.first?.rootViewController = vc
          
            }
        }catch {
            print ("ERROR in signout",error.localizedDescription)
        }
    }
    
    
    @IBAction func addNewCardAction(_ sender: UIButton) {
    
      if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
          navigationController?.pushViewController(vc, animated: true)
      }
          }


        
    
}
//        if let identifier = segue.identifier {
//            if identifier == "toCardVC" {
//                let vc = segue.destination as! CardViewController
//                vc.selectedCard = selectedCard
//                vc.selectedCradImage = selectedCardImage
//            }else {
//                let vc = segue.destination as! DetailsViewController
//                vc.selectedCard = selectedCard
//                vc.selectedCardImage = selectedCardImage
//
    
//    func getDifferenceInDays(date: Date) -> Int {
//         let currentDate = Date()
//        let component: Set<Calendar.Component> = [.month,.day, .hour]
//         let difference = Calendar.current.dateComponents(component, from: currentDate, to: date)
//        difference.month
//         return difference.day ?? 0
//     }
//
//}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell") as! CardCell
        return cell.configure(with: cards[indexPath.row])
        
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            print("delete")
//
//
//            guard let userId = Auth.auth().currentUser?.uid else { return }
//            let ref = Firestore.firestore()
//            let cardId = cards[indexPath.row].id
//            ref.collection("card").document(userId).collection("card").document(cardId).delete { error in
//                if let error = error {
//                    print("error in delete \(error.localizedDescription)")
//                }
//            }
//        }
//        editButtonItem.title = "delete".localized
//    }
        
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! CardCell
        let action = UIContextualAction(style: .normal, title: "Edit".localized) { _, _, _ in
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
                vc.selectedCard = self.cards[indexPath.row]
                vc.selectedCradImage = cell.CardImageView.image
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "delete".localized) { (action, view, complectionHandler) in
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let ref = Firestore.firestore()
            let cardId = self.cards[indexPath.row].id
            ref.collection("card").document(userId).collection("card").document(cardId).delete { error in
                if let error = error {
                    print("error in delete \(error.localizedDescription)")
                }
            }
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
   
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CardCell
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
            
        
        vc.selectedCard = cards[indexPath.row]
            vc.selectedCradImage = cell.CardImageView.image
            navigationController?.pushViewController(vc, animated: true)
//
        }
              
    }
}


