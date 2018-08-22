//
//  Photo.swift
//  Assignment_Flickr
//
//  Created by Nishu Priya on 8/21/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import UIKit

struct Photo: Codable {
    
    var id: String = ""
    var owner: String = ""
    var secret: String = ""
    var server: String = ""
    var farm: Int = 0
    var title: String = ""
    var ispublic: Int = 1
    var isfriend: Int = 0
    var isfamily: Int = 0
    
    var url: String {
        return "http://farm\(farm).static.flickr.com/\(server)/\(id)_\(secret).jpg"
    }    

}
