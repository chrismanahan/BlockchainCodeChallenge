//
//  MonetaryUnits.swift
//  CodeChallenge
//
//  Created by cmanahan on 4/7/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import Foundation

fileprivate struct UnitConstants {
    static let SatoshisPerBitcoin: Satoshi = 100000000
}

/// Internally represents values that are denominated as Satoshi
typealias Satoshi = Int
/// Internally represents values that are denominated as Bitcoin
typealias Bitcoin = Double


extension Satoshi {
    var bitcoinValue: Bitcoin {
        return Double(self) / Double(UnitConstants.SatoshisPerBitcoin)
    }
}


extension Bitcoin {
    var satoshiValue: Satoshi {
        return Satoshi(self * Double(UnitConstants.SatoshisPerBitcoin))
    }
}
