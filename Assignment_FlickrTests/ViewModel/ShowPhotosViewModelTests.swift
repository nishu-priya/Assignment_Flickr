//
//  ShowPhotosViewModelTests.swift
//  Assignment_FlickrTests
//
//  Created by Nishu Priya on 8/22/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import XCTest
@testable import Assignment_Flickr

class ShowPhotosViewModelTests: XCTestCase {
    var viewModel: ShowPhotosViewModel?
    var expectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        viewModel = ShowPhotosViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
    }
    
    func testSuccessCalledIfPageZeroAndPhotCountNotZero() {
        
        expectation = self.expectation(description: "waiting for handler to get called")
        var isCalled = false
        viewModel?.photosFetchSuccessHandler = {
            isCalled = true
            self.expectation?.fulfill()
        }
        viewModel?.pageNum = 0
        viewModel?.handlePhotoFetchResponseSuccess(response: [Photo()])
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(isCalled)
    }
    
    func testFailureCalledIfPageZeroAndPhotCountZero() {
        expectation = self.expectation(description: "waiting for handler to get called")
        var isCalled = false
        viewModel?.photosFetchFailureHandler = {
            isCalled = true
            self.expectation?.fulfill()
        }
        viewModel?.pageNum = 0
        viewModel?.handlePhotoFetchResponseSuccess(response: [Photo]())
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(isCalled)
    }
    
    func testNextBatchSuccessCalledIfPageNonZero() {
        expectation = self.expectation(description: "waiting for handler to get called")
        var isCalled = false
        viewModel?.nextBatchOfPhotosFetchSuccessHandler = { _ in
            isCalled = true
            self.expectation?.fulfill()
        }
        viewModel?.pageNum = 1
        viewModel?.handlePhotoFetchResponseSuccess(response: [Photo]())
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertTrue(isCalled)
    }
    
    func testPageNumberIncrementsByOneOnSuccess() {
        viewModel?.pageNum = 0
        viewModel?.handlePhotoFetchResponseSuccess(response: [Photo()])
        XCTAssert(viewModel?.pageNum == 1)
    }
    
    func testPageNumShouldNotIncrementOnFailue() {
        viewModel?.pageNum = 0
        viewModel?.handlePhotoFetchResponseSuccess(response: [Photo]()) //zero number of photos
        XCTAssert(viewModel?.pageNum == 0)
    }

}
