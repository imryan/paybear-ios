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
    public typealias GetMarketRates = (_ rate: [Rate]?, _ error: Error?) -> Void
    
    /// Returns a `Rate` object and/or an `Error`
    public typealias GetMarketRateSingle = (_ rate: Rate?, _ error: Error?) -> Void
    
    /// Returns a `PaymentRequest` objects and/or an `Error`
    public typealias GetPaymentRequest = (_ request: PaymentRequest?, _ error: Error?) -> Void
}
