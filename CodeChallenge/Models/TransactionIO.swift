//
//  TransactionIO.swift
//  CodeChallenge
//
//  Created by cmanahan on 4/8/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import Foundation


/// Models a single transaction input or output
class TransactionIO : Hashable, Decodable {
    let value: Satoshi
    let index: Int
    let isSpent: Bool
    let address: String
    let xPub: ExtendedPublicKey?
    /// An output is considered change when it includes an xpub
    var isChange: Bool {
        return xPub != nil
    }
    
    var hashValue: Int {
        // for the purpose of this exercise, we'll define uniqueness by it's value and index
        return value ^ index
    }
    
    init(value: Satoshi, index: Int, isSpent: Bool, address: String, xPub: ExtendedPublicKey? = nil) {
        self.value = value
        self.index = index
        self.isSpent = isSpent
        self.address = address
        self.xPub = xPub
    }
    
    static func ==(lhs: TransactionIO, rhs: TransactionIO) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case value
        case index = "tx_index"
        case isSpent = "spent"
        case address = "addr"
        case xPub = "xpub"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        value = try values.decode(Satoshi.self, forKey: .value)
        index = try values.decode(Int.self, forKey: .index)
        isSpent = try values.decode(Bool.self, forKey: .isSpent)
        address = try values.decode(String.self, forKey: .address)
        xPub = try? values.decode(ExtendedPublicKey.self, forKey: .xPub)
    }
}

// Represents an xPub from api responses 
struct ExtendedPublicKey: Decodable {
    let m: String
    let path: String
}
