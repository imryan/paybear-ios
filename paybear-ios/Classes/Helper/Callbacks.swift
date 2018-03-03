//
//  Callbacks.swift
//  Alamofire
//
//  Created by Ryan Cohen on 2/27/18.
//

import Foundation

open class Callbacks {
    
    /// Returns an array of `CryptoCurrency` objects and/or an `Error`
    public typealias GetCurrencies = (_ currencies: [CryptoCurrency]?, _ error: Error?) -> Void
    
    /// Returns an array of `Rate` objects and/or an `Error`
    public typealias GetMarketRates = (_ rate: [MarketRate]?, _ error: Error?) -> Void
    
    /// Returns a `Rate` object and/or an `Error`
    public typealias GetMarketRateSingle = (_ rate: MarketRate?, _ error: Error?) -> Void
    
    /// Returns a `PaymentRequest` objects and/or an `Error`
    public typealias GetPaymentRequest = (_ request: PaymentRequest?, _ error: Error?) -> Void
    
    /// Returns a token following a login for use in all user-related requests.
    public typealias LoginTokenResult = (_ token: String?, _ error: Error?) -> Void
    
    /// Returns a boolean indicating a successful two-factor authentication.
    public typealias LoginTwoFactorResult = (_ success: Bool) -> Void
    
    /// Returns a `User` object and/or an `Error`
    public typealias UserResult = (_ user: User?, _ error: Error?) -> Void
}
