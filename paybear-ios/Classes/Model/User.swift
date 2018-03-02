//
//  User.swift
//  paybear-ios
//
//  Created by Ryan Cohen on 3/2/18.
//

import Foundation

open class User: Codable {
    
    // This class holds a reference to the currently authenticated user.
    
    let id: String?
    let name: String?
    let email: String?
    let country: String?
    let state: String?
    let lastIP: String?
    let wallets: [Wallet]?
    
    private enum CodingKeys: String, CodingKey {
        case name = "fullname"
        case lastIP = "last_ip"
        case id
        case email
        case country
        case state
        case wallets = "chain_settings"
    }
}
