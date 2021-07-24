//
//  FeedListCell.swift
//  RedditFeeds
//
//  Created by Sateesh Damera on 7/23/21.
//

import UIKit
import Darwin

class FeedListCell: UITableViewCell {

    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .preferredFont(forTextStyle: .title3)
        nameLabel.numberOfLines = 2
        return nameLabel
    }()

    private let feedImageView = RemoteImageView()

    private let commentImageView = UIImageView()

    private let numberOfComments: UILabel = {
        let numberOfComments = UILabel()
        numberOfComments.font = .preferredFont(forTextStyle: .caption1)
        return numberOfComments
    }()

    private let scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.font = .preferredFont(forTextStyle: .caption2)
        scoreLabel.textColor = .gray
        return scoreLabel
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        let detailsColumnGuide = UILayoutGuide()

        contentView.addLayoutGuide(detailsColumnGuide)

        contentView.addAutoLayoutSubview(nameLabel)
        contentView.addAutoLayoutSubview(feedImageView)
        contentView.addAutoLayoutSubview(commentImageView)
        contentView.addAutoLayoutSubview(numberOfComments)
        contentView.addAutoLayoutSubview(scoreLabel)

        NSLayoutConstraint.activate(
            [

                detailsColumnGuide.topAnchor.constraint(equalTo: contentView.readableContentGuide.topAnchor),
                detailsColumnGuide.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
                //detailsColumnGuide.leadingAnchor.constraint(equalToSystemSpacingAfter: feedImageView.trailingAnchor, multiplier: 1),
                detailsColumnGuide.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
                detailsColumnGuide.bottomAnchor.constraint(lessThanOrEqualTo: contentView.readableContentGuide.bottomAnchor),//.priority(.defaultHigh),

                nameLabel.topAnchor.constraint(equalTo: detailsColumnGuide.topAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: detailsColumnGuide.leadingAnchor),
                nameLabel.trailingAnchor.constraint(equalTo: detailsColumnGuide.trailingAnchor),

                feedImageView.topAnchor.constraint(equalToSystemSpacingBelow: nameLabel.bottomAnchor, multiplier: 1),
                feedImageView.leadingAnchor.constraint(equalTo: detailsColumnGuide.leadingAnchor),
                feedImageView.trailingAnchor.constraint(lessThanOrEqualTo: detailsColumnGuide.trailingAnchor),
                feedImageView.widthAnchor.constraint(equalTo: detailsColumnGuide.widthAnchor),
//                feedImageView.widthAnchor.constraint(equalTo: feedImageView.heightAnchor, multiplier: 1, constant: 0),
                feedImageView.heightAnchor.constraint(equalToConstant: 180),
 
                commentImageView.topAnchor.constraint(equalToSystemSpacingBelow: feedImageView.bottomAnchor, multiplier: 1),
                commentImageView.leadingAnchor.constraint(equalTo: detailsColumnGuide.leadingAnchor),
                commentImageView.trailingAnchor.constraint(lessThanOrEqualTo: detailsColumnGuide.trailingAnchor),
                commentImageView.bottomAnchor.constraint(equalTo: detailsColumnGuide.bottomAnchor),

                numberOfComments.firstBaselineAnchor.constraint(equalTo: commentImageView.firstBaselineAnchor),
                //ratingLabel.topAnchor.constraint(equalToSystemSpacingBelow: feedImageView.bottomAnchor, multiplier: 1),
                numberOfComments.leadingAnchor.constraint(equalToSystemSpacingAfter: commentImageView.trailingAnchor, multiplier: 1),
                numberOfComments.trailingAnchor.constraint(lessThanOrEqualTo: detailsColumnGuide.trailingAnchor),
                numberOfComments.bottomAnchor.constraint(equalTo: detailsColumnGuide.bottomAnchor),

                scoreLabel.firstBaselineAnchor.constraint(equalTo: numberOfComments.firstBaselineAnchor),
                scoreLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: numberOfComments.trailingAnchor, multiplier: 1),
                scoreLabel.trailingAnchor.constraint(lessThanOrEqualTo: detailsColumnGuide.trailingAnchor),
                scoreLabel.bottomAnchor.constraint(equalTo: detailsColumnGuide.bottomAnchor),

            ]
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(feedData: ChildData?) {
        
        if let imageUrl = feedData?.thumbnail{
            feedImageView.imageURL = URL(string: imageUrl)
            
            if let width = feedData?.thumbnail_width, let height = feedData?.thumbnail_height {
                let ratio = Double(width) / Double(height)
                let presentWidth = Double(self.frame.width)
                let newHeight = presentWidth / ratio
                
                NSLayoutConstraint.activate([
                    feedImageView.heightAnchor.constraint(equalToConstant: CGFloat(newHeight)),
                ])

            }
                        
        }
        
        nameLabel.text = feedData?.title
        if let comments = feedData?.num_comments{
            numberOfComments.text = String(describing: comments)
        }
        if let score = feedData?.score{
            scoreLabel.text = "Score " + String(describing: score)
        }
        
        commentImageView.image = UIImage(systemName: "message.fill")        
        
    }
}
