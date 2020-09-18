//
//  ReuseIdentifiable.swift
//  HackerNewsClone
//
//  Created by Chad Rutherford on 9/18/20.
//

import Foundation

protocol ReuseIdentifiable {
	static var reuseIdentifier: String { get }
}
