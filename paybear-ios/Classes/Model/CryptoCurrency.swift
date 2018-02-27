//
//  CryptoCurrency.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation

open class CryptoCurrency: Codable {
    
    // MARK: - Attributes
    
    public let title: String?
    public let code: String?
    public let rate: Double?
    public let minimum: Double?
    public let maximum: Double?
    public let decimals: Int?
    public let maxConfirmations: Int?
    public let metamask: Bool?
    public let blockExplorer: String?
    
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
