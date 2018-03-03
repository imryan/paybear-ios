//
//  PaymentRequest.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation

open class PaymentRequest: Codable {
    
    // MARK: - Attributes
    
    public let invoice: String?
    public let address: String?
    
    private enum CodingKeys: CodingKey {
        case invoice
        case address
    }
}
