//
//  MultiAddressResponse.swift
//  CodeChallenge
//
//  Created by cmanahan on 3/31/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import Foundation

class MutliAddressResponse : Decodable {
    private let finalBalance: Satoshi
    private let transactions: [Transaction]
    
    func generateWallet() -> Wallet {
        return Wallet(finalBalance: finalBalance, transactions: transactions)
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case wallet = "wallet"
        case transactions = "txs"
    }
    
    enum WalletCodingKeys: String, CodingKey {
        case finalBalance = "final_balance"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        transactions = try values.decode([Transaction].self, forKey: .transactions)
        
        let balanceContainer = try values.nestedContainer(keyedBy: WalletCodingKeys.self, forKey: CodingKeys.wallet)
        finalBalance = try balanceContainer.decode(Satoshi.self, forKey: .finalBalance)
    }
}
