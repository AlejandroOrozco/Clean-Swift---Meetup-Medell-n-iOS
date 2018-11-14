//
//  GroupRouter.swift
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

@objc protocol GroupRoutingLogic
{
  func routeToGroupDetail(segue: UIStoryboardSegue?)
}

protocol GroupDataPassing
{
  var dataStore: GroupDataStore? { get }
}

class GroupRouter: NSObject, GroupRoutingLogic, GroupDataPassing
{
  weak var viewController: GroupViewController?
  var dataStore: GroupDataStore?
  
  // MARK: Routing
  
  func routeToGroupDetail(segue: UIStoryboardSegue?)
  {
    if let segue = segue {
      let destinationVC = segue.destination as! GroupDetailViewController
      var destinationDS = destinationVC.router!.dataStore!
      destinationVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
      passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    }
  }

  
  
  // MARK: Passing data
  
  func passDataToSomewhere(source: GroupDataStore, destination: inout GroupDetailDataStore)
  {
    destination.groupDetail = source.group
  }
}