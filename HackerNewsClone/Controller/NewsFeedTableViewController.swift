//
//  NewsFeedTableViewController.swift
//  HackerNewsClone
//
//  Created by Chad Rutherford on 9/17/20.
//

import SafariServices
import UIKit


class NewsFeedTableViewController: UITableViewController {
	
	typealias NewsFeedDataSource = UITableViewDiffableDataSource<Int, Int>
	typealias NewsFeedSnapshot = NSDiffableDataSourceSnapshot<Int, Int>
	lazy var dataSource: NewsFeedDataSource = {
		let dataSource = NewsFeedDataSource(tableView: tableView) { tableView, indexPath, post -> UITableViewCell? in
			guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.reuseIdentifier, for: indexPath) as? NewsFeedCell else { fatalError("Unable to dequeue a cell for identifier \(NewsFeedCell.reuseIdentifier)") }
			cell.delegate = self.viewModel
			cell.post = post
			return cell
		}
		return dataSource
	}()
	var delegate: NewsFeedActions!
	let viewModel = NewsFeedViewModel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		delegate.fetchPosts { result in
			switch result {
			case .success(let posts):
				DispatchQueue.main.async {
					self.viewModel.posts = posts
					self.applySnapshot()
				}
			case .failure(let error):
				print(error)
			}
		}
	}
	
	private func setupUI() {
		title = "Hacker News"
		view.backgroundColor = .systemBackground
		navigationController?.navigationBar.prefersLargeTitles = true
		tableView.register(NewsFeedCell.self, forCellReuseIdentifier: NewsFeedCell.reuseIdentifier)
		tableView.dataSource = dataSource
	}
	
	class func new(delegate: NewsFeedActions) -> NewsFeedTableViewController {
		let newsFeedTableVC = NewsFeedTableViewController(nibName: nil, bundle: nil)
		newsFeedTableVC.delegate = delegate
		return newsFeedTableVC
	}
	
	private func applySnapshot() {
		var snapshot = NewsFeedSnapshot()
		snapshot.appendSections([0])
		snapshot.appendItems(viewModel.posts)
		dataSource.apply(snapshot, animatingDifferences: false)
	}
}

extension NewsFeedTableViewController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let post = viewModel.posts[indexPath.row]
		viewModel.showArticle(for: post, on: self)
	}
}

extension NewsFeedTableViewController {
	
}


