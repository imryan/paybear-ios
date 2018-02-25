//
//  Rate.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation

open class Rate: Codable {
    
    // MARK: - Attributes
    
    let name: String?
    let polinex: Double?
    let hitbtc: Double?
    let bittrex: Double?
    let bitfinex: Double?
    let mid: Double?
    
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
