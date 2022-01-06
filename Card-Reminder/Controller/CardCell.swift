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
    
    @IBOutlet weak var expireDaysLabel: UILabel!
    
    
    
    @IBOutlet weak var startDatelabel: UILabel!
    
    {
    didSet {
        startDatelabel.text = "StartDate".localized
    }
}

    @IBOutlet weak var endDatelabel: UILabel!
    {
    didSet {
        endDatelabel.text = "EndDate".localized
    }
}
    @IBOutlet weak var expireLabel: UILabel!
    {
    didSet {
        expireLabel.text = "Expire".localized
    }
}
    
    
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
        let expireDate = card.ExpiryDate.convertToDate()
        let differenceFromToday = getDifferenceInDays(date: expireDate)
        expireDaysLabel.text = differenceFromToday
       // TaypeLabelCell = card.
        return self
        
    }
    
    override func prepareForReuse() {
        CardImageView.image = nil
    }
    
    
    
    func getDifferenceInDays(date: Date) -> String {
        let currentDate = Date()
        let component: Set<Calendar.Component> = [.year, .month, .day]
        let difference = Calendar.current.dateComponents(component, from: currentDate, to: date)
        var differenceString = ""
        if difference.year != 0 {
            differenceString += " year: \(difference.year ?? 0)"        }
        
        if difference.month != 0 {
            differenceString += " month: \(difference.month ?? 0)"
        }
        
        if difference.day != 0 {
            differenceString += " day: \(difference.day ?? 0)"
        }
        
        return differenceString
    }
    
}
extension String {
    func convertToDate() -> Date {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd-MM-yyyy"
          dateFormatter.locale = Locale.init(identifier: "en_GB")
          guard let dateObj = dateFormatter.date(from: self) else {return Date()}
          return dateObj
      }
}

