//
//  FetchPhotosService.swift
//  Assignment_Flickr
//
//  Created by Nishu Priya on 8/21/18.
//  Copyright © 2018 Nishu Priya. All rights reserved.
//

import UIKit

protocol FetchPhotosServiceProtocol {
    func fetchPhotos(searchString: String, pageNum: Int, completionHandler: ((Error?, FetchPhotosResponse?) -> Void)?)
}
class FetchPhotosService: FetchPhotosServiceProtocol {
    
    let urlString = "https://api.flickr.com/services/rest/"
    
    func fetchPhotos(searchString: String, pageNum: Int, completionHandler: ((Error?, FetchPhotosResponse?) -> Void)?) {
        let url = URL(string: urlString)!
        let session4 = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        let paramString = "method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736& format=json&nojsoncallback=1&safe_search=1&text=\(searchString)&per_page=20&page=\(pageNum)"
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        let task = session4.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let _: Data = data, let _: URLResponse = response, error == nil else {
                print("*****error")
                completionHandler?(error, nil)
                return
            }
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode(FetchPhotosResponse.self, from:
                    data!) //Decode JSON Response Data
                print("model = \(model)")
                completionHandler?(nil, model)
            } catch let parsingError {
                completionHandler?(parsingError, nil)
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}
