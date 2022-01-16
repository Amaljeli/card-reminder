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
    
    
    @IBOutlet weak var viewCell: UIView!
    
    
    @IBAction func renewCard(_ sender: Any) {
        
        switch taypeLabel.text{
        case "Id Card".localized :
            UIApplication.shared.open(URL(string: "https://www.absher.sa/portal/landing.html")! as URL, options: [:], completionHandler: nil )
            
        case "Passpot".localized:
            UIApplication.shared.open(URL(string: "https://www.moi.gov.sa/wps/portal/Home/sectors/passports/contents/!ut/p/z0/04_Sj9CPykssy0xPLMnMz0vMAfIjo8ziDTxNTDwMTYy8LUwC3AwcA428nB2dPY0s3M30gxOL9L30o_ArApqSmVVYGOWoH5Wcn1eSWlGiH1GQWFxckF9UUqxqAGcqJBapGuQmZuapGoDUJSaXKJQW6xdku4cDAMzsgY4!/")! as URL, options: [:], completionHandler: nil )
        case "Driving license".localized:
            UIApplication.shared.open(URL(string: "https://dallahdrivingschool.sa")! as URL, options: [:], completionHandler: nil )
            
        case "Al Rajhi Bank".localized:
            UIApplication.shared.open(URL(string: "https://www.alrajhibank.com.sa")! as URL, options: [:], completionHandler: nil )
        case "Al Ahli Bank".localized:
            UIApplication.shared.open(URL(string: "https://www.alahlitadawul.com/GTrade/trading?47a4908f%3A17e45e69ab8%3A-1444")! as URL, options: [:], completionHandler: nil )
        case "Al Enma Bank".localized:
            UIApplication.shared.open(URL(string: "https://www.alinma.com/wps/portal/alinma")! as URL, options: [:], completionHandler: nil )
        case "Al Blad Bank".localized:
            UIApplication.shared.open(URL(string: "https://www.bankalbilad.com/ar/personal/Pages/home.aspx")! as URL, options: [:], completionHandler: nil )
        case "Al Arabi Bank".localized:
            UIApplication.shared.open(URL(string: "https://onlinebanking.anb.com.sa/RetailBank/app/logon.jsp?englang=en_AR")! as URL, options: [:], completionHandler: nil )
        case "samba Bank".localized:
            UIApplication.shared.open(URL(string: "https://www.samba.com/ar/personal-banking/index.aspx")! as URL, options: [:], completionHandler: nil )
            
        case "SCFHS".localized:
            UIApplication.shared.open(URL(string: "https://www.scfhs.org.sa/Pages/default.aspx")! as URL, options: [:], completionHandler: nil )
            
        case "SCE".localized:
            UIApplication.shared.open(URL(string: "https://www.saudieng.sa/English/Pages/default.aspx")! as URL, options: [:], completionHandler: nil )
            
        default:
            print("error")
        }
        }

    
    
//    @IBOutlet weak var remainingPeriodLabel: UILabel!
//    @IBOutlet weak var remainingPeriodLabelImage: UIImageView!
//    @IBOutlet weak var TaypeLabelCell: UILabel!
    
    @IBOutlet weak var expireDaysLabel: UILabel!
    
    
//
//    @IBOutlet weak var startDatelabel: UILabel!
//
//    {
//    didSet {
//        startDatelabel.text = "StartDate".localized
//    }
//}
//
//    @IBOutlet weak var endDatelabel: UILabel!
//    {
//    didSet {
//        endDatelabel.text = "EndDate".localized
//    }
//}
    @IBOutlet weak var expireLabel: UILabel!
    {
    didSet {
        expireLabel.text = "Expire".localized
    }
}
    
    
    @IBOutlet weak var renwalBu: UIButton!{
        didSet{
            renwalBu.setTitle(NSLocalizedString("Renwal".localized, tableName: "LOCALIZED", comment: ""), for:.normal)
   
        }
    }
    
    @IBOutlet weak var yearLabel: UILabel!
    {
    didSet {
//        yearLabel.text = "year" .localized
    }
}
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CardImageView.layer.shadowColor = UIColor.gray.cgColor
            CardImageView.layer.shadowOpacity = 1
        CardImageView.layer.shadowOffset = .zero
        CardImageView.layer.cornerRadius = 10
        CardImageView.layer.shadowPath = UIBezierPath(rect: CardImageView.bounds).cgPath
        CardImageView.layer.shouldRasterize = true
            self.CardImageView.layer.cornerRadius = 10
            
        viewCell.layer.shadowColor = UIColor.gray.cgColor
//        viewCell.layer.shadowOpacity = 1
        viewCell.layer.shadowOffset = .zero
        viewCell.layer.cornerRadius = 10
        viewCell.layer.shadowPath = UIBezierPath(rect: viewCell.bounds).cgPath
        viewCell.layer.shouldRasterize = true
            self.viewCell.layer.cornerRadius = 10
            
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    func configure(with card:Card) -> UITableViewCell {
        CardImageView.loadImageUsingCache(with: card.imageUrl)
        let formatter = DateFormatter()
                formatter.locale = Locale.current
                formatter.calendar = .current
                formatter.dateStyle = DateFormatter.Style.medium
                formatter.timeStyle = DateFormatter.Style.none
         let dateStart = card.startDate.convertToDate()
           let startDate = formatter.string(from: dateStart)
        let dateEnd = card.ExpiryDate.convertToDate()
          let endDate = formatter.string(from: dateEnd)
//            nuStartDateLabel.text = startDate
//            nuEndDateLabel.text = endDate
        
      
        taypeLabel.text = card.type.localized
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
            differenceString += "year".localized + ": \(difference.year ?? 0)"        }
        
        if difference.month != 0 {
            differenceString += "month".localized + ": \(difference.month ?? 0)"
        }
        
        if difference.day != 0 {
            differenceString += "day".localized + ": \(difference.day ?? 0)"
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

