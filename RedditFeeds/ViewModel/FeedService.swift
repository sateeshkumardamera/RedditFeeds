//
//  FeedCatalogService.swift
//  RedditFeeds
//
//  Created by Sateesh Damera on 7/24/21.
//

import Foundation

protocol FeedService {
    typealias FeedRequest = _FeedService.FeedRequest
    typealias FeedResponse = _FeedService.FeedResponse

    @discardableResult
    func getFeeds(_ request: FeedRequest,
                     completion: @escaping (Result<FeedResponse, Error>) -> Void) -> Cancellable
}

enum _FeedService {
    struct FeedRequest: Equatable {
        var afterLink: String?
    }

    struct FeedResponse {
        var totalCount: Int
        var feeds: FeedData
        var afterLink: String?
    }
}
