//
//  BaseTest.swift
//  CodeChallengeTests
//
//  Created by cmanahan on 3/31/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import XCTest

class BaseTest: XCTestCase {
    func dataFromStub(_ stubName: String) -> Data? {
        guard let path = Bundle(for: type(of: self)).path(forResource: stubName, ofType: "json") else {
            return nil
        }
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}
