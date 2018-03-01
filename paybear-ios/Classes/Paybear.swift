//
//  Paybear.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 02/24/2018.
//  Copyright (c) 2018 Ryan Cohen. All rights reserved.
//

open class Paybear {
    
    // MARK: - Currencies
    
    public enum PaybearCurrencyType: String {
        case usd = "usd"
        case eur = "eur"
        case cad = "cad"
        case rub = "rub"
    }
    
    public enum PaybearCryptoCurrencyType: String {
        case btc = "btc"
        case bch = "bch"
        case etc = "etc"
        case eth = "eth"
        case ltc = "ltc"
        case btg = "btg"
        case dash = "dash"
    }
    
    // MARK: - Attributes
    
    /// Shared instance
    open static let shared = Paybear()
    
    /// Paybear API key
    public var token: String?
    
    // MARK: - Token
    
    open func setToken(_ token: String) {
        self.token = token
    }
    
    // MARK: - Requests
    
    /// Get list of current cryptocurrency prices
    /// API token required
    ///
    /// - Parameter completion: Array of `Currency` objects
    open func getCurrencies(completion: @escaping Callbacks.GetCurrencies) {
        Networking.getCurrencies(completion)
    }
    
    /// Get market exchange rate (fiat -> crypto) for all cryptocurrencies
    ///
    /// - Parameters:
    ///   - fiat: Fiat currency type
    ///   - crypto: Cryptocurrency type
    ///   - completion: Array of `Rate` objects
    open func getMarketRates(fiat: PaybearCurrencyType, completion: @escaping Callbacks.GetMarketRates) {
        Networking.getMarketRates(fiat: fiat.rawValue, completion: completion)
    }
    
    /// Get single market exhchange rate (fiat -> crypto)
    ///
    /// - Parameters:
    ///   - fiat: Fiat currency type
    ///   - crypto: Cryptocurrency type
    ///   - completion: `Rate` object
    open func getSingleMarketRate(fiat: PaybearCurrencyType, crypto: PaybearCryptoCurrencyType,
                                  completion: @escaping Callbacks.GetMarketRateSingle) {
        
        Networking.getSingleMarketRate(fiat: fiat.rawValue, crypto: crypto.rawValue, completion: completion)
    }
    
    /// Create payment request
    /// API token required
    ///
    /// - Parameters:
    ///   - crypto: Cryptocurrency to accept (eth, btc, bch, ltc, dash, btg, etc)
    ///   - callbackURL: Your server callback url (url encoded)
    ///   - completion: `PaymentRequest` object
    open func createPaymentRequest(crypto: PaybearCryptoCurrencyType,
                                   callbackURL: String, completion: @escaping Callbacks.GetPaymentRequest) {
        
        Networking.createPaymentRequest(crypto: crypto.rawValue, callbackURL: callbackURL, completion: completion)
    }
}
