//
//  HeadlineTableViewCell.swift
//  NewsApp
//
//  Created by Bedri Doğan on 17.03.2022.
//

import UIKit

class HeadlineTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var headlineImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        headlineImageView.layer.cornerRadius = 15
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
