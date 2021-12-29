//
//  HomeViewController.swift
//  Card-Reminder
//
//  Created by Amal Jeli on 23/05/1443 AH.
//

import UIKit
import Firebase
class HomeViewController: UIViewController {
    var cards = [Card]()
    var selectedCard:Card?
    var selectedCardImage:UIImage?
    @IBOutlet weak var cardTableView: UITableView!{
        
    didSet {
        cardTableView.delegate = self
        cardTableView.dataSource = self
        cardTableView.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
    }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
getCards()
        // Do any additional setup after loading the view.
    }
    func getCards() {
        let ref = Firestore.firestore()
        ref.collection("cards").order(by: "createAt" ,descending: true).addSnapshotListener {
            snapshot, error in
            if let error = error {
                print ("DB ERROR Cards",error.localizedDescription)
            }
            if let snapshot = snapshot {
                print("CARD GANGES:",snapshot.documentChanges.count)
                snapshot.documentChanges.forEach { diff in
                    let cardData = diff.document.data()
                    switch diff.type {
                    case .added :
                        
                        if let  userId = cardData["userId"] as? String {
                            ref.collection("users").document(userId).getDocument { userSnapshot, error in
                                if let error = error {
                                    print ("Error user Data",error.localizedDescription)
                                }
                                if let userSnapshot = userSnapshot,
                                   let userData = userSnapshot.data (){
                                    let user = User(dict: userData)
//
                                    let card = Card(dict:cardData,id:diff.document.documentID,user:user)
                                    self.cardTableView.beginUpdates()
                                    if snapshot.documentChanges.count != 1 {
                                        self.cards.append(card)
                                        
                                        self.cardTableView.insertRows(at: [IndexPath(row:self.cards.count - 1,section: 0)],with: .automatic)
                                    }else {
                                        self.cards.insert(card,at:0)
                                      
                                        self.cardTableView.insertRows(at: [IndexPath(row: 0,section: 0)],with: .automatic)
                                    }
                                  
                                    self.cardTableView.endUpdates()
                                    
                                    }
                                    
                                }
                            }
                    case .modified:
                        let cardId = diff.document.documentID

                        if let currentCard = self.cards.first(where: {$0.id == cardId}),
                           let updateIndex = self.cards.firstIndex(where: {$0.id == cardId}){
                            let newCard = Card(dict:cardData, id: cardId, user: currentCard.user)
                            self.cards[updateIndex] = newCard
                         
                                self.cardTableView.beginUpdates()
                                self.cardTableView.deleteRows(at: [IndexPath(row: updateIndex,section: 0)], with: .left)
                                self.cardTableView.insertRows(at: [IndexPath(row: updateIndex,section: 0)],with: .left)
                                self.cardTableView.endUpdates()
                        
                        }
                        
                    case .removed:
                        let cardId = diff.document.documentID
                        if let deleteIndex = self.cards.firstIndex(where: {$0.id == cardId}){
                            self.cards.remove(at:deleteIndex)
                            self.cardTableView.beginUpdates()
                            self.cardTableView.deleteRows(at: [IndexPath(row:deleteIndex,section: 0)], with: .automatic)
                            self.cardTableView.endUpdates()
                        }
                        
                    }
                }
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
    override func prepare(for segue : UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toCardVC" {
                let vc = segue.destination as! CardViewController
                vc.selectedCard = selectedCard
                vc.selectedCradImage = selectedCardImage
            }else {
                let vc = segue.destination as! DetailsViewController
                vc.selectedCard = selectedCard
                vc.selectedCardImage = selectedCardImage
            }
        }
        
    }
           
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell") as! CardCell
        return cell.configure(with: cards[indexPath.row])
        
    }
    
    
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CardCell
        selectedCardImage = cell.CardImageView.image
        selectedCard = cards[indexPath.row]
        if let currentUser = Auth.auth().currentUser,
           currentUser.uid == cards[indexPath.row].user.id{
            performSegue(withIdentifier: "toCardVC", sender: self)
        }else {
            performSegue(withIdentifier: "toDetailsVC", sender: self)
            
        }
    }
}

