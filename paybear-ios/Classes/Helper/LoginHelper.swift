//
//  LoginHelper.swift
//  paybear-ios
//
//  Created by Ryan Cohen on 3/2/18.
//

import Foundation

class LoginHelper {
    
    /// Shared instance
    static let shared = LoginHelper()
    
    /// Latest login token
    var token: String?
    
    /// Current user object
    var user: User?
    
    /// Store token for current session
    ///
    /// - Parameter token: Latest token from login
    func store(token: String) {
        self.token = token
    }
}
