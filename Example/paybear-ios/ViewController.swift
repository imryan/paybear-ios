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
    private var refreshControl: UIRefreshControl!
    
    private var currencies: [CryptoCurrency] = [] {
        didSet {
            reloadTable()
        }
    }
    
    private var rates: [MarketRate] = [] {
        didSet {
            reloadTable()
        }
    }
    
    // MARK: - Paybear
    
    private func getCurrencies() {
        Paybear.shared.getCurrencies { (currencies, error) in
            if let currencies = currencies, error == nil {
                self.currencies = currencies
            }
        }
    }
    
    private func getMarketRates() {
        Paybear.shared.getMarketRates(fiat: .usd) { (rates, error) in
            if let rates = rates, error == nil {
                self.rates = rates
            }
        }
    }
    
    private func createPaymentRequest() {
        Paybear.shared.createPaymentRequest(crypto: .btc, callbackURL: "http://ryans.online") { (request, error) in
            if let request = request, error == nil {
                let alert = UIAlertController(title: "Payment Request", message: "Invoice #:\(request.invoice!)\nAddress: #\(request.address!)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func login() {
        let alert = UIAlertController(title: "PayBear", message: "Login with email and password", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "you@paybear.io"
            textField.keyboardType = .emailAddress
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "••••••••"
            textField.isSecureTextEntry = true
        }
        
        let loginAction = UIAlertAction(title: "Login", style: .default) { _ in
            if let email = alert.textFields!.first?.text, let password = alert.textFields![1].text {
                Paybear.shared.login(email: email, password: password, completion: { (token, error) in
                    let loginAlert = UIAlertController(title: "PayBear", message: nil, preferredStyle: .alert)
                    loginAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    
                    if let error = error {
                        // We've got an error instead
                        loginAlert.message = "Error: \(error.localizedDescription)"
                    }
                    else if let _ = token {
                        // Enter 2-factor token
                        loginAlert.addTextField(configurationHandler: { (textField) in
                            textField.placeholder = "2-factor authentication code"
                            textField.keyboardType = .numberPad
                        })
                        
                        let twoFactorAction = UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
                            if let code = loginAlert.textFields?.first?.text {
                                Paybear.shared.loginTwoFactor(code: code, completion: { (success) in
                                    print(success ? "success" : "FAILED")
                                })
                            }
                        })
                        
                        loginAlert.addAction(twoFactorAction)
                    }
                    
                    DispatchQueue.main.async {
                        self.present(loginAlert, animated: true, completion: nil)
                    }
                })
            }
        }
        
        alert.addAction(loginAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Functions
    
    @objc private func fetchData() {
        // Fetch currency list
        getCurrencies()
        
        // Fetch market rates
        getMarketRates()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set API key and fetch data
        Paybear.shared.setToken("")
        fetchData()
        
        // Add refresh control
        if #available(iOS 10, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
            self.tableView.addSubview(refreshControl)
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchData))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            createPaymentRequest()
            break
        case 3:
            login()
            break
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return currencies.count
        case 1:
            return rates.count
        case 2:
            return 1
        case 3:
            return 1
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
        case 2:
            return "Payment"
        case 3:
            return "User"
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
            cell.accessoryType = .none
        }
        else if indexPath.section == 1 {
            let rate = rates[indexPath.row]
            cell.textLabel?.text = "\(rate.name ?? "N/A")"
            cell.detailTextLabel?.text = "Bitfinex: $\(rate.bitfinex ?? 0.0)"
            cell.accessoryType = .none
        }
        else if indexPath.section == 2 {
            cell.textLabel?.text = "Create Payment Request"
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = ""
        }
        else if indexPath.section == 3 {
            cell.textLabel?.text = "Login"
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadSections(IndexSet.init(integersIn: 0...2), with: .automatic)
            self.tableView.endUpdates()
            
            self.refreshControl.endRefreshing()
        }
    }
}
