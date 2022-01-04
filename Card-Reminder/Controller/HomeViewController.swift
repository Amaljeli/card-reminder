//
//  HomeViewController.swift
//  Card-Reminder
//
//  Created by Amal Jeli on 23/05/1443 AH.
//

import UIKit
import Firebase
class HomeViewController: UIViewController {
    var cards = [Card](){
//    var selectedCard:Card?
//    var selectedCardImage:UIImage?
    
//    var cards = [Card]() {
        didSet {
            self.cardTableView.reloadData()
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
                                 }
                                 if let userSnapshot = userSnapshot,
                                    let userData = userSnapshot.data(){
                                     let user = User(dict:userData)
                                     print("+++\(user)+++")
                                     self.userNameLable.text = user.name
//                                     self.userEmailLable.text = user.email
//                                     self.userPhoneLable.text = "\(user.phoneNumber)"
                                    // self.userImageProfile.loadImageUsingCache(with: customer?.imageUrl)
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
                }
                
//        let ref = Firestore.firestore()
//        ref.collection("card").addSnapshotListener {
//            snapshot, error in
//            if let error = error {
//                print ("DB ERROR Cards",error.localizedDescription)
//            }
//            if let snapshot = snapshot {
//                print("CARD GANGES:",snapshot.documents.count)
//
//                snapshot.documents.forEach { docement in
//                    let  userId = docement.get("userId") as? String ?? ""
//                    let imageUrl = docement.get("imageUrl") as? String ?? ""
//                  print(userId)
//                    let card =  Card(id: "", imageUrl: imageUrl, startDate: "12-02-2019", ExpiryDate: "12-02-2022", type: "Card Bank", userId: userId)
//                    self.cards.append(card)
//                    self.cardTableView.reloadData()
//
//                }
//                let dateCreatedAt = Date(timeIntervalSince1970: 1640544212)
//                print("difference \(self.getDifferenceInDays(date: dateCreatedAt))")

//                snapshot.documents.forEach { documen
//                    if let  userId = cardData["userId"] as? String {
//                        ref.collection("users").document(userId).getDocument { userSnapshot, error in
//                            if let error = error {
//                                print ("Error user Data",error.localizedDescription)
//                            }
////                            if let userSnapshot = userSnapshot,
////                               let userData = userSnapshot.data (){
////                                let user = User(dict: userData)
//////
////                                let card = Card(dict:cardData,id:diff.document.documentID,user:user)
//                                self.cardTableView.beginUpdates()
////                                if snapshot.documentChanges.count != 1 {
////                                    self.cards.append(card)
////
////                                    self.cardTableView.insertRows(at: [IndexPath(row:self.cards.count - 1,section: 0)],with: .automatic)
////                                }else {
////                                    self.cards.insert(card,at:0)
////
////                                    self.cardTableView.insertRows(at: [IndexPath(row: 0,section: 0)],with: .automatic)
////                                }
////
//                                self.cardTableView.endUpdates()
////
////                                }
////
//                            }
//                        }
//
//                }
            }
            }
        
    }
    
    
    
    @IBAction func handleLogout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "landingNavigationController") as? UINavigationController {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated:true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            
            
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let ref = Firestore.firestore()
            let cardId = cards[indexPath.row].id
            ref.collection("card").document(userId).collection("card").document(cardId).delete { error in
                if let error = error {
                    print("error in delete \(error.localizedDescription)")
                }
            }
        }
    }
        
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as! CardCell
        let action = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
                vc.selectedCard = self.cards[indexPath.row]
                vc.selectedCradImage = cell.CardImageView.image
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return UISwipeActionsConfiguration(actions: [action])
    }

    
    
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CardCell
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CardViewController") as? CardViewController {
            
        
        vc.selectedCard = cards[indexPath.row]
            vc.selectedCradImage = cell.CardImageView.image
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
//        if let currentUser = Auth.auth().currentUser,
//           currentUser.uid == cards[indexPath.row].userId{
//
//            performSegue(withIdentifier: "toCardVC", sender: self)
//        }else {
//            performSegue(withIdentifier: "toDetailsVC", sender: self)
//
//        }
    }
}


