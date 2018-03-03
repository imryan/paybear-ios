//
//  ViewController.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 02/24/2018.
//  Copyright (c) 2018 Ryan Cohen. All rights reserved.
//

import UIKit
import paybear_ios

class ViewController: UIViewController, TwoFactorAuthProtocol {
    
    // MARK: IBOutlet
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Attributes
    
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
    
    private var user: User? {
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
    
    private func getUser() {
        Paybear.shared.getUser(completion: { (user, error) in
            if let user = user, error == nil {
                self.user = user
            }
        })
    }
    
    private func createPaymentRequest() {
        Paybear.shared.createPaymentRequest(crypto: .btc, callbackURL: "http://ryans.online") { (request, error) in
            if let request = request, error == nil {
                let alert = UIAlertController(title: "Payment Request", message: "Invoice\n\(request.invoice!)\nAddress\n\(request.address!)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func login(email: String, password: String) {
        Paybear.shared.login(email: email, password: password, twoFactorDelegate: self, completion: { (token, error) in
            let alert = UIAlertController(title: "Paybear", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            
            if let error = error {
                // Display error and prompt retry
                alert.message = "Error: \(error.localizedDescription)"
                let retryAction = UIAlertAction(title: "Retry", style: .default, handler: { (_) in
                    self.displayLoginAlert()
                })
                
                alert.addAction(retryAction)
            }
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    private func displayLoginAlert() {
        let alert = UIAlertController(title: "Paybear", message: "Login with email and password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
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
                self.login(email: email, password: password)
            }
        }
        
        alert.addAction(loginAction)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - TwoFactorAuthProtocol
    
    func networkingDidRequestTwoFactorAuthentication() {
        let alert = UIAlertController(title: "2FA", message: "Enter your 6 digit 2FA code", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add 2FA field
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "2-factor authentication code"
            textField.keyboardType = .numberPad
        })
        
        // Two-factor action
        let twoFactorAction = UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
            if let code = alert.textFields?.first?.text {
                Paybear.shared.loginTwoFactor(code: code, completion: { (success) in
                    if success {
                        self.getUser()
                        alert.dismiss(animated: true, completion: nil)
                    } else {
                        // Retry two-factor code
                        self.networkingDidRequestTwoFactorAuthentication()
                    }
                })
            }
        })
        
        alert.addAction(twoFactorAction)
        
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
        Paybear.shared.setToken("pub9f2d5e3db59b6db40b57f83d9a33437f")
        fetchData()
        
        // Add refresh control
        if #available(iOS 10, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
            self.tableView.addSubview(refreshControl)
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(fetchData))
        }
        
        // Add large titles because why not
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
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
            if user == nil {
                displayLoginAlert()
            }
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
        return 5
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
            return (user != nil) ? 4 : 1
        case 4:
            return (user != nil) ? (user?.wallets.count)! : 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return currencies.count > 0 ? "Currencies" : nil
        case 1:
            return rates.count > 0 ? "Rates" : nil
        case 2:
            return "Payment"
        case 3:
            return "User"
        case 4:
            return (user != nil) ? "Wallets" : nil
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        
        if indexPath.section == 0 {
            let currency = currencies[indexPath.row]
            cell.textLabel?.text = "\(currency.title!) (\(currency.code!.uppercased()))"
            cell.detailTextLabel?.text = "$\(currency.rate!)"
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }
        else if indexPath.section == 1 {
            let rate = rates[indexPath.row]
            cell.textLabel?.text = "\(rate.name?.uppercased() ?? "N/A")"
            cell.detailTextLabel?.text = "Bitfinex: $\(rate.bitfinex ?? 0.0)"
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }
        else if indexPath.section == 2 {
            cell.textLabel?.text = "Create Payment Request"
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = ""
        }
        else if indexPath.section == 3 {
            guard let user = user else {
                cell.textLabel?.text = "Login"
                cell.accessoryType = .disclosureIndicator
                cell.detailTextLabel?.text = ""
                return cell
            }
            
            cell.accessoryType = .none
            cell.selectionStyle = .none
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = user.name
                cell.detailTextLabel?.text = "Name"
                break
            case 1:
                cell.textLabel?.text = user.email
                cell.detailTextLabel?.text = "Email"
                break
            case 2:
                cell.textLabel?.text = "\(user.state ?? "Somewhere"), \(user.country ?? "Somewhere")"
                cell.detailTextLabel?.text = "Location"
                break
            case 3:
                cell.textLabel?.text = user.lastIP
                cell.detailTextLabel?.text = "Last IP"
                break
            default:
                break
            }
        }
        else if indexPath.section == 4 {
            guard let user = user else { return cell }
            
            let wallet = user.wallets[indexPath.row]
            cell.textLabel?.text = wallet.name?.uppercased()
            cell.detailTextLabel?.text = "\(wallet.enabled! ? "Enabled" : "Disabled") | \(wallet.confirmations!) conf"
        }
        
        return cell
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.tableView.reloadSections(IndexSet.init(integersIn: 0...4), with: .automatic)
            self.tableView.endUpdates()
            
            self.refreshControl.endRefreshing()
        }
    }
}
