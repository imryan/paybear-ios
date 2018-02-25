//
//  CryptoCurrency.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation

open class CryptoCurrency: Codable {
    
    // MARK: - Attributes
    
    let title: String?
    let code: String?
    let rate: Double?
    let minimum: Double?
    let maximum: Double?
    let decimals: Int?
    let maxConfirmations: Int?
    let metamask: Bool?
    let blockExplorer: String?
    
    // TODO: Format wallet address string
    // https://etherscan.io/address/%s
    // let blockExplorerURL: String?
    
    // MARK: - CodingKeys
    
    private enum CodingKeys: CodingKey {
        case title
        case code
        case rate
        case minimum
        case maximum
        case decimals
        case maxConfirmations
        case metamask
        case blockExplorer
    }
}
