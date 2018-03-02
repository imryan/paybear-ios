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
    
    let name: String?
    let address: String?
    let enabled: Bool?
    let feeLevel: String?
    let confirmations: Int?
    let defaultConfirmations: Int?
    
    private enum CodingKeys: String, CodingKey {
        case address = "current_payout"
        case feeLevel = "fee_level"
        case defaultConfirmations = "default_confirmations"
        case confirmations
        case name
        case enabled
    }
}

