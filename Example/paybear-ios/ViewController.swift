//
//  ViewController.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 02/24/2018.
//  Copyright (c) 2018 Ryan Cohen. All rights reserved.
//

import UIKit
import paybear_ios

class ViewController: UIViewController {
    
    // MARK: Attributes
    
    @IBOutlet weak var tableView: UITableView!
    
    var currencies: [CryptoCurrency] = []
    var rates: [Rate] = []
    
    // MARK: - Paybear
    
    func getCurrencies() {
        Paybear.shared.getCurrencies { (currencies, error) in
            if let currencies = currencies, error == nil {
                self.currencies = currencies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                print("Currencies: \(currencies!) | Err: \(error?.localizedDescription)")
            }
        }
    }
    
    func getMarketRates() {
        Paybear.shared.getMarketRates(fiat: .usd) { (rates, error) in
            if let rates = rates, error == nil {
                self.rates = rates
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //
    // // Get market exchange rates for all cryptocurrencies
    // Paybear.shared.getMarketRates(fiat: .usd) { (rates) in
    //     if let rates = rates {
    //         print(rates)
    //     }
    // }
    //
    // // Get single market exchange rate for cryptocurrency
    // Paybear.shared.getSingleMarketRate(fiat: .usd, crypto: .btc) { (rate) in
    //     if let rate = rate {
    //         print(rate)
    //     }
    // }
    //
    // // Create payment request in given cryptocurrency
    // Paybear.shared.createPaymentRequest(crypto: .btc, callbackURL: "http://ryans.online") { (request) in
    //     if let request = request {
    //         print(request)
    //     }
    // }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch currency list
        getCurrencies()
        
        // Fetch market rates
        getMarketRates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return currencies.count
        case 1:
            return rates.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Currencies"
        case 1:
            return "Rates"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        
        if indexPath.section == 0 {
            let currency = currencies[indexPath.row]
            cell.textLabel?.text = "\(currency.title!) (\(currency.code!))"
            cell.detailTextLabel?.text = "$\(currency.rate!)"
        }
        else if indexPath.section == 1 {
            let rate = rates[indexPath.row]
            cell.textLabel?.text = "\(rate.name ?? "N/A")"
            cell.detailTextLabel?.text = "Polinex: $\(rate.poloniex ?? 0.0)"
        }
        
        return cell
    }
}
