//
//  DetailsViewController.swift
//  Card-Reminder
//
//  Created by Amal Jeli on 24/05/1443 AH.
//

import UIKit

//
class DetailsViewController: UIViewController {
    var selectedCard:Card?
    var selectedCardImage:UIImage?
//    var selecedUser:UIImage?
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var startDateLabel: UILabel!

    @IBOutlet weak var endDateLabel: UILabel!

    @IBOutlet weak var TaypeLabel: UILabel!
    
    @IBOutlet weak var desStartDate: UILabel!
    {
    didSet {
        desEndDate.text = "StartDate".localized
    }
}
    
    @IBOutlet weak var desEndDate: UILabel!
    {
    didSet {
        desEndDate.text = "EndDate".localized
    }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
        // Do any additional setup after loading the view.
        if let selectedCard = selectedCard,
        let selectedImage = selectedCardImage{
            startDateLabel.text = selectedCard.startDate
            endDateLabel.text = selectedCard.ExpiryDate
            TaypeLabel.text = selectedCard.type
            cardImageView.image = selectedImage
        }
    }
//
//
}
