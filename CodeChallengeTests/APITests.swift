//
//  APITests.swift
//  CodeChallengeTests
//
//  Created by cmanahan on 3/31/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import XCTest
@testable import CodeChallenge

class MockHTTPRequester: HTTPRequesting {
    var shouldFail: Bool = false
    var mockResponseData: Data!
    // block that is injected into mock address so we can test the args
    var validationBlock: ((String, [String: String]) -> Void)?
    
    func get(_ path: String, params: [String: String], completion: @escaping ((APIResult<Data>) -> Void)) {
        validationBlock?(path, params)
        if shouldFail {
            completion(.error(NSError()))
        } else {
            completion(.value(mockResponseData))
        }
    }
}

class APITests: BaseTest {
    func testFetchMultiAddress() {
        let expect = expectation(description: "api test")
        let mockRequester = MockHTTPRequester()
        mockRequester.mockResponseData = dataFromStub("multi_addr_stub")
        let api = BlockchainAPI(httpRequester: mockRequester)
        
        api.fetchMultiAddress(["someAddressThatDoesntMatter"]) { result in
            switch result {
            case .error(_):
                XCTAssertTrue(false) // not testing error case
                expect.fulfill()
            case .value(let wallet):
                XCTAssertEqual(wallet.finalBalance, 978813)
                XCTAssertEqual(wallet.transactions.count, 50)
                // just inspecting the first transaction in our stub
                let transaction = wallet.transactions.filter { $0.hash == "054c2b86d1751aa93a2cee563dfb0fa7c2850c92ae7eb4098abf79cae2c928d1"}.first!
                XCTAssertEqual(transaction.time, Date(timeIntervalSince1970: 1522252767))
                XCTAssertEqual(transaction.fee, 2610)
                XCTAssertEqual(transaction.outputs.count, 2)
                XCTAssertEqual(transaction.outputs[0].isChange, true)
                XCTAssertEqual(transaction.outputs[1].isChange, false)
                expect.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
    }
    
    func testFetchMultiAddrRequest() {
        let expect = expectation(description: "api test")
        let addr0 = "testaddr0"
        let addr1 = "testaddr1"
        let limit: UInt = 60
        let offset: UInt = 10
        
        let mockRequester = MockHTTPRequester()
        mockRequester.mockResponseData = dataFromStub("multi_addr_stub")
        mockRequester.validationBlock = { path, params in
            // test params and path are what we expect them to be
            XCTAssertEqual(path, "/multiaddr")
            XCTAssertEqual(params["active"], "\(addr0)|\(addr1)")
            XCTAssertEqual(params["n"], "\(limit)")
            XCTAssertEqual(params["offset"], "\(offset)")
        }
        
        let api = BlockchainAPI(httpRequester: mockRequester)
        api.fetchMultiAddress([addr0, addr1], limit: limit, offset: offset) { result in
            switch result {
            case .error(_):
                XCTAssertTrue(false) // not testing error case
                expect.fulfill()
            case .value(_):
                expect.fulfill()
            }
        }
        
        waitForExpectations(timeout: 1)
    }
}

