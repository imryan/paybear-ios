//
//  Rate.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation

open class Rate: Codable {
    
    // MARK: - Attributes
    
    public var name: String?
    public let poloniex: Double?
    public let hitbtc: Double?
    public let bittrex: Double?
    public let bitfinex: Double?
    public let mid: Double?
    
    // MARK: - CodingKeys
    
    private enum CodingKeys: CodingKey {
        case name
        case poloniex
        case hitbtc
        case bittrex
        case bitfinex
        case mid
    }
}
