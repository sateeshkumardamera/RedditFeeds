//
//  MockFeedService.swift
//  RedditFeedsTests
//
//  Created by Sateesh Damera on 7/24/21.
//

import Foundation
@testable import RedditFeeds
import XCTest

/// A mock implementation of the `FeedService` protocol.
///
/// The goal of this implementation is to support synchronous testing, while still having the `completion` handler
/// executed _after_ `getFeeds()` has returned.
///
/// See `getFeeds()` for a usage example
class MockFeedService: FeedService {
    
    let getFeedsMethod = MockServiceMethod<FeedRequest, FeedResponse>()

    /// A mock implementation of the `FeedService.getFeeds()` method.
    ///
    /// When `getFeeds()` is called, the completion handler is added to `getFeedsMethod`'s list of pending
    /// requests. Afterward, invoking `getFeedsMethod.succeed()` or `.fail()` will invoke that completion handler.
    ///
    /// Example usage:
    /// ```
    /// let mockService = MockFeedService()
    /// var totalCount: Int?
    ///
    /// mockService.getFeeds() { result in
    ///     totalCount = try? result.get().totalCount
    /// }
    ///
    /// // Request is still pending:
    /// XCTAssertNil(totalCount)
    ///
    /// mockService.getFeedsMethod
    ///     .succeed(response: .init(totalCount: 1, feeds: []))
    ///
    /// // Request has completed:
    /// XCTAssertEqual(totalCount, 1)
    /// ```
    @discardableResult
    func getFeeds(_ request: FeedRequest, completion: @escaping (Result<FeedResponse, Error>) -> Void) -> Cancellable {
        return getFeedsMethod.add(request: request, completion: completion)
    }
}
