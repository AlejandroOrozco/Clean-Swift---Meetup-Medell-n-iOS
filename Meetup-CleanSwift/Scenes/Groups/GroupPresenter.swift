//
//  GroupPresenter.swift
//  Meetup-CleanSwift
//
//  Created by Alejandro Orozco Builes on 11/10/18.
//  Copyright (c) 2018 Alejandro Orozco Builes. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol GroupPresentationLogic
{
  func presentGroups(response: [Group.SearchGroup.Response])
  func presentGroupDetail()
  func presentMessage(messageType: messageType)
}

class GroupPresenter: GroupPresentationLogic
{
  weak var viewController: GroupDisplayLogic?

  // MARK: - SearchGroups

  func presentGroups(response: [Group.SearchGroup.Response]) {
    let viewModel = response.map({ Group.SearchGroup.ViewModel(response: $0)})
    viewController?.displayGroups(viewModel: viewModel)
  }
  
  func presentGroupDetail() {
    viewController?.displayGroupDetail()
  }
  
  func presentMessage(messageType: messageType) {
    switch messageType {
    case .error:
      let message = "DefaultError".localized()
      viewController?.displayMessage(message: message)
      break
    case .notFound(let search):
      let message = "NoSearchResults".localizedWithArgs(args: search)
      viewController?.displayMessage(message: message)
      break 
    }
  }
}
