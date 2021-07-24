//
//  FeedListData.swift
//  RedditFeeds
//
//  Created by Sateesh Damera on 7/24/21.
//

import Foundation

struct FeedListData {

    private(set) var feeds: [Children] = []
    private var totalCount = 1 // assume at least one result until we receive the first response

    private var loadMore:String?
    
    private(set) var hasRecordedFailure = false


    var nextRequest: FeedService.FeedRequest {
        return .init(afterLink: loadMore)
    }

    mutating func recordSuccess(response: FeedService.FeedResponse) {
        feeds.append(contentsOf: response.feeds.children!)
        loadMore = response.afterLink
        totalCount = response.totalCount
    }

    mutating func recordFailure(error: Error) {
        hasRecordedFailure = true
    }

    var canLoadMore: Bool {
        return (loadMore != nil)
    }

    func feed(at index: Int) -> Children? {
        guard feeds.indices.contains(index) else {
            return nil
        }

        return feeds[index]
    }
}
