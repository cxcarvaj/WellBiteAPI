//
//  RefreshRequest.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 5/7/25.
//

import Vapor

/// Represents the data needed for the refresh token request.
///
/// This DTO is used to decode the HTTP request body
/// when a user attempts to refresh token.
struct RefreshRequest: Content {
    /// Token used to obtain new access tokens when they expire.
    let refreshToken: String
}
