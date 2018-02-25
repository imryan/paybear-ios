//
//  CryptoCurrency.swift
//  Paybear iOS
//
//  Created by Ryan Cohen on 2/24/18.
//

import Foundation

open class CryptoCurrency: Codable, CustomStringConvertible {
    
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
    
    // https://etherscan.io/address/%s
    // let blockExplorerURL: String?
    
    public var description: String {
        return "Title: \(String(describing: title))\nCode: \(String(describing: code))\nRate: \(String(describing: rate))\nMin: \(String(describing: minimum))\nMax: \(String(describing: maximum))\nDecimals: \(decimals)\nMax confirms: \(String(describing: maxConfirmations))\nMetamask: \(metamask)\nBlock explorer: \(String(describing: blockExplorer))"
    }
    
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
