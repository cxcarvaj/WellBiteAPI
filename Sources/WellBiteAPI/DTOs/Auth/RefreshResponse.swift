//
//  RefreshResponse.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 5/7/25.
//

import Vapor

/// Represents the response after a successful refresh token process.
///
/// This DTO contains the access token and expiration date
/// of the logged-in user.
struct RefreshResponse: Content {
    /// JWT token to authenticate API requests.
    let accessToken: String
    /// Timestamp that indicates when the accessToken will expire.
    let expiresAt: Date
}
