//
//  Configure.swift
//  HackerNewsClone
//
//  Created by Chad Rutherford on 9/18/20.
//

import Foundation

func configure<T>(_ item: T, modify: ((inout T) -> Void)) -> T {
	var copy = item
	modify(&copy)
	return copy
}
