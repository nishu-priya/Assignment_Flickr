//
//  PhotosResponse.swift
//  Assignment_Flickr
//
//  Created by Nishu Priya on 8/21/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import UIKit

struct FetchPhotosResponse: Codable  {
    var photos: FetchedPhotosInfo = FetchedPhotosInfo()
    var stat: String = ""
}
struct FetchedPhotosInfo: Codable  {
    var photo: [Photo] = []
    var page: Int = 0
    var pages: Int = 0
    var total: String = ""
    var perpage: Int = 0
}
