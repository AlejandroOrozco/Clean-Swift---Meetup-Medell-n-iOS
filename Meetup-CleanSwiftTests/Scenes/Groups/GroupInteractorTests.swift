//
//  GroupInteractorTests.swift
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

class GroupInteractorTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: GroupInteractor!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupGroupInteractor()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupGroupInteractor()
  {
    sut = GroupInteractor()
  }
  
  // MARK: Test doubles
  
  class GroupPresentationLogicSpy: GroupPresentationLogic
  {
    var presentGroupsVerification = false
    var presentGroupDetailVerification = false
    var presentMessageVerification = false
    
    func presentGroups(response: [Group.SearchGroup.Response]) {
      presentGroupsVerification = true
    }
    
    func presentGroupDetail() {
      presentGroupDetailVerification = true
    }
    
    func presentMessage(messageType: messageType) {
      presentMessageVerification = true
    }
  }
  
  class GroupWorkerSpy: GroupWorker {
    var expectation: XCTestExpectation?
    var response: [Group.SearchGroup.Response]?
    var error: NSError?
    
    override func getGroups(with topic: Group.SearchGroup.Request, completionHandler: @escaping ([Group.SearchGroup.Response]?, NSError?) -> Void) {
      completionHandler(response, error)
      expectation?.fulfill()
    }
  }
  
  func testSearchGroup_WhenSearchGroupCalled_WithSuccessResponse() {
    // Given
    let completedExpectation = expectation(description: "Completed")

    let spy = GroupPresentationLogicSpy()
    sut.presenter = spy

    let workerSpy = GroupWorkerSpy()
    workerSpy.expectation = completedExpectation
    sut.worker = workerSpy

    let request = Group.SearchGroup.Request(groupName: "iOS")
    workerSpy.response = [GroupMock.response]
    
    // When
    sut.searchGroup(search: request)
    
    // Then
    wait(for: [completedExpectation], timeout: 2)
    XCTAssertTrue(spy.presentGroupsVerification, "searchGroup() should presentGroups() with a success response")
  }
  
  func testSearchGroup_ShouldCallPresentMessageVerification_WithErrorResponse() {
    // Given
    let completedExpectation = expectation(description: "Completed")
    
    let spy = GroupPresentationLogicSpy()
    sut.presenter = spy
    
    let workerSpy = GroupWorkerSpy()
    workerSpy.expectation = completedExpectation
    sut.worker = workerSpy
    
    let error = NSError(domain: String(), code: Int(), userInfo: nil)
    workerSpy.error = error
    
    let request = Group.SearchGroup.Request(groupName: "iOS")
    
    // When
    sut.searchGroup(search: request)
    
    // Then
    wait(for: [completedExpectation], timeout: 2)
    XCTAssertTrue(spy.presentMessageVerification, "searchGroup() should presentMessage() with an error response")
  }
  
  func testSearchGroup_ShouldCallPresentMessageVerification_WithEmptyResponse() {
    // Given
    let completedExpectation = expectation(description: "Completed")
    
    let spy = GroupPresentationLogicSpy()
    sut.presenter = spy
    
    let workerSpy = GroupWorkerSpy()
    workerSpy.expectation = completedExpectation
    sut.worker = workerSpy

    let response = [Group.SearchGroup.Response]()
    workerSpy.response = response
    let request = Group.SearchGroup.Request(groupName: "iOS")
    
    // When
    sut.searchGroup(search: request)
    
    // Then
    wait(for: [completedExpectation], timeout: 2)
    XCTAssertTrue(spy.presentMessageVerification, "searchGroup() should presentMessage() with an empty response")
  }
  
  
  func testShowGroup_ShouldCallPresentGroup_WithFilledGroup() {
    // Given
    let spy = GroupPresentationLogicSpy()
    sut.presenter = spy

    // When
    sut.showGroup(group: GroupMock.viewModel)

    // Then
    XCTAssertTrue(spy.presentGroupDetailVerification, "showGroup() should presentGroupDetail() with a filled group")
  }
  
  func testShowGroup_ShouldCallPresentMessage_WithEmptyGroup() {
    // Given
    let spy = GroupPresentationLogicSpy()
    sut.presenter = spy

    // When
    sut.showGroup(group: nil)

    // Then
    XCTAssertTrue(spy.presentMessageVerification, "showGroup() should presentMessage() with am empty group")
  }
}