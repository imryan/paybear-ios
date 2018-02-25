//
//  PaymentRequest.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation

open class PaymentRequest: Codable {
    
    // MARK: - Attributes
    
    let invoice: String?
    let address: String?
    
    // MARK: - CodingKeys
    
    private enum CodingKeys: CodingKey {
        case invoice
        case address
    }
}
