//
//  FeedListLoadingCell.swift
//  RedditFeeds
//
//  Created by Sateesh Damera on 7/24/21.
//

import Foundation

import UIKit

class FeedListLoadingCell: UITableViewCell {
    private let spinner = UIActivityIndicatorView(style: .gray)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addAutoLayoutSubview(spinner)

        NSLayoutConstraint.activate(
            [
                contentView.layoutMarginsGuide.topAnchor.constraint(equalTo: spinner.topAnchor),
                contentView.centerXAnchor.constraint(equalTo: spinner.centerXAnchor),
                contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: spinner.bottomAnchor)
            ]
        )

        spinner.startAnimating()
        spinner.hidesWhenStopped = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        spinner.startAnimating()
    }
}
