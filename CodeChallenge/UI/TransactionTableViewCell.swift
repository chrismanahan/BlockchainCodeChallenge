//
//  TransactionTableViewCell.swift
//  CodeChallenge
//
//  Created by cmanahan on 4/1/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func setResultValue(_ satoshis: Satoshi) {
        valueLabel.text = "\(abs(satoshis.bitcoinValue)) BTC"

        // color border
        let color = satoshis.bitcoinValue > 0 ? UIColor(rgb: 0x00a651) : UIColor(rgb: 0xf26c4f)
        contentView.layer.borderColor = color.cgColor
        contentView.layer.borderWidth = 1.0
        
        iconImageView.image = satoshis > 0 ? #imageLiteral(resourceName: "bitcoin_received") : #imageLiteral(resourceName: "bitcoin_sent")
    }
    
    func setDateTime(_ date: Date) {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "MM/dd/yyyy"
        dateLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "HH:mm:ss"
        timeLabel.text = formatter.string(from: date)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // inset the content view
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsets(top: 5, left: 2, bottom: 5, right: 2))
    }
}
