//
//  ChatDetailTableViewCell.swift
//  ChatA
//
//  Created by Philippe Faurie on 4/21/20.
//  Copyright © 2020 Philippe Faurie. All rights reserved.
//

import UIKit

class ChatDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelEmoji: UILabel!
    @IBOutlet weak var counter1: UILabel!
    @IBOutlet weak var counter2: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
