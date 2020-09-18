//
//  NewsFeedViewModel.swift
//  HackerNewsClone
//
//  Created by Chad Rutherford on 9/18/20.
//

import Foundation
import SafariServices

class NewsFeedViewModel {
	
	var posts = Posts()
	var items = [Item]()
	
	func showArticle(for post: Post, on viewController: UIViewController) {
		guard let index = items.firstIndex(where: { $0.id == post} ),
			  let urlString = items[index].url,
			  let url = URL(string: urlString) else { return }
		let config = SFSafariViewController.Configuration()
		config.entersReaderIfAvailable = true
		let vc = SFSafariViewController(url: url, configuration: config)
		viewController.present(vc, animated: true)
	}
}

extension NewsFeedViewModel: NewsFeedCellActions {
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
					self.items.append(post)
					cell.titleLabel.text = post.title
				}
			case .failure(let error):
				print(error)
			}
		}
	}
}
