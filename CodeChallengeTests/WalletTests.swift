//
//  WalletTests.swift
//  CodeChallengeTests
//
//  Created by cmanahan on 3/30/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import XCTest
@testable import CodeChallenge

class WalletTests: XCTestCase {
    
    func testInitializer() {
        // TODO: create transaction in base test
        let result = 50005
        let fee = 300
        let time = Date(timeInterval: -1000, since: Date())
        let hash = "kljdkjalsdfu8sdaur83i8u837a8743873"
        let outputs = [randomTransactionOutput(), randomTransactionOutput()]
        var transaction = Transaction(result: result, fee: fee, time: time, hash: hash, outputs: outputs)
        
        let balance = 3836102827
        let wallet = Wallet(finalBalance: balance, transactions: [transaction])
        XCTAssertEqual(wallet.finalBalance, balance)
        XCTAssertEqual(wallet.transactions, [transaction])
    }
    
    // MARK: - Helpers
    
    // TODO: bring to base test and move out assertions
    private func randomTransactionOutput(isChange: Bool = false) -> TransactionOutput {
        let value: Satoshi = Int(arc4random_uniform(100000000))
        let index = Int(arc4random_uniform(100000))
        let isSpent = arc4random_uniform(2) == 1
        let xPub: ExtendedPublicKey? = isChange ? ExtendedPublicKey(m: "kljasdfiusadfiujsdfkjsdf", path: "M/1/130") : nil
        let output = TransactionOutput(value: value, index: index, isSpent: isSpent, xPub: xPub)
        XCTAssertEqual(output.value, value)
        XCTAssertEqual(output.index, index)
        XCTAssertEqual(output.isSpent, isSpent)
        return output
    }
}
