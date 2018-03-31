//
//  APIResult.swift
//  CodeChallenge
//
//  Created by cmanahan on 3/30/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import Foundation

enum APIResult<T> {
    case error(Error)
    case value(T)
}
