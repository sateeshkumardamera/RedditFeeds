//
//  DataLoader.swift
//  RedditFeeds
//
//  Created by Sateesh Damera on 7/24/21.
//

import Foundation


class FeedDataLoader {
    private let service: FeedService

    private(set) var data: FeedListData {
        didSet {
            onChange?(oldValue, data)
        }
    }

    private var currentRequest: (request: FeedService.FeedRequest, task: Cancellable)?

    var onChange: ((_ oldData: FeedListData, _ newData: FeedListData) -> Void)?
    var onError: ((Error) -> Void)?

    init(service: FeedService) {
        self.data = FeedListData()
        self.service = service
    }

    var isLoadingMore: Bool {
        return currentRequest != nil
    }

    func loadFeedData() {
        let request = data.nextRequest
        let task = service.getFeeds(request) { [weak self] in self?.handle(request: request, result: $0) }
        currentRequest = (request: request, task: task)
    }
    func loadMore() {
        guard data.canLoadMore && !isLoadingMore else {
            return
        }

        let request = data.nextRequest
        let task = service.getFeeds(request) { [weak self] in self?.handle(request: request, result: $0) }

        currentRequest = (request: request, task: task)
    }

    private func handle(request: FeedService.FeedRequest,
                        result: Result<FeedService.FeedResponse, Error>)
    {
        assert(currentRequest?.request == request)

        currentRequest = nil

        do {
            data.recordSuccess(response: try result.get())
        } catch {
            data.recordFailure(error: error)
            onError?(error)
        }
    }
}
