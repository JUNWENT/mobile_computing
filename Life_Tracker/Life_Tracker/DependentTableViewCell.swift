//
//  DependentTableViewCell.swift
//  Life_Tracker
//
//  Created by Mingyan Wei on 4/10/17.
//  Copyright © 2017 Microsoft. All rights reserved.
//

import UIKit

class DependentTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
                // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
