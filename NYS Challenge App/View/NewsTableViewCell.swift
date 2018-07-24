//
//  NewsTableViewCell.swift
//  NYS Challenge App
//
//  Created by Fikri Karadereli on 23.07.2018.
//  Copyright © 2018 Fikri Karadereli. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    // IBOutlets
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDetailTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
}
