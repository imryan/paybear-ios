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
        case usd
        case eur
        case cad
        case rub
    }
    
    public enum PaybearCryptoCurrencyType: String {
        case btc
        case bch
        case etc
        case eth
        case ltc
        case btg
        case dash
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
    
    // MARK: - Currency Requests
    
    /// Get list of current cryptocurrency prices
    /// API token required
    ///
    /// - Parameter completion: Array of `Currency` objects
    open func getCurrencies(completion: @escaping Callbacks.GetCurrencies) {
        Networking.getCurrencies(completion)
    }
    
    /// Get market exchange rates for all cryptocurrencies
    ///
    /// - Parameters:
    ///   - fiat: Fiat currency type
    ///   - crypto: Cryptocurrency type
    ///   - completion: Array of `Rate` objects
    open func getMarketRates(fiat: PaybearCurrencyType, completion: @escaping Callbacks.GetMarketRates) {
        Networking.getMarketRates(fiat: fiat.rawValue, completion: completion)
    }
    
    /// Get single market exchange rate for one cryptocurrency
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
    
    // MARK: - User Requests
    
    /// Login
    ///
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    ///   - completion: `String` value of authorization token
    open func login(email: String, password: String, completion: @escaping Callbacks.LoginTokenResult) {
        Networking.login(email: email, password: password, completion: completion)
    }
    
    /// Complete two-factor authentication
    /// Authorization token reqired
    ///
    /// - Parameters:
    ///   - code: 6 digit two-factor authentication code
    ///   - completion: A `Bool` indicating successful authentication
    open func loginTwoFactor(code: String, completion: @escaping Callbacks.LoginTwoFactorResult) {
        Networking.loginTwoFactor(code: code, completion: completion)
    }
}
