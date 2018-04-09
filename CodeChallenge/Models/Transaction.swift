//
//  Transaction.swift
//  CodeChallenge
//
//  Created by cmanahan on 3/30/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import Foundation

/// Defines a transaction in the same way the backend API defines a transaction, less the unrequired fields for our purposes
class Transaction : Hashable, Decodable {
    let result: Satoshi
    let fee: Satoshi
    let time: Date
    let hash: String
    let index: UInt
    let outputs: [TransactionIO]
    let inputs: [TransactionIO]
    /// A transaction which has a result less than 0 is considered outgoing
    var isOutgoing: Bool {
        return result < 0
    }
    
    var hashValue: Int {
        return hash.hashValue ^ index.hashValue
    }
    
    // MARK: - Initializers
    
    init(result: Satoshi, fee: Satoshi, time: Date, hash: String, index: UInt, outputs: [TransactionIO], inputs: [TransactionIO]) {
        self.result = result
        self.fee = fee
        self.time = time
        self.hash = hash
        self.index = index
        self.outputs = outputs
        self.inputs = inputs
    }
    
    static func ==(lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case result
        case fee
        case time
        case hash
        case index = "tx_index"
        case outputs = "out"
        case inputs
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decode(Satoshi.self, forKey: .result)
        fee = try values.decode(Satoshi.self, forKey: .fee)
        hash = try values.decode(String.self, forKey: .hash)
        index = try values.decode(UInt.self, forKey: .index)
        outputs = try values.decode([TransactionIO].self, forKey: .outputs)
        
        inputs = try values.decode([NestedTransactionInput].self, forKey: .inputs).map { $0.prev_out }
        
        let seconds = try values.decode(TimeInterval.self, forKey: .time)
        time = Date(timeIntervalSince1970: seconds)
    }
}

// lightweight model to extract the multiple prev_out from the response object
fileprivate class NestedTransactionInput : Decodable {
    let prev_out: TransactionIO
}

