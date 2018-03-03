//
//  Networking.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation
import Alamofire

public protocol TwoFactorAuthProtocol {
    
    /// Called by `twoFactorDelegate` after login to enter required 2FA code
    func paybearDidRequestTwoFactorAuthentication()
}

class Networking {
    
    // MARK: - Requests
    
    static func getCurrencies(_ completion: @escaping Callbacks.GetCurrencies) {
        if !tokenExists() {
            completion(nil, error("Missing API key.", code: -1))
            return
        }
        
        let endpoint = "currencies"
        get(endpoint) { (dict, error) in
            guard let dict = dict as? Dictionary<String, Dictionary<String, Any>>, error == nil else {
                completion(nil, error)
                return
            }
            
            var currencies: [CryptoCurrency] = []
            dict.forEach({ (key, val) in
                let currencyData = try? JSONSerialization.data(withJSONObject: val, options: [])
                if let currency = try? JSONDecoder().decode(CryptoCurrency.self, from: currencyData!) {
                    currencies.append(currency)
                }
            })
            
            completion(currencies, nil)
        }
    }
    
    static func getMarketRates(fiat: String, completion: @escaping Callbacks.GetMarketRates) {
        let endpoint = "exchange/\(fiat)/rate"
        get(endpoint) { (dict, error) in
            guard let dict = dict as? Dictionary<String, Dictionary<String, Any>>, error == nil else {
                completion(nil, error)
                return
            }
            
            var rates: [MarketRate] = []
            dict.forEach({ (key, val) in
                let rateData = try? JSONSerialization.data(withJSONObject: val, options: [])
                if let rate = try? JSONDecoder().decode(MarketRate.self, from: rateData!) {
                    rate.name = key
                    rates.append(rate)
                }
            })
            
            completion(rates, nil)
        }
    }
    
