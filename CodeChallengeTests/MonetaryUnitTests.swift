//
//  MonetaryUnitTests.swift
//  CodeChallengeTests
//
//  Created by cmanahan on 4/8/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import XCTest
@testable import CodeChallenge

class MonetaryUnitTests: XCTestCase {
    
    func testUnitConversions() {
        let satoshis: Satoshi = 100000
        XCTAssertEqual(Double(satoshis) / 100000000, satoshis.bitcoinValue)
        
        let bitcoin: Bitcoin = 1
        XCTAssertEqual(bitcoin * 100000000.0, 100000000.0)
    }
}
