//
//  Networking.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation
import Alamofire

class Networking {
    
    // MARK: - Requests
    
    static func getCurrencies(_ completion: @escaping Callbacks.GetCurrencies) {
        guard let token = Paybear.shared.token else {
            completion(nil, error("Missing API key.", code: -1))
            return
        }
        
        let url = "\(Constants.BASE_URL)/currencies?token=\(token)"
        
        get(url) { (dict, error) in
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
        let url = "\(Constants.BASE_URL)/exchange/\(fiat)/rate"
        
        get(url) { (dict, error) in
            guard let dict = dict as? Dictionary<String, Dictionary<String, Any>>, error == nil else {
                completion(nil, error)
                return
            }
            
            var rates: [Rate] = []
            dict.forEach({ (key, val) in
                let rateData = try? JSONSerialization.data(withJSONObject: val, options: [])
                if let rate = try? JSONDecoder().decode(Rate.self, from: rateData!) {
                    rate.name = key
                    rates.append(rate)
                }
            })
            
            completion(rates, nil)
        }
    }
    
    static func getSingleMarketRate(fiat: String, crypto: String, completion: @escaping Callbacks.GetMarketRateSingle) {
        let url = "\(Constants.BASE_URL)/\(crypto)/exchange/\(fiat)/rate"
        
        get(url) { (dict, error) in
            guard let dict = dict as? Dictionary<String, Dictionary<String, Any>>, error == nil else {
                completion(nil, error)
                return
            }
            
            let rateData = try? JSONSerialization.data(withJSONObject: dict, options: [])
            if let rate = try? JSONDecoder().decode(Rate.self, from: rateData!) {
                completion(rate, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func createPaymentRequest(crypto: String, callbackURL: String, completion: @escaping Callbacks.GetPaymentRequest) {
        guard let token = Paybear.shared.token else {
            completion(nil, error("Missing API key.", code: -1))
            return
        }
        
        let url = "\(Constants.BASE_URL)/\(crypto)/payment/\(callbackURL)?token=\(token)"
        
        get(url) { (dict, error) in
            guard let dict = dict as? Dictionary<String, String>, error == nil else {
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
}

// MARK: - Helpers

extension Networking {
    
    static func get(_ endpoint: String, completion: @escaping (_ data: Any?, _ error: Error?) -> ()) {
        Alamofire.request(endpoint, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                guard let json = json as? [String : Any] else {
                    completion(nil, error("Unable to parse response.", code: -3))
                    return
                }
                
                // Check success
                if let success = json["success"] as? Bool {
                    if !success {
                        // Discover errors
                        if let errors = json["errors"] as? [[String : Any]] {
                            if let message = errors.first?["message"] as? String {
                                completion(nil, error(message, code: -2))
                                return
                            }
                        }
                        completion(nil, nil)
                        return
                    }
                }
                
                // Nested JSON objects
                if let dataContents = json["data"] as? [String : [String : Any]] {
                    completion(dataContents, nil)
                    return
                } else {
                    // Non-nested JSON objects
                    if let dataContents = json["data"] as? [String : String] {
                        completion(dataContents, nil)
                        return
                    }
                }
            case .failure(let error):
                completion(nil, error)
                print("\(NSStringFromSelector(#function)) error: \(error)")
            }
        }
    }
    
    static func error(_ error: String, code: Int) -> NSError {
        return  NSError(domain: "io.paybear.Paybear", code: code, userInfo: [NSLocalizedDescriptionKey : error])
    }
}
