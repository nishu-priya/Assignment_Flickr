//
//  ImageDownloader.swift
//  Assignment_Flickr
//
//  Created by Nishu Priya on 8/21/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()
class ImageDownloader {
    static var ongoingTasks: [URLSessionTask] = []
    class func cancelTaskWith(identifier: Int) {
       let tasks =  ongoingTasks.filter({task in
            if task.taskIdentifier == identifier {
                return true
            } else {
                return false
            }
        })
        for task in tasks {
            print("cancelling task with id = \(task.taskIdentifier)")
            task.cancel()
        }
    }
    class func downloadImage(url: URL, completion: ((_ image: UIImage?)-> Void)?) -> Int? {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion?(cachedImage)
            return nil
        }
        let task =  URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if error != nil {
                completion?(nil)
                return
            }
            if let data = data {
                if let downloadedImage = UIImage(data: data) {
                    imageCache.setObject(downloadedImage, forKey: url.absoluteString as NSString)
                    completion?(downloadedImage)
                }
            }
        })
        task.resume()
        ongoingTasks.append(task)
        print("\(task.taskIdentifier)")
        return task.taskIdentifier
    }
}
