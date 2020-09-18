//
//  NewsFeedCell.swift
//  HackerNewsClone
//
//  Created by Chad Rutherford on 9/17/20.
//

import UIKit

protocol ReuseIdentifiable {
	static var reuseIdentifier: String { get }
}

protocol NewsFeedCellActions {
	func update(_ cell: NewsFeedCell)
}

class NewsFeedCell: UITableViewCell {
	
	lazy var titleLabel = configure(UILabel()) {
		addSubview($0)
		$0.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			$0.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			$0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
			$0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
			$0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
		])
		$0.textColor = .label
		$0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
		$0.numberOfLines = 0
		$0.lineBreakMode = .byWordWrapping
	}
	
	var delegate: NewsFeedCellActions!
	var post: Post? {
		didSet {
			delegate.update(self)
			
		}
	}
}

extension NewsFeedCell: ReuseIdentifiable {
	static var reuseIdentifier: String {
		String(describing: Self.self)
	}
}
