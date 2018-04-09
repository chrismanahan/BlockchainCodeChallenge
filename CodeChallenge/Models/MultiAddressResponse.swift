//
//  MultiAddressResponse.swift
//  CodeChallenge
//
//  Created by cmanahan on 3/31/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import Foundation

/// Models a response from the /multiaddr endpoint
class MultiAddressResponse : Decodable {
    let finalBalance: Satoshi
    let transactions: [Transaction]
    let addresses: [String]
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case wallet = "wallet"
        case transactions = "txs"
        case addresses
    }
    
    enum WalletCodingKeys: String, CodingKey {
        case finalBalance = "final_balance"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactions = try values.decode([Transaction].self, forKey: .transactions)
        
        let balanceContainer = try values.nestedContainer(keyedBy: WalletCodingKeys.self, forKey: .wallet)
        finalBalance = try balanceContainer.decode(Satoshi.self, forKey: .finalBalance)
        
        addresses = try values.decode([NestedAddresses].self, forKey: .addresses).map { $0.address }
    }
}

// lightweight model to extract the multiple addresses from the response object 
fileprivate class NestedAddresses: Codable {
    let address: String
}
