//
//  GroupMock.swift
//  Meetup-CleanSwiftTests
//
//  Created by Alejandro Orozco Builes on 11/13/18.
//  Copyright © 2018 Alejandro Orozco Builes. All rights reserved.
//

@testable import Meetup_CleanSwift
import Foundation


struct GroupMock {
  static let response = Group.SearchGroup.Response(
                id: 0,name: String(),
                city: String(),
                members: 0,
                description: String(),
                groupLink: String(),
                groupPhoto: Group.SearchGroup.Response.GroupPhoto(groupPhoto:String())
             )
  
  static let viewModel = Group.SearchGroup.ViewModel(response: response)
}
