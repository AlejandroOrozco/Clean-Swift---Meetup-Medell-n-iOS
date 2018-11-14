//
//  GroupsAPI.swift
//  Meetup-CleanSwift
//
//  Created by Alejandro Orozco Builes on 11/10/18.
//  Copyright © 2018 Alejandro Orozco Builes. All rights reserved.
//

import Foundation
import Alamofire

protocol IGroupsAPI {
  func getGroups(with topic: Group.SearchGroup.Request, completionHandler: @escaping ([Group.SearchGroup.Response]?, NSError?) -> Void)
}

class GroupsAPI: IGroupsAPI {
  func getGroups(with topic: Group.SearchGroup.Request, completionHandler: @escaping ([Group.SearchGroup.Response]?, NSError?) -> Void) {
    guard let data = try? JSONEncoder().encode(topic),
          let parameters = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
      else { return }
    
    Alamofire.request("https://api.meetup.com/find/groups", method: .get, parameters: parameters, encoding: URLEncoding(destination: .queryString)).validate().responseJSON {
      (response:DataResponse<Any>) in
      switch(response.result) {
      case .success(_):
        if let data = response.data ,
          let groups = try? JSONDecoder().decode([Group.SearchGroup.Response].self, from: data) {
          completionHandler(groups, nil)
        }
        break
      case .failure(let error as NSError):
        completionHandler(nil, error)
        break
      }
    }
  }
}
