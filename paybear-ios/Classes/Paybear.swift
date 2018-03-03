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
    
    /// Current user object
    public var currentUser: User? {
        if let user = LoginHelper.shared.user {
            return user
        }
        
        return nil
    }
    
    /// Paybear API key
    public var token: String?
    
    // MARK: - Token
    
    open func setToken(_ token: String) {
        self.token = token
    }
    
    // MARK: - Currency
    
    /// Get list of current cryptocurrency prices
    /// API token required
    ///
    /// - Parameter completion: Array of `Currency` objects or an `Error`
    open func getCurrencies(completion: @escaping Callbacks.GetCurrencies) {
        Networking.getCurrencies(completion)
    }
    
    /// Get market exchange rates for all cryptocurrencies
    ///
    /// - Parameters:
    ///   - fiat: Fiat currency type
    ///   - crypto: Cryptocurrency type
    ///   - completion: Array of `Rate` objects or an `Error`
    open func getMarketRates(fiat: PaybearCurrencyType, completion: @escaping Callbacks.GetMarketRates) {
        Networking.getMarketRates(fiat: fiat.rawValue, completion: completion)
    }
    
    /// Get single market exchange rate for one cryptocurrency
    ///
    /// - Parameters:
    ///   - fiat: Fiat currency type
    ///   - crypto: Cryptocurrency type
    ///   - completion: `Rate` object or an `Error`
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
    ///   - completion: `PaymentRequest` object or an `Error`
    open func createPaymentRequest(crypto: PaybearCryptoCurrencyType,
                                   callbackURL: String, completion: @escaping Callbacks.GetPaymentRequest) {
        
        Networking.createPaymentRequest(crypto: crypto.rawValue, callbackURL: callbackURL, completion: completion)
    }
    
    // MARK: - User
    
    /// Login
    ///
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    ///   - twoFactorDelegate: Optional protocol to receive a callback when 2FA is requested
    ///   - completion: `String` value of authorization token or an `Error`
    open func login(email: String, password: String, twoFactorDelegate: TwoFactorAuthProtocol?,
                    completion: @escaping Callbacks.LoginTokenResult) {
        
        Networking.login(email: email, password: password, twoFactorDelegate: twoFactorDelegate, completion: completion)
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
    
    /// Fetches a `User` object with attributes
    /// Authorization token reqired
    ///
    /// - Parameter completion: `User` object if successful or an `Error`
    open func getUser(completion: @escaping Callbacks.UserResult) {
        Networking.getUser(completion: completion)
    }
}
