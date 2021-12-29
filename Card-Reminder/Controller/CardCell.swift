//
//  CardCell.swift
//  Card-Reminder
//
//  Created by Amal Jeli on 24/05/1443 AH.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet weak var CardImageView: UIImageView!
    @IBOutlet weak var nuStartDateLabel: UILabel!
    @IBOutlet weak var nuEndDateLabel: UILabel!
    @IBOutlet weak var taypeLabel: UILabel!
    @IBOutlet weak var remainingPeriodLabel: UILabel!
    @IBOutlet weak var remainingPeriodLabelImage: UIImageView!
    @IBOutlet weak var TaypeLabelCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    
    func configure(with card:Card) -> UITableViewCell {
        CardImageView.loadImageUsingCache(with: card.imageUrl)
        nuStartDateLabel.text = card.startDate
        nuEndDateLabel.text = card.ExpiryDate
        taypeLabel.text = card.type
       // TaypeLabelCell = card.
        return self
        
    }
    
    override func prepareForReuse() {
        CardImageView.image = nil
    }
    
    
    
}
