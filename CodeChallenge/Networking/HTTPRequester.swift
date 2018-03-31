//
//  HTTPRequester.swift
//  CodeChallenge
//
//  Created by cmanahan on 3/31/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import Foundation

protocol HTTPRequesting {
    func get(_ path: String, params: [String: String], completion: @escaping ((APIResult<Data>) -> Void))
}

extension HTTPRequesting {

    func resolvedHost(_ host: String, path: String, params: [String: String]) -> URL? {
        var path = path
        if path.first != "/" {
            path = "/\(path)"
        }
        var comps = URLComponents(string: "\(host)\(path)")
        comps?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        return comps?.url
    }
}

class HTTPRequester: HTTPRequesting {
    
    let host: String
    
    init(host: String) {
        self.host = host
    }
    
    func get(_ path: String, params: [String: String], completion: @escaping ((APIResult<Data>) -> Void)) {
        guard let url = resolvedHost(host, path: path, params: params) else {
            completion(.error(APIError.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {
                completion(.error(error ?? APIError.genericError)) // unknown error if error is nil, but so is data. shouldn't happen, but just in case
                return
            }
            completion(.value(data))
        }
        task.resume()
    }
}
