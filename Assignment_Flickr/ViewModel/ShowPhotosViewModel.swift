//
//  ShowPhotosViewModel.swift
//  Assignment_Flickr
//
//  Created by Nishu Priya on 8/21/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import Foundation
import UIKit

class ShowPhotosViewModel {
    
    let kNoResutsText = "No results found"
    let kBatchSize = 20
    
    var photos: [Photo] = []
    var taskIdenfiers:[Int?] = []
    let serviceModel = FetchPhotosService()
    var pageNum: Int = 0
    var photosFetchFailureHandler: (() -> Void)?
    var photosFetchSuccessHandler: (() -> Void)?
    var nextBatchOfPhotosFetchSuccessHandler: (([IndexPath]) -> Void)?
    var isFetching: Bool = false
    
    func fetchPhotos(searchText: String) {
        if isFetching {
            return
        }
        isFetching = true
        serviceModel.fetchPhotos(searchString: searchText, pageNum: pageNum, completionHandler: { error, response in
            if let response = response {
                self.handlePhotoFetchResponseSuccess(response: response.photos.photo)
            } else {
                DispatchQueue.main.async {
                    self.photosFetchFailureHandler?()
                }
            }
        })
    }
    
    func handlePhotoFetchResponseSuccess(response: [Photo]) {
        if self.pageNum == 0 {
            self.photos = response
            self.taskIdenfiers = Array(repeating: nil, count: self.photos.count)
            if photos.count > 0 {
                self.pageNum += 1
            }
            DispatchQueue.main.async {
                if self.photos.count > 0 {
                    self.photosFetchSuccessHandler?()
                } else {
                    self.photosFetchFailureHandler?()
                }
            }
        } else {
            var indexPaths: [IndexPath] = []
            let startIndex = self.photos.count
            self.photos.append(contentsOf: response)
            let newTaskIds:[Int?] = Array(repeating: nil, count: response.count)
            self.taskIdenfiers.append(contentsOf: newTaskIds)
            for i in startIndex..<self.photos.count {
                indexPaths.append(IndexPath(item: i, section: 0))
            }
            DispatchQueue.main.async {
                self.nextBatchOfPhotosFetchSuccessHandler?(indexPaths)
            }
            self.pageNum += 1
        }
        self.isFetching = false
    }
}
