//
//  Item.swift
//  HackerNewsClone
//
//  Created by Chad Rutherford on 9/17/20.
//

import Foundation

struct Item: Codable {
	let id: Int
	let score: Int
	let time: Date
	let title: String
	let url: String?
}
