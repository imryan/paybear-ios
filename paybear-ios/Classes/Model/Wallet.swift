//
//  Wallet.swift
//  paybear-ios
//
//  Created by Ryan Cohen on 3/2/18.
//

import Foundation

open class Wallet: Codable {
    
    // This class stores an enabled currency in the Paybear account chain.
    
    // MARK: - Attributes
    
    public var name: String?
    public let address: String?
    public let enabled: Bool?
    public let feeLevel: String?
    public let confirmations: Int?
    public let defaultConfirmations: Int?
    
    private enum CodingKeys: String, CodingKey {
        case address = "current_payout"
        case feeLevel = "fee_level"
        case defaultConfirmations = "default_confirmations"
        case confirmations
        case name
        case enabled
    }
}

