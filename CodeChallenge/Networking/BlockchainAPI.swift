//
//  BlockchainAPI.swift
//  CodeChallenge
//
//  Created by cmanahan on 3/30/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import Foundation

enum APIError : Error {
    /// Indicates something was wrong with creating a requesdt
    case invalidRequest
    /// Generic error. Being the nature of this project, i'm not concerned with reacting differntly in UI to specific errors
    case genericError
}

class BlockchainAPI {
    private struct Constants {
        static let host = "https://blockchain.info"
        static let defaultTransactionLimit: UInt = 50
    }
    
    let httpRequester: HTTPRequesting
    
    // MARK: - Initialization
    
    init(httpRequester: HTTPRequesting = HTTPRequester(host: Constants.host)) {
        self.httpRequester = httpRequester
    }
    
    // MARK: - Public
    
    func fetchMultiAddress(_ addresses: [String], limit: UInt = Constants.defaultTransactionLimit, offset: UInt = 0, completion: @escaping ((APIResult<MultiAddressResponse>) -> Void)) {
        guard !addresses.isEmpty else {
            completion(.error(APIError.invalidRequest))
            return
        }
        let activeValue = addresses.joined(separator: "|")
        let params = ["active": activeValue,
                      "n": "\(limit)",
                      "offset": "\(offset)"]
        
        httpRequester.get("/multiaddr", params: params) { result in
            switch result {
            case .error(let error):
                completion(.error(error))
            case .value(let data):
                guard let responseObject = try? JSONDecoder().decode(MultiAddressResponse.self, from: data) else {
                    completion(.error(APIError.genericError))
                    return
                }
                
                completion(.value(responseObject))
            }
        }
    }
}
