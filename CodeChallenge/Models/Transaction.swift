//
//  Transaction.swift
//  CodeChallenge
//
//  Created by cmanahan on 3/30/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import Foundation

typealias Satoshi = Int


/// Defines a transaction in the same way the backend API defines a transaction, less the unrequired fields for our purposes
class Transaction : Hashable, Codable {
    let result: Satoshi
    let fee: Satoshi
    let time: Date
    let hash: String
    let outputs: [TransactionOutput]
    /// A transaction which has a result less than 0 is considered outgoing
    var isOutgoing: Bool {
        return result < 0
    }
    
    var hashValue: Int {
        return hash.hashValue
    }
    
    // MARK: - Initializers
    
    init(result: Satoshi, fee: Satoshi, time: Date, hash: String, outputs: [TransactionOutput]) {
        self.result = result
        self.fee = fee
        self.time = time
        self.hash = hash
        self.outputs = outputs
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
        case outputs = "out"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(result, forKey: .result)
        try container.encode(fee, forKey: .fee)
        try container.encode(time, forKey: .time)
        try container.encode(hash, forKey: .hash)
        try container.encode(outputs, forKey: .outputs)
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decode(Satoshi.self, forKey: .result)
        fee = try values.decode(Satoshi.self, forKey: .fee)
        hash = try values.decode(String.self, forKey: .hash)
        outputs = try values.decode([TransactionOutput].self, forKey: .outputs)
        
        let seconds = try values.decode(TimeInterval.self, forKey: .time)
        time = Date(timeIntervalSince1970: seconds)
    }
}


class TransactionOutput : Hashable, Codable {
    let value: Satoshi
    let index: Int
    let isSpent: Bool
    let xPub: ExtendedPublicKey?
    /// An output is considered change when it includes an xpub
    var isChange: Bool {
        return xPub != nil
    }
    
    var hashValue: Int {
        // for the purpose of this exercise, we'll define uniqueness by it's value and index
        return value ^ index
    }
    
    init(value: Satoshi, index: Int, isSpent: Bool, xPub: ExtendedPublicKey? = nil) {
        self.value = value
        self.index = index
        self.isSpent = isSpent
        self.xPub = xPub
    }
    
    static func ==(lhs: TransactionOutput, rhs: TransactionOutput) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case value
        case index = "tx_index"
        case isSpent = "spent"
        case xPub = "xpub"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(index, forKey: .index)
        try container.encode(isSpent, forKey: .isSpent)
        try container.encode(xPub, forKey: .xPub)
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decode(Satoshi.self, forKey: .value)
        index = try values.decode(Int.self, forKey: .index)
        isSpent = try values.decode(Bool.self, forKey: .isSpent)
        xPub = try? values.decode(ExtendedPublicKey.self, forKey: .xPub)
        
    }
}


struct ExtendedPublicKey: Codable {
    let m: String
    let path: String
}
