//
//  Cancellable.swift
//  RedditFeeds
//
//  Created by Sateesh Damera on 7/23/21.
//

import Foundation

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {
}
