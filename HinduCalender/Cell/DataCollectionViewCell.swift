//
//  DataCollectionViewCell.swift
//  HinduCalender
//
//  Created by VISHAL SETH on 2/23/19.
//  Copyright © 2019 Book Keeper. All rights reserved.
//

import UIKit

class DataCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var englishDateLabel: UILabel!
    @IBOutlet weak var viewBg: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.layer.borderColor=UIColor.lightGray.cgColor
//        self.layer.borderWidth=0.5
        // Initialization code
    }

}
