//
//  NewsFeedTableViewController.swift
//  HackerNewsClone
//
//  Created by Chad Rutherford on 9/17/20.
//

import UIKit

protocol NewsFeedActions {
	func fetchPosts(completion: @escaping (Result<Posts, NetworkError>) -> Void)
}

class NewsFeedTableViewController: UITableViewController {
	
	typealias NewsFeedDataSource = UITableViewDiffableDataSource<Int, Int>
	typealias NewsFeedSnapshot = NSDiffableDataSourceSnapshot<Int, Int>
	lazy var dataSource: NewsFeedDataSource = {
		let dataSource = NewsFeedDataSource(tableView: tableView) { tableView, indexPath, post -> UITableViewCell? in
			guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.reuseIdentifier, for: indexPath) as? NewsFeedCell else { fatalError("Unable to dequeue a cell for identifier \(NewsFeedCell.reuseIdentifier)") }
			cell.delegate = self
			cell.post = post
			return cell
		}
		return dataSource
	}()
	var delegate: NewsFeedActions!
	var posts = Posts()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		delegate.fetchPosts { result in
			switch result {
			case .success(let posts):
				self.posts = posts
				DispatchQueue.main.async {
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
		snapshot.appendItems(posts)
		dataSource.apply(snapshot, animatingDifferences: false)
	}
}

extension NewsFeedTableViewController: NewsFeedCellActions {
	func update(_ cell: NewsFeedCell) {
		let networkManager = NetworkManager()
		guard let post = cell.post, let url = URL(string: API.baseURL)?
				.appendingPathComponent(API.item)
				.appendingPathComponent("\(post)")
				.appendingPathExtension(API.json) else { return }
		var request = URLRequest(url: url)
		request.httpMethod = HTTPMethod.get.rawValue
		networkManager.decodeObjects(using: request) { (result: Result<Item, NetworkError>) in
			switch result {
			case .success(let post):
				DispatchQueue.main.async {
					cell.titleLabel.text = post.title
				}
			case .failure(let error):
				print(error)
			}
		}
	}
}
