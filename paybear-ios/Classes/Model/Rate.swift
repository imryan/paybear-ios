//
//  Rate.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation

open class Rate: Codable, CustomStringConvertible {
    
    // MARK: - Attributes
    
    let name: String?
    let polinex: Double?
    let hitbtc: Double?
    let bittrex: Double?
    let bitfinex: Double?
    let mid: Double?
    
    public var description: String {
        return "Name: \(name)\nPolinex: \(polinex)\nHitbtc: \(hitbtc)\nBittrex: \(bittrex)\nBitfinex: \(bitfinex)\nMid: \(mid)"
    }
    
    // MARK: - CodingKeys
    
    private enum CodingKeys: CodingKey {
        case name
        case polinex
        case hitbtc
        case bittrex
        case bitfinex
        case mid
    }
}
