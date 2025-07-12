//
//  TokenService.swift
//  WellBiteAPI
//
//  Created by Carlos Xavier Carvajal Villegas on 5/7/25.
//

import Vapor
import Fluent
import JWT

/// A service that handles authentication token operations.
///
/// `TokenService` provides functionality for generating, verifying, revoking,
/// and refreshing authentication tokens in the application. It manages both
/// access tokens (JWT) and refresh tokens for user authentication.
///
/// ## Overview
///
/// The token service handles the complete lifecycle of authentication tokens:
///
/// - Generating access and refresh tokens for authenticated users
/// - Verifying refresh tokens to ensure they are valid
/// - Revoking tokens when needed (e.g., on logout)
/// - Refreshing access tokens using a valid refresh token
///
/// This service is designed to work with a database that stores refresh tokens
/// while access tokens are generated as JWTs.
struct TokenService {
    /// Generates a pair of authentication tokens for a user.
    ///
    /// This method creates both an access token (JWT) and a refresh token for the given user.
    /// The access token is used for API authorization, while the refresh token is stored in the
    /// database and can be used to obtain a new access token when the original expires.
    ///
    /// - Parameters:
    ///   - user: The user for whom the tokens are being generated.
    ///   - db: The database on which to save the refresh token.
    ///
    /// - Returns: A tuple containing the access token payload and the refresh token.
    ///
    /// - Throws:
    ///     - An error if token generation or database operations fail.
    ///     - `Abort(.badRequest)`: If token expiration calculation fails.
    func generateTokens(for user: Users, on db: any Database) async throws -> (accessToken: AccessTokenPayload, refreshToken: RefreshTokens) {

        let accessToken = try generateAccessToken(for: user)
        
        guard let expirationDate = Calendar.current.date(byAdding: .day, value: 2, to: Date()) else {
            throw Abort(.badRequest)
        }
        let refreshToken = try RefreshTokens(
            userID: user.requireID(),
            token: [UInt8].random(count: 32).base64,
            expiresAt: expirationDate,
            isRevoked: false
        )
        
        try await refreshToken.save(on: db)
        
        return (accessToken, refreshToken)
    }
    
    /// Verifies a refresh token and returns associated data.
    ///
    /// This method validates a refresh token by checking if it exists in the database,
    /// is not revoked, and has not expired. If valid, it returns both the token and the
    /// associated user.
    ///
    /// - Parameters:
    ///   - token: The refresh token string to verify.
    ///   - db: The database to query for the token.
    ///
    /// - Returns: A tuple containing the validated refresh token and its associated user.
    ///
    /// - Throws:
    ///   - `Abort(.notFound)`: If the token doesn't exist in the database.
    ///   - `Abort(.unauthorized)`: If the token is revoked or expired.
    func verifyRefreshToken(_ token: String, on db: any Database) async throws -> (RefreshTokens, Users) {
        guard let storedToken = try await RefreshTokens.query(on: db)
            .filter(\.$token == token)
            .with(\.$user)
            .first() else {
            throw Abort(.notFound, reason: "Token not found")
        }
        
        guard !storedToken.isRevoked else {
            throw Abort(.unauthorized, reason: "Token revoked")
        }
        
        guard storedToken.expiresAt >= Date() else {
            throw Abort(.unauthorized, reason: "Token expired")
        }
        
        return (storedToken, storedToken.user)
    }
    
    /// Revokes a refresh token.
    ///
    /// This method marks a refresh token as revoked in the database, preventing it from
    /// being used for future authentication.
    ///
    /// - Parameters:
    ///   - token: The refresh token string to revoke.
    ///   - db: The database where the token is stored.
    ///
    /// - Throws:
    ///   - `Abort(.notFound)`: If the token doesn't exist in the database.
    ///   - Database errors that may occur during the update operation.
    func revokeRefreshToken(_ token: String, on db: any Database) async throws {
        guard let refreshToken = try await RefreshTokens.query(on: db)
            .filter(\.$token == token)
            .first() else {
            throw Abort(.notFound, reason: "Token not found")
        }
        
        refreshToken.isRevoked = true
        try await refreshToken.save(on: db)
    }
    
    /// Generates a new access token using a valid refresh token.
    ///
    /// This method creates a new access token for a user if their refresh token
    /// is valid and not expired.
    ///
    /// - Parameters:
    ///   - refreshToken: The refresh token string to use.
    ///   - db: The database to query for the token.
    ///
    /// - Returns: A new access token payload.
    ///
    /// - Throws:
    ///   - `Abort(.notFound)`: If the refresh token doesn't exist.
    ///   - `Abort(.unauthorized)`: If the token is invalid or expired.
    func refreshAccessToken(refreshToken: String, on db: any Database) async throws -> AccessTokenPayload {
        guard let token = try await RefreshTokens.query(on: db)
            .filter(\.$token == refreshToken)
            .with(\.$user)
            .first() else {
            throw Abort(.notFound, reason: "Refresh token not found")
        }
        
        guard token.isValid else {
            throw Abort(.unauthorized, reason: "Invalid or expired token")
        }
        
        return try generateAccessToken(for: token.user)
    }
    
    /// Generates a JWT access token for a user.
    ///
    /// Creates a signed JWT token containing user information and standard claims
    /// that can be used for API authorization.
    ///
    /// - Parameter user: The user for whom to generate the access token.
    ///
    /// - Returns: An access token payload that can be encoded into a JWT.
    ///
    /// - Throws:
    ///   - `Abort(.badRequest)`: If the user doesn't have an ID.
    ///   - `Abort(.badRequest)`: If token expiration calculation fails.
    ///   - JWT encoding errors.
    func generateAccessToken(for user: Users) throws -> AccessTokenPayload {
        guard let userId = user.id else {
            throw Abort(.badRequest, reason: "User without ID")
        }
        
        guard let date = Calendar.current.date(byAdding: .day, value: 2, to: Date()) else {
            throw Abort(.badRequest)
        }
        
        return try AccessTokenPayload(
            sub: SubjectClaim(value: user.requireID().uuidString),
            exp: ExpirationClaim(value: date),
            iss: IssuerClaim(value: "WellBiteAPI"),
            aud: AudienceClaim(value: ["com.cxcarvaj.WellBite"]),
            jti: JWKIdentifier(string: UUID().uuidString),
            userId: userId,
            email: user.email,
            role: user.role
        )
    }
}
