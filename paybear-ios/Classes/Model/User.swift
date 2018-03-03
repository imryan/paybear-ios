//
//  User.swift
//  paybear-ios
//
//  Created by Ryan Cohen on 3/2/18.
//

import Foundation

open class User: Codable {
    
    // This class holds a reference to the currently authenticated user.
    
    public let id: String?
    public let name: String?
    public let email: String?
    public let country: String?
    public let state: String?
    public let lastIP: String?
    
    public var wallets: [Wallet] = []
    
    private enum CodingKeys: String, CodingKey {
        case name = "fullname"
        case lastIP = "last_ip"
        case id
        case email
        case country
        case state
    }
}
