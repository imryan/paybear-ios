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
    
    static func getCurrencies(_ completion: @escaping (_ currencies: [Currency]?) -> ()) {
        guard let token = Paybear.shared.token else { completion(nil); return }
        let url = "\(Constants.BASE_URL)/currencies?token=\(token)"
        
        get(url) { (dict) in
            guard let dict = dict as? Dictionary<String, Dictionary<String, Any>> else { completion(nil); return }
            var currencies: [Currency] = []
            
            dict.forEach({ (key, val) in
                let currencyData = try? JSONSerialization.data(withJSONObject: val, options: [])
                if let currency = try? JSONDecoder().decode(Currency.self, from: currencyData!) {
                    currencies.append(currency)
                }
            })
            
            completion(currencies)
        }
    }
    
    static func getMarketRates(fiat: String, completion: @escaping (_ rate: [Rate]?) -> ()) {
        let url = "\(Constants.BASE_URL)/exchange/\(fiat)/rate"
        
        get(url) { (dict) in
            guard let dict = dict as? Dictionary<String, Dictionary<String, Any>> else { completion(nil); return }
            var rates: [Rate] = []
            
            dict.forEach({ (key, val) in
                let rateData = try? JSONSerialization.data(withJSONObject: val, options: [])
                if let rate = try? JSONDecoder().decode(Rate.self, from: rateData!) {
                    rates.append(rate)
                }
            })
            
            completion(rates)
        }
    }
    
    static func getSingleMarketRate(fiat: String, crypto: String, completion: @escaping (_ rate: Rate?) -> ()) {
        let url = "\(Constants.BASE_URL)/\(crypto)/exchange/\(fiat)/rate"
        
        get(url) { (dict) in
            guard let dict = dict as? Dictionary<String, Dictionary<String, Any>> else { completion(nil); return }
            let rateData = try? JSONSerialization.data(withJSONObject: dict, options: [])
            
            if let rate = try? JSONDecoder().decode(Rate.self, from: rateData!) {
                completion(rate)
            } else {
                completion(nil)
            }
        }
    }
    
    static func createPaymentRequest(crypto: String, callbackURL: String, completion: @escaping (_ request: PaymentRequest?) -> ()) {
        guard let token = Paybear.shared.token else { completion(nil); return }
        let url = "\(Constants.BASE_URL)/\(crypto)/payment/\(callbackURL)?token=\(token)"
        
        get(url) { (dict) in
            guard let dict = dict as? Dictionary<String, String> else { completion(nil); return }
            let requestData = try? JSONSerialization.data(withJSONObject: dict, options: [])
            
            if let request = try? JSONDecoder().decode(PaymentRequest.self, from: requestData!) {
                completion(request)
            } else {
                completion(nil)
            }
        }
    }
}

// MARK: - Helpers

extension Networking {
    
    private static func get(_ endpoint: String, completion: @escaping (_ data: Any?) -> ()) {
        Alamofire.request(endpoint, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success(let json):
                if let dict = json as? Dictionary<String, Any> {
                    // Nested JSON objects
                    if let dataContents = dict["data"] as? Dictionary<String, Dictionary<String, Any>> {
                        completion(dataContents)
                    } else {
                        // Non-nested JSON objects
                        if let dataContents = dict["data"] as? Dictionary<String, String> {
                            completion(dataContents)
                        }
                    }
                }
            case .failure(let error):
                completion(nil)
                print("\(NSStringFromSelector(#function)) error: \(error)")
            }
        }
    }
}
