//
//  ChecklistTableViewCell.swift
//  Checklist
//
//  Created by Rohan Kevin Broach on 6/25/19.
//  Copyright © 2019 rkbroach. All rights reserved.
//

import UIKit

class ChecklistTableViewCell: UITableViewCell {

  @IBOutlet weak var checkmarkLabel: UILabel!
  @IBOutlet weak var todoTextLabel: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
