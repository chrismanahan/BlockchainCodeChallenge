//
//  MultiAddressViewModel.swift
//  CodeChallenge
//
//  Created by cmanahan on 4/8/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import Foundation

/// Models a MultiAddressResponse specifically to be used with a view
class MultiAddressViewModel {
    let finalBalance: Satoshi
    var addresses: [String]
    var transactions: [Transaction]
    
    init(finalBalance: Satoshi, addresses: [String], transactions: [Transaction]) {
        self.finalBalance = finalBalance
        self.addresses = addresses
        self.transactions = transactions
    }
    
    convenience init(fromResponse response: MultiAddressResponse) {
        self.init(finalBalance: response.finalBalance,
                  addresses: response.addresses,
                  transactions: response.transactions)
    }
}

