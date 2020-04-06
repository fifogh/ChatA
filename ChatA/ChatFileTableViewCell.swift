//
//  ChatFileTableViewCell.swift
//  ChatA
//
//  Created by Philippe Faurie on 4/3/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import UIKit

class ChatFileTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
