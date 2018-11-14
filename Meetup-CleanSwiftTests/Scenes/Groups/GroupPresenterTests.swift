//
//  GroupPresenterTests.swift
//  Meetup-CleanSwift
//
//  Created by Alejandro Orozco Builes on 11/13/18.
//  Copyright (c) 2018 Alejandro Orozco Builes. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

@testable import Meetup_CleanSwift
import XCTest

class GroupPresenterTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: GroupPresenter!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupGroupPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupGroupPresenter()
  {
    sut = GroupPresenter()
  }
  
  // MARK: Test doubles
  
//  class GroupDisplayLogicSpy: GroupDisplayLogic
//  {
//    var displaySomethingCalled = false
//
//    func displaySomething(viewModel: Group.Something.ViewModel)
//    {
//      displaySomethingCalled = true
//    }
//  }
//
  // MARK: Tests
  
//  func testPresentSomething()
//  {
//    // Given
//    let spy = GroupDisplayLogicSpy()
//    sut.viewController = spy
//    let response = Group.Something.Response()
//
//    // When
//    sut.presentSomething(response: response)
//
//    // Then
//    XCTAssertTrue(spy.displaySomethingCalled, "presentSomething(response:) should ask the view controller to display the result")
//  }
}
