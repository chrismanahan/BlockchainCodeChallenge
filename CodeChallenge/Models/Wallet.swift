//
//  Wallet.swift
//  CodeChallenge
//
//  Created by cmanahan on 3/30/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import Foundation

class Wallet : Hashable, Codable {
    let finalBalance: Satoshi
    let transactions: [Transaction]
    
    var hashValue: Int {
        return transactions.reduce(finalBalance) { $0 ^ $1.hashValue }
    }
    
    // MARK: - Initialization
    
    init(finalBalance: Satoshi, transactions: [Transaction]) {
        self.finalBalance = finalBalance
        self.transactions = transactions
    }
    
    // MARK: - Equatable
    
    static func ==(lhs: Wallet, rhs: Wallet) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case finalBalance = "final_balance"
        case transactions = "txs"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(finalBalance, forKey: .finalBalance)
        try container.encode(transactions, forKey: .transactions)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        finalBalance = try values.decode(Satoshi.self, forKey: .finalBalance)
        transactions = try values.decode([Transaction].self, forKey: .transactions)
    }
}
