//
//  TransactionModelTests.swift
//  TransactionModelTests
//
//  Created by cmanahan on 3/30/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import XCTest
@testable import CodeChallenge

class TransactionModelTests: XCTestCase {

    func testTransaction() {
        let result = 50005
        let fee = 300
        let index: UInt = 39671981
        let time = Date(timeInterval: -1000, since: Date())
        let hash = "kljdkjalsdfu8sdaur83i8u837a8743873"
        let outputs = [randomTransactionIO(), randomTransactionIO()]
        let inputs = [randomTransactionIO(), randomTransactionIO()]
        var transaction = Transaction(result: result, fee: fee, time: time, hash: hash, index: index, outputs: outputs, inputs: inputs)
        
        XCTAssertEqual(transaction.result, result)
        XCTAssertEqual(transaction.fee, fee)
        XCTAssertEqual(transaction.time, time)
        XCTAssertEqual(transaction.hash, hash)
        XCTAssertEqual(transaction.index, index)
        XCTAssertEqual(transaction.outputs, outputs)
        XCTAssertEqual(transaction.isOutgoing, false)
        
        // check case where tx is outgoing
        transaction = Transaction(result: -result, fee: fee, time: time, hash: hash, index: index, outputs: outputs, inputs: inputs)
        XCTAssertEqual(transaction.isOutgoing, true)
    }
    
    func testTransactionIOChange() {
        var output = randomTransactionIO(isChange: true)
        XCTAssertEqual(output.isChange, true)
        output = randomTransactionIO(isChange: false)
        XCTAssertEqual(output.isChange, false)
    }
    
    // MARK: - Helpers
    
    private func randomTransactionIO(isChange: Bool = false) -> TransactionIO {
        let value: Satoshi = Int(arc4random_uniform(100000000))
        let index = Int(arc4random_uniform(100000))
        let isSpent = arc4random_uniform(2) == 1
        let xPub: ExtendedPublicKey? = isChange ? ExtendedPublicKey(m: "kljasdfiusadfiujsdfkjsdf", path: "M/1/130") : nil
        let io = TransactionIO(value: value, index: index, isSpent: isSpent, address: UUID.init().uuidString, xPub: xPub)
        XCTAssertEqual(io.value, value)
        XCTAssertEqual(io.index, index)
        XCTAssertEqual(io.isSpent, isSpent)
        return io
    }
}
