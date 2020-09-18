//
//  HackerNewsCloneJSONTests.swift
//  HackerNewsCloneTests
//
//  Created by Chad Rutherford on 9/17/20.
//

import XCTest
@testable import HackerNewsClone

class HackerNewsCloneJSONTests: XCTestCase {
	func testPostDecode() {
		let decoder = JSONDecoder()
		let posts = try! decoder.decode(Posts.self, from: postsJSON)
		XCTAssertEqual(posts.count, 500)
	}
}