    static func getSingleMarketRate(fiat: String, crypto: String, completion: @escaping Callbacks.GetMarketRateSingle) {
        let endpoint = "\(crypto)/exchange/\(fiat)/rate"
        get(endpoint) { (dict, error) in
            guard let dict = dict, error == nil else {
                completion(nil, error)
                return
            }
            
            let rateData = try? JSONSerialization.data(withJSONObject: dict, options: [])
            if let rate = try? JSONDecoder().decode(MarketRate.self, from: rateData!) {
                completion(rate, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func createPaymentRequest(crypto: String, callbackURL: String, completion: @escaping Callbacks.GetPaymentRequest) {
        if !tokenExists() {
            completion(nil, error("Missing API key.", code: -1))
            return
        }
        
        let endpoint = "\(crypto)/payment/\(callbackURL)"
        get(endpoint) { (dict, error) in
            guard let dict = dict as? [String : String], error == nil else {
                completion(nil, error)
                return
            }
            
            let requestData = try? JSONSerialization.data(withJSONObject: dict, options: [])
            if let request = try? JSONDecoder().decode(PaymentRequest.self, from: requestData!) {
                completion(request, nil)
                return
            }
            
            completion(nil, error)
        }
    }
    
    // MARK: - User
    
    static func login(email: String, password: String, twoFactorDelegate: TwoFactorAuthProtocol?,
                      completion: @escaping Callbacks.LoginTokenResult) {
        
        let url = URL(string: "\(Constants.API_MEMBERS_BASE_URL)/auth/login")!
        let parameters = ["email" : email, "password" : password]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { (data) in
                
                guard let json = data.value as? [String : Any] else { completion(nil, nil); return }
                
                if let success = json["success"] as? Bool {
                    if success {
                        if let token = json["token"] as? String {
                            // Store token for use in requests and notify listener of 2FA
                            LoginHelper.shared.store(token: token)
                            twoFactorDelegate?.paybearDidRequestTwoFactorAuthentication()
                            
                            completion(token, nil)
                            return
                        }
                    } else {
                        if let description = json["error"] as? String {
                            completion(nil, error(description, code: -4))
                            return
                        }
                    }
                }
                
                completion(nil, data.error)
        }
    }
    
    static func loginTwoFactor(code: String, completion: @escaping Callbacks.LoginTwoFactorResult) {
        guard let token = LoginHelper.shared.token else { completion(false); return }
        
        let url = URL(string: "\(Constants.API_MEMBERS_BASE_URL)/auth/login/token2fa")!
        let parameters = ["code" : code]
        let headers = ["authorization" : "JWT \(token)"]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (data) in
                
                guard let json = data.value as? [String : Any] else { completion(false); return }
                
                if let success = json["success"] as? Bool, let data = json["data"] as? Bool {
                    if success && data {
                        completion(true)
                        return
                    }
                }
                
                completion(false)
        }
    }
    
    static func getUser(completion: @escaping Callbacks.UserResult) {
        guard let token = LoginHelper.shared.token else { completion(nil, nil); return }
        
        let url = URL(string: "\(Constants.API_MEMBERS_BASE_URL)/user")!
        let headers = ["authorization" : "JWT \(token)"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { (response) in
                
                guard let json = response.value as? [String : Any] else { completion(nil, nil); return }
                
                if let data = json["data"] as? [String : Any],
                    let settings = data["chain_settings"] as? [String : Any] {
                    var wallets: [Wallet] = []
                    
                    // Add all available cryptocurrencies
                    settings.forEach({ (key, val) in
                        let walletData = try? JSONSerialization.data(withJSONObject: val, options: [])
                        if let wallet = try? JSONDecoder().decode(Wallet.self, from: walletData!) {
                            wallet.name = key
                            wallets.append(wallet)
                        }
                    })
                    
                    // Parse user object
                    if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []) {
                        if let user = try? JSONDecoder().decode(User.self, from: jsonData) {
                            user.wallets = wallets
                            
                            // Assign/update current user
                            LoginHelper.shared.user = user
                            completion(user, nil)
                        }
                    }
                }
                
                completion(nil, response.error)
        }
    }
    
    static func enableCurrency(_ crypto: String, enable: Bool, address: String?, completion: @escaping Callbacks.EnableCurrencyResult) {
        guard let token = LoginHelper.shared.token else { completion(false); return }
        
        let url = URL(string: "\(Constants.API_MEMBERS_BASE_URL)/user/chainSettings/\(crypto)")!
        let headers = ["authorization" : "JWT \(token)"]
        var parameters: [String : Any]
        
        if let address = address {
            parameters = ["enabled" : enable, "current_payout" : address]
        } else {
            parameters = ["enabled" : enable]
        }
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { (response) in
                
                if let statusCode = response.response?.statusCode {
                    if statusCode == 200 || statusCode == 201 {
                        completion(true)
                        return
                    }
                }
                
                completion(false)
        }
    }
}

// MARK: - Request Helpers

extension Networking {
    
    static func get(_ endpoint: String, completion: @escaping (_ data: Any?, _ error: Error?) -> ()) {
        var url = "\(Constants.API_BASE_URL)/\(endpoint)"
        
        if tokenExists() {
            url.append("?token=\(Paybear.shared.token!)")
        }
        
        Alamofire.request(url, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                guard let json = json as? [String : Any] else {
                    completion(nil, error("Unable to parse response.", code: -3))
                    return
                }
                
                // Check for errors in response
                if let error = error(inJSON: json) {
                    completion(nil, error)
                    
                } else if let dataContents = json["data"] as? [String : Any] {
                    completion(dataContents, nil)
                }
            case .failure(let error):
                completion(nil, error)
                print("\(NSStringFromSelector(#function)) error: \(error)")
            }
        }
    }
    
    // MARK: - Helpers
    
    static func error(inJSON json: [String : Any]) -> Error? {
        if let success = json["success"] as? Bool {
            if success == false {
                if let errors = json["errors"] as? [[String : Any]] {
                    if let message = errors.first?["message"] as? String {
                        return error(message, code: -2)
                    }
                }
            }
        }
        
        return nil
    }
    
    static func tokenExists() -> Bool {
        if let token = Paybear.shared.token {
            if token.isEmpty == false {
                return true
            }
        }
        
        return  false
    }
    
    static func error(_ error: String, code: Int) -> NSError {
        return  NSError(domain: "io.paybear.Paybear", code: code, userInfo: [NSLocalizedDescriptionKey : error])
    }
}
