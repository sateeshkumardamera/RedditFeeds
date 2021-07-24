//
//  ViewController.swift
//  RedditFeeds
//
//  Created by Sateesh Damera on 7/23/21.
//

import UIKit

class FeedsViewController: UITableViewController {

    private let dataLoader: FeedDataLoader

    init(service: FeedService = APIManager.shared) {
        self.dataLoader = FeedDataLoader(service: service)

        super.init(nibName: nil, bundle: nil)

        dataLoader.onChange = { [weak self] in self?.handleDataLoaderChange(from: $0, to: $1) }
        dataLoader.onError = { [weak self] in self?.handleDataLoaderFailure(error: $0) }

        title = "Feeds"

        tableView.register(FeedListLoadingCell.self, forCellReuseIdentifier: "FeedListLoadingCell")
        tableView.register(FeedListCell.self, forCellReuseIdentifier: "FeedListCell")
        tableView.register(FeedListErrorCell.self, forCellReuseIdentifier: "FeedListErrorCell")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataLoader.loadFeedData()
    }

    // MARK: - Table View

    private enum Section: Int, CaseIterable {
        case feeeds, errors, loading
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .feeeds:
            return dataLoader.data.feeds.count

        case .errors:
            return dataLoader.data.hasRecordedFailure ? 1 : 0

        case .loading:
            return (dataLoader.isLoadingMore || dataLoader.data.canLoadMore) ? 1 : 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .feeeds:
            let cell: FeedListCell = tableView.dequeueReusableCell(withIdentifier: "FeedListCell", for: indexPath) as! FeedListCell
            cell.configure(feedData: dataLoader.data.feeds[indexPath.row].data)
            return cell

        case .errors:
            return tableView.dequeueReusableCell(withIdentifier: "FeedListErrorCell", for: indexPath) as! FeedListErrorCell

        case .loading:
            return tableView.dequeueReusableCell(withIdentifier: "FeedListLoadingCell", for: indexPath) as! FeedListLoadingCell
        }
    }
    
    
    private func handleDataLoaderChange(from oldValue: FeedListData, to newValue: FeedListData) {
        
        DispatchQueue.main.async {
            self.tableView.performBatchUpdates(
                {
//                    var indexPaths: [IndexPath] = []
//                    for row in oldValue.feeds.count..<newValue.feeds.count {
//                        indexPaths.append(IndexPath(row: row, section: Section.feeeds.rawValue))
//                    }
//                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                    self.tableView.reloadSections([Section.feeeds.rawValue, Section.loading.rawValue, Section.errors.rawValue], with: .automatic)
                },
                completion: { [weak self] _ in
                    self?.checkContinueLoading()
                }
            )
        }
        
    }

    private func handleDataLoaderFailure(error: Error) {
        let title: String, message: String

        switch (error as? APIManager.ResponseError) ?? .unknown {
        case .noFeeds:
            title = "No Feeds Found"
            message = "No Feeds Found"

        case .unableToConnect:
            title = "Network Error"
            message = "Network Error"

        case .badResponseStatusCode, .unknown:
            title = "Unable to load feeds"
            message = "Unable to load feeds"
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default)

        alert.addAction(action)
        alert.preferredAction = action

        present(alert, animated: true)
    }

    private func checkContinueLoading() {
        // Continue loading pages of feeds as long as the "loading" cell is being displayed.

        if tableView.indexPathsForVisibleRows?.contains(where: { Section(rawValue: $0.section)! == .loading }) ?? false {
            //Load More Here
            print("Loading More")
            dataLoader.loadMore()
        }
    }

    // Scroll View

    override func scrollViewDidEndDecelerating(_: UIScrollView) {
        checkContinueLoading()
    }



}

