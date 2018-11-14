//
//  GroupTableViewCell.swift
//  Meetup-CleanSwift
//
//  Created by Alejandro Orozco Builes on 11/10/18.
//  Copyright © 2018 Alejandro Orozco Builes. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

  @IBOutlet weak var groupName: UILabel!
  @IBOutlet weak var groupLocation: UILabel!
  @IBOutlet weak var membersCount: UILabel!
  @IBOutlet weak var groupImage: UIImageView!
  @IBOutlet weak var salmonSquare: UIView!

  var group: Group.SearchGroup.ViewModel? {
    didSet{
      updateUI()
    }
  }

  func updateUI() {
    groupName.text = group?.name
    groupLocation.text = group?.city
    membersCount.text = group?.members?.description
    groupImage.imageFromServerURL(urlString: group?.groupPhoto)
  }

}
