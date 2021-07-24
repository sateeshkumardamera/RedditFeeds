//
//  ViewModel.swift
//  RedditFeeds
//
//  Created by Sateesh Damera on 7/23/21.
//

import Foundation
import UIKit


enum Environment {
    case test

    static let current: Environment = .test
}

extension Environment {
    var feedsAPIBaseURL: URL {
        switch self {
        case .test:
            return URL(string: "https://www.reddit.com/.json")!
        }
    }
}


class APIManager {
    
    static let shared: APIManager = {
        // Use a separate session for API calls so we image loads don't block API calls.
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 5
        let session = URLSession(configuration: configuration)

        return APIManager(baseURL: Environment.current.feedsAPIBaseURL, session: session)
    }()

    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession) {
        self.baseURL = baseURL
        self.session = session
    }
}


extension APIManager: FeedService {
    enum ResponseError: Error {
        case badResponseStatusCode(Int)
        case noFeeds
        case unableToConnect(Error)
        case unknown
    }

    @discardableResult
    func getFeeds(_ request: FeedRequest, completion: @escaping (Result<FeedResponse, Error>) -> Void) -> Cancellable {

        var url = baseURL.absoluteString
        if let afterLink = request.afterLink{
            url = url + "?after=\(afterLink)"
        }
        
        let task = session.dataTask(with: URL(string: url)!) { data, urlResponse, error in
            let result: Result<FeedResponse, Error>

            do {
                if let error = error as NSError?, error.domain == NSURLErrorDomain, error.code == NSURLErrorCannotConnectToHost {
                    // Special case for mock server not running
                    throw ResponseError.unableToConnect(error)
                }

                guard let urlResponse = urlResponse as? HTTPURLResponse else {
                    throw error ?? ResponseError.unknown
                }

                guard (200 ..< 300).contains(urlResponse.statusCode) else {
                    throw ResponseError.badResponseStatusCode(urlResponse.statusCode)
                }

                let response = try JSONDecoder().decode(RootModel.self, from: data ?? Data())

                guard let feedData = response.data else{
                    throw ResponseError.noFeeds
                }
                if let feeds = feedData.children{
                    result = .success(FeedResponse(totalCount: feeds.count, feeds: feedData, afterLink:feedData.after ))
                }
                else{
                    throw ResponseError.noFeeds
                }
                
            } catch {
                result = .failure(error)
            }

            DispatchQueue.main.async {
                completion(result)
            }
            
        }

        task.resume()

        return task
    }
}
