//
//  ViewController.swift
//  CodeChallenge
//
//  Created by cmanahan on 3/30/18.
//  Copyright © 2018 Chris Manahan. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var balanceLabel: UILabel!
    
    private let api = BlockchainAPI()
    private var multiAddressViewModel: MultiAddressViewModel?
    // cheap lock to prevent multiple fetch calls at once
    private var isFetching = false

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.text = "xpub6CfLQa8fLgtouvLxrb8EtvjbXfoC1yqzH6YbTJw4dP7srt523AhcMV8Uh4K3TWSHz9oDWmn9MuJogzdGU3ncxkBsAC9wFBLmFrWT9Ek81kQ"
        balanceLabel.text = ""
        tableView.backgroundColor = UIColor(rgb: 0xeeeeee)
    }
    
    // MARK: - Actions
    
    @IBAction func fetchTransactions(_ sender: Any) {
        guard let address = addressTextField.text, !address.isEmpty else {
            return
        }
        
        let button = sender as? UIButton
        button?.setTitle("...", for: .normal)
        button?.isEnabled = false
        addressTextField.resignFirstResponder()
        
        fetchTransactionsForAddress(address) { [unowned self] in
            button?.setTitle("Fetch", for: .normal)
            button?.isEnabled = true
            
            self.balanceLabel.text = "Balance: \(self.multiAddressViewModel?.finalBalance.bitcoinValue ?? 0.0) BTC"
        }
    }
    
    // MARK: - Table View Delegate/Datasource/Prefetch
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return multiAddressViewModel?.transactions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let transaction = multiAddressViewModel?.transactions[indexPath.row] else {
            assert(true) // invalid state
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell") as? TransactionTableViewCell ?? TransactionTableViewCell()
            
        cell.setResultValue(transaction.result)
        cell.setDateTime(transaction.time)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let address = multiAddressViewModel?.addresses.first, !isFetching else {
            return
        }
        
        let last = indexPaths.last?.row ?? 0
        guard last >= multiAddressViewModel!.transactions.count - 1 else {
            return
        }
        
        let nextPage = multiAddressViewModel!.transactions.count != 0
        fetchTransactionsForAddress(address, nextPage: nextPage)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.9)
        UIView.animate(withDuration: 0.3, animations: {
            cell.layer.transform = CATransform3DIdentity
        })
    }
    
    // MARK: - Helpers
    
    private func fetchTransactionsForAddress(_ address: String, nextPage: Bool = false, completion: (() -> Void)? = nil) {
        guard !isFetching else {
            return
        }
        isFetching = true
        api.fetchMultiAddress([address], offset: nextPage ? nextOffset() : 0) { [weak self] result in
            switch result {
            case .error(_):
                break
            case .value(let response):
                if nextPage {
                    // append new transactions to existing viewmodel
                    self?.multiAddressViewModel?.transactions.append(contentsOf: response.transactions)
                } else {
                    // set the new model
                    self?.multiAddressViewModel = MultiAddressViewModel(fromResponse: response)
                }
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.isFetching = false
                    completion?()
                }
            }
        }
    }
    
    private func nextOffset() -> UInt {
        return UInt(multiAddressViewModel?.transactions.count ?? 0)
    }
}

