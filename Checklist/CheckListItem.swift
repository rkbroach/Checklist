//
//  CheckListItem.swift
//  Checklist
//
//  Created by Rohan Kevin Broach on 6/24/19.
//  Copyright © 2019 rkbroach. All rights reserved.
//

import Foundation

class CheckListItem: NSObject {
  
  @objc var text = ""
  var checked = false
  
  func toggleChecked() {
    checked = !checked
  }
  
}
