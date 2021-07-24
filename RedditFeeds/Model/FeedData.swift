//
//  Feed.swift
//  RedditFeeds
//
//  Created by Sateesh Damera on 7/23/21.
//


import Foundation
struct FeedData : Codable {
	let after : String?
	let dist : Int?
	let modhash : String?
	let geo_filter : String?
	let children : [Children]?
	let before : String?
}
