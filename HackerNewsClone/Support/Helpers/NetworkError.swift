//
//  NetworkError.swift
//  HackerNewsClone
//
//  Created by Chad Rutherford on 9/17/20.
//

import Foundation

enum NetworkError: Error {
	case unknownError
	case invalidResponse
	case invalidData
	case decodeError
	
	var localizedDescription: String {
		switch self {
		case .unknownError:
			return "An unknown error occurred."
		case .invalidResponse:
			return "The response from the server was invalid. Please try again"
		case .invalidData:
			return "The data returned from the server was invalid"
		case .decodeError:
			return "There was an error decoding the object"
		}
	}
}
