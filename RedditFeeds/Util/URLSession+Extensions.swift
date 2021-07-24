//
//  URLSession+Extensions.swift
//  RedditFeeds
//
//  Created by Sateesh Damera on 7/23/21.
//

import UIKit

extension URLSession {
    enum ImageTaskError: Error {
        case missingResponse(Error?)
        case missingData(URLResponse)
        case invalidData(Data, URLResponse)
    }

    func imageTask(with url: URL, completionHandler: @escaping (Result<UIImage, Error>) -> Void) -> URLSessionTask {
        return dataTask(with: url) { data, urlResponse, error in
            guard let urlResponse = urlResponse else {
                completionHandler(.failure(ImageTaskError.missingResponse(error)))
                return
            }

            guard let data = data else {
                completionHandler(.failure(ImageTaskError.missingData(urlResponse)))
                return
            }

            guard let image = UIImage(data: data) else {
                completionHandler(.failure(ImageTaskError.invalidData(data, urlResponse)))
                return
            }

            completionHandler(.success(image))
        }
    }
}
