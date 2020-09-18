//
//  NewsFeedActions.swift
//  HackerNewsClone
//
//  Created by Chad Rutherford on 9/18/20.
//

import Foundation

protocol NewsFeedActions {
	func fetchPosts(completion: @escaping (Result<Posts, NetworkError>) -> Void)
}
