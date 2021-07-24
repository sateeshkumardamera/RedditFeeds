//
//  FeedListErrorCell.swift
//  RedditFeeds
//
//  Created by Sateesh Damera on 7/24/21.
//

import UIKit

class FeedListErrorCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.text = "Unable to Load Feeds"

        contentView.addAutoLayoutSubview(label)

        NSLayoutConstraint.activate(
            [
                contentView.layoutMarginsGuide.topAnchor.constraint(equalTo: label.topAnchor),
                contentView.layoutMarginsGuide.leadingAnchor.constraint(equalTo: label.leadingAnchor),
                contentView.layoutMarginsGuide.trailingAnchor.constraint(equalTo: label.trailingAnchor),
                contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: label.bottomAnchor)
            ]
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
