//
//  LogoutRequest.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 5/7/25.
//

import Vapor

/// Represents the data needed for the logout request.
///
/// This DTO is used to decode the HTTP request body
/// when a user attempts to log out.
struct LogoutRequest: Content {
    /// Token used to revoke
    let refreshToken: String
}
