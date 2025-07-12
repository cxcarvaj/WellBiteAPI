//
//  LoginResponse.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 5/7/25.
//

import Vapor

/// Represents the response after a successful login.
///
/// This DTO contains the authentication tokens and basic information
/// of the logged-in user.
struct LoginResponse: Content {
    /// Basic information of the logged-in user
    let user: UserResponse
    /// JWT token to authenticate API requests.
    ///
    /// This token must be included in the Authorization header
    /// of HTTP requests that require authentication.
    let accessToken: String
    /// Token used to obtain new access tokens when they expire.
    let refreshToken: String
    /// Timestamp that indicates when the accessToken will expire.
    let expiresAt: Date
}
